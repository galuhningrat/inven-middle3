<?php

namespace App\Http\Controllers;

use App\Models\Asset;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class AssetDetailController extends Controller
{
    public function show(Request $request)
    {
        // 1. Ambil parameter 'qrcode' dari URL (?qrcode=...)
        $qrCode = $request->query('qrcode');

        // 2. Jika tidak ada parameter qrcode
        if (!$qrCode) {
            return view('asset-detail', ['error' => 'QR Code tidak terdeteksi di URL.']);
        }

        // 3. Cari aset di database berdasarkan kolom qr_code
        // Kita gunakan with('assetType') agar nama jenis asetnya terbawa
        $asset = Asset::where('qr_code', $qrCode)->with('assetType')->first();

        // 4. Jika aset tidak ditemukan
        if (!$asset) {
            return view('asset-detail', ['error' => 'Aset dengan kode ini tidak ditemukan dalam sistem.']);
        }

        // 5. Jika ketemu, kirim data aset ke view
        return view('asset-detail', compact('asset'));
    }
}
