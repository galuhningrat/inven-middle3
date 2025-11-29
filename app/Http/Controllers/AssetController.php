<?php

namespace App\Http\Controllers;

use App\Models\Asset;
use App\Models\AssetType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AssetController extends Controller
{
    public function index(Request $request)
    {
        $query = Asset::with('assetType');

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('asset_id', 'ILIKE', "%{$search}%")
                    ->orWhere('name', 'ILIKE', "%{$search}%")
                    ->orWhere('brand', 'ILIKE', "%{$search}%")
                    ->orWhere('location', 'ILIKE', "%{$search}%")
                    ->orWhere('serial_number', 'ILIKE', "%{$search}%");
            });
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('type')) {
            $query->whereHas('assetType', function ($q) use ($request) {
                $q->where('code', $request->type);
            });
        }

        $assets = $query->orderBy('created_at', 'desc')->get();
        $assetTypes = AssetType::all();

        return view('assets-inv.index', compact('assets', 'assetTypes'));
    }

    public function create()
    {
        $assetTypes = AssetType::all();
        $locations = ['Ruang IT', 'Laboratorium', 'Perpustakaan', 'Aula', 'Ruang Dosen'];
        return view('assets-inv.create', compact('assetTypes', 'locations'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'asset_type_id' => 'required|exists:asset_types,id',
            'brand' => 'required|string|max:255',
            'serial_number' => 'required|string|unique:assets,serial_number',
            'price' => 'required|numeric|min:0',
            'purchase_date' => 'required|date',
            'location' => 'required|string|max:255',
            'condition' => 'required|in:Baik,Rusak Ringan,Rusak Berat',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        DB::beginTransaction();

        try {
            $assetType = AssetType::find($request->asset_type_id);
            $year = date('Y');
            $month = date('m');

            // ---------------------------------------------------------
            // FIX LOGIC GENERATE ID (POSTGRESQL SAFE & SOFT DELETE AWARE)
            // ---------------------------------------------------------

            // 1. Cari prefix ID untuk bulan ini
            $prefix = sprintf('%s/%s/%s-', $year, $month, $assetType->code);

            // 2. Ambil angka terbesar dari aset (TERMASUK YANG DIHAPUS/SOFT DELETED)
            // Menggunakan REGEX '([0-9]+)$' untuk mengambil angka di paling belakang string
            $maxId = Asset::withTrashed() // <--- KUNCI PERBAIKAN: Sertakan aset yang dihapus
                ->where('asset_id', 'LIKE', $prefix . '%')
                ->selectRaw("MAX(CAST(SUBSTRING(asset_id FROM '([0-9]+)$') AS INTEGER)) as max_num")
                ->value('max_num');

            // 3. Tambah 1 dari nilai max, atau mulai dari 1 jika belum ada
            $counter = $maxId ? ($maxId + 1) : 1;

            // 4. Format ulang ID: 2025/11/FUR-0003
            $validated['asset_id'] = sprintf('%s%04d', $prefix, $counter);

            // ---------------------------------------------------------

            // Generate QR Code LANGSUNG
            $validated['qr_code'] = $this->generateUniqueQrCode($assetType->code);
            $validated['status'] = 'Tersedia';

            if ($request->hasFile('image')) {
                $imagePath = $request->file('image')->store('assets', 'public');
                $validated['image'] = $imagePath;
            }

            Asset::create($validated);

            DB::commit();

            return redirect()->route('assets-inv.index')
                ->with('success', 'Aset berhasil ditambahkan!');
        } catch (\Exception $e) {
            DB::rollback();

            return redirect()->back()
                ->withInput()
                ->with('error', 'Gagal menambahkan aset: ' . $e->getMessage());
        }
    }

    public function showModalDetail(Asset $asset)
    {
        // Load relasi yang diperlukan untuk modal
        $asset->load([
            'assetType',
            'borrowings' => function ($query) {
                $query->where('status', 'Dipinjam')
                    ->with('user');
            }
        ]);

        // Cek jika request AJAX
        if (request()->ajax()) {
            return view('assets-inv.modal-detail', compact('asset'));
        }

        // Fallback untuk non-AJAX request
        return redirect()->route('assets-inv.show', $asset);
    }

    public function show(Asset $asset)
    {
        $asset->load(['assetType', 'borrowings', 'maintenances']);
        return view('assets-inv.show', compact('asset'));
    }

    public function edit(Asset $asset)
    {
        $assetTypes = AssetType::all();
        $locations = ['Ruang IT', 'Laboratorium', 'Perpustakaan', 'Aula', 'Ruang Dosen'];
        return view('assets-inv.edit', compact('asset', 'assetTypes', 'locations'));
    }

    public function update(Request $request, Asset $asset)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'asset_type_id' => 'required|exists:asset_types,id',
            'brand' => 'required|string|max:255',
            'serial_number' => 'required|string|unique:assets,serial_number,' . $asset->id,
            'price' => 'required|numeric|min:0',
            'purchase_date' => 'required|date',
            'location' => 'required|string|max:255',
            'condition' => 'required|in:Baik,Rusak Ringan,Rusak Berat',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($request->hasFile('image')) {
            if ($asset->image && Storage::disk('public')->exists($asset->image)) {
                Storage::disk('public')->delete($asset->image);
            }
            $imagePath = $request->file('image')->store('assets', 'public');
            $validated['image'] = $imagePath;
        }

        $asset->update($validated);

        return redirect()->route('assets-inv.index')
            ->with('success', 'Aset berhasil diupdate!');
    }

    public function destroy(Asset $asset)
    {
        try {
            if ($asset->image && Storage::disk('public')->exists($asset->image)) {
                Storage::disk('public')->delete($asset->image);
            }

            $asset->delete();

            return redirect()->route('assets-inv.index')
                ->with('success', 'Aset berhasil dihapus!');
        } catch (\Exception $e) {
            return redirect()->route('assets-inv.index')
                ->with('error', 'Gagal menghapus aset: ' . $e->getMessage());
        }
    }

    public function generateQrCode(Request $request)
    {
        $assetType = AssetType::find($request->asset_type_id);
        $qrCode = $this->generateUniqueQrCode($assetType->code);

        return response()->json(['qr_code' => $qrCode]);
    }

    private function generateUniqueQrCode($typeCode)
    {
        $attempts = 0;
        do {
            $timestamp = base_convert(time() + $attempts, 10, 36);
            $random = strtoupper(Str::random(6));
            $qrCode = "{$typeCode}-{$timestamp}-{$random}";

            $exists = Asset::where('qr_code', $qrCode)->exists();
            $attempts++;
        } while ($exists && $attempts < 10);

        return $qrCode;
    }

    public function bulkDelete(Request $request)
    {
        try {
            $ids = $request->ids;
            $deleted = 0;

            DB::beginTransaction();

            foreach ($ids as $id) {
                $asset = Asset::find($id);
                if ($asset) {
                    if ($asset->image && Storage::disk('public')->exists($asset->image)) {
                        Storage::disk('public')->delete($asset->image);
                    }
                    $asset->delete();
                    $deleted++;
                }
            }

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => "{$deleted} aset berhasil dihapus."
            ]);
        } catch (\Exception $e) {
            DB::rollback();

            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus aset: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Print QR Code untuk asset
     */
    public function printQrCode(Asset $asset)
    {
        return view('assets-inv.print-qr', compact('asset'));
    }
}
