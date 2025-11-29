@extends('layouts.app')

@section('title', 'Manajemen Aset')
@section('page-title', 'Manajemen Aset')

@section('content')
    <div class="page-container"> {{-- Tambahkan container wrapper --}}
        <!-- Bulk Action Bar -->
        <div class="bulk-action-bar" id="bulkActionBar">
            <!-- existing content -->
        </div>

        {{-- <div class="data-table-container">
            <div class="table-header">

            </div>
            <!-- rest of content -->
        </div> --}}
    </div>

    <!-- Bulk Action Bar -->
    <div class="bulk-action-bar" id="bulkActionBar">
        <p><span id="selectedCount">0</span> aset dipilih</p>
        <div style="display: flex; gap: 0.5rem;">
            <button class="btn" onclick="cancelBulkMode()">Batal</button>
            <button class="btn btn-danger" onclick="bulkDelete()">Hapus Terpilih</button>
        </div>
    </div>

    <div class="data-table-container">
        <div class="table-header">
            <h3 class="table-title">Manajemen Data Aset</h3>
            <div style="display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
                <div class="search-box">
                    <span class="search-icon">🔍</span>
                    <input type="text" class="search-input" id="assetSearch" placeholder="Cari aset..."
                        value="{{ request('search') }}">
                </div>
                <select class="form-control" id="filterStatus" style="width: auto; min-width: 150px;">
                    <option value="">Semua Status</option>
                    <option value="Tersedia" {{ request('status') === 'Tersedia' ? 'selected' : '' }}>Tersedia</option>
                    <option value="Dipinjam" {{ request('status') === 'Dipinjam' ? 'selected' : '' }}>Dipinjam</option>
                    <option value="Maintenance" {{ request('status') === 'Maintenance' ? 'selected' : '' }}>Maintenance
                    </option>
                </select>
                <select class="form-control" id="filterType" style="width: auto; min-width: 150px;">
                    <option value="">Semua Jenis</option>
                    @foreach($assetTypes as $type)
                        <option value="{{ $type->code }}" {{ request('type') === $type->code ? 'selected' : '' }}>
                            {{ $type->name }}
                        </option>
                    @endforeach
                </select>
                <a href="{{ route('assets-inv.create') }}" class="btn btn-primary">+ Tambah Aset</a>
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table" id="assetsTable">
                <thead>
                    <tr>
                        <th class="col-checkbox" style="width: 40px;">
                            <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                        </th>
                        <th>ID Aset</th>
                        <th>Gambar</th>
                        <th>Nama Aset</th>
                        <th>Jenis</th>
                        <th>Merek</th>
                        <th>Lokasi</th>
                        <th>Kondisi</th>
                        <th>Status</th>
                        <th>Harga</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($assets as $asset)
                        <tr>
                            <td class="col-checkbox">
                                <input type="checkbox" class="asset-checkbox" value="{{ $asset->id }}"
                                    onchange="updateSelectedCount()">
                            </td>
                            <td><strong>{{ $asset->asset_id }}</strong></td>
                            <td>
                                <img src="{{ $asset->image ? Storage::url($asset->image) : asset('assets/default-asset.png') }}"
                                    alt="{{ $asset->name }}" class="asset-image-preview"
                                    style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;">
                            </td>
                            <td>{{ $asset->name }}</td>
                            <td>{{ $asset->assetType->name ?? '-' }}</td>
                            <td>{{ $asset->brand }}</td>
                            <td>{{ $asset->location }}</td>
                            <td>
                                <span
                                    class="status-badge {{ $asset->condition === 'Baik' ? 'available' : ($asset->condition === 'Rusak Ringan' ? 'borrowed' : 'maintenance') }}">
                                    {{ $asset->condition }}
                                </span>
                            </td>
                            <td>
                                <span
                                    class="status-badge {{ $asset->status === 'Tersedia' ? 'available' : ($asset->status === 'Dipinjam' ? 'borrowed' : 'maintenance') }}">
                                    {{ $asset->status }}
                                </span>
                            </td>
                            <td><span class="price-display">Rp {{ number_format($asset->price, 0, ',', '.') }}</span></td>
                            <td>
                                <div class="action-buttons">
                                    <button onclick="showAssetDetail({{ $asset->id }})"
                                        class="btn btn-secondary">Detail</button>
                                    <a href="{{ route('assets-inv.edit', $asset) }}" class="btn btn-primary">Edit</a>
                                    <form action="{{ route('assets-inv.destroy', $asset) }}" method="POST"
                                        style="display: inline;"
                                        onsubmit="return confirm('Apakah Anda yakin ingin menghapus aset ini?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger">Hapus</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="11" style="text-align: center; padding: 2rem;">
                                <div style="color: var(--text-secondary);">
                                    <p style="font-size: 3rem; margin-bottom: 1rem;">📦</p>
                                    <p>Tidak ada data aset.</p>
                                    <a href="{{ route('assets-inv.create') }}" class="btn btn-primary"
                                        style="margin-top: 1rem;">+ Tambah Aset Pertama</a>
                                </div>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- NO PAGINATION - Show Total Only -->
        <div style="padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;">
            <div style="color: var(--text-secondary); font-size: 0.875rem;">
                Total: <strong>{{ $assets->count() }}</strong> aset
            </div>
        </div>
    </div>

    <!-- Easy Touch Button (Mobile/Tablet) -->
    <div class="easy-touch-button" id="easyTouchBtn">
        <img src="{{ asset('assets/logo-stti.png') }}" alt="Quick Menu">
    </div>

    <!-- Easy Touch Menu -->
    <div class="easy-touch-menu" id="easyTouchMenu">
        <div class="menu-item" onclick="toggleBulkMode()" title="Mode Pilih">
            <span class="icon">☑️</span>
        </div>
        <div class="menu-item" onclick="window.location.href='{{ route('assets-inv.create') }}'" title="Tambah Aset">
            <span class="icon">➕</span>
        </div>
        <div class="menu-item" onclick="exportAssets()" title="Export">
            <span class="icon">📥</span>
        </div>
        <div class="menu-item" onclick="scrollToTop()" title="Scroll ke Atas">
            <span class="icon">⬆️</span>
        </div>
    </div>

    <div id="assetDetailModal" class="modal" style="display: none;">
        <div class="modal-content" style="max-width: 800px;">
            <div class="modal-header">
                <h3 class="modal-title">Detail Aset</h3>
                <button class="close-modal" onclick="closeAssetModal()">×</button>
            </div>
            <div class="modal-body" id="assetDetailContent">
                <p style="text-align: center; padding: 2rem;">Loading...</p>
            </div>
        </div>
    </div>

@endsection

@push('styles')
    <style>
        .page-container {
            width: 100%;
            max-width: 100%;
            overflow-x: hidden;
        }

        .table-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        @media screen and (max-width: 1024px) {
            .table-actions {
                flex-direction: column;
                width: 100%;
            }

            .table-actions .search-box,
            .table-actions .filter-select,
            .table-actions .btn {
                width: 100%;
            }
        }

        @media screen and (max-width: 768px) {
            .table-header {
                flex-direction: column;
                gap: 1rem;
            }

            .table-title {
                text-align: center;
            }
        }
    </style>
@endpush

@push('scripts')
    <script>
        let bulkModeActive = false;
        let selectedAssets = [];

        // Initialize
        document.addEventListener('DOMContentLoaded', function () {
            console.log('DOM loaded - initializing asset management');

            const searchInput = document.getElementById('assetSearch');
            let searchTimeout;

            // Search functionality
            if (searchInput) {
                searchInput.addEventListener('input', function () {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        applyFilters();
                    }, 500);
                });
            }

            // Filter functionality
            const filterStatus = document.getElementById('filterStatus');
            const filterType = document.getElementById('filterType');

            if (filterStatus) filterStatus.addEventListener('change', applyFilters);
            if (filterType) filterType.addEventListener('change', applyFilters);

            // Easy Touch Button
            const easyTouchBtn = document.getElementById('easyTouchBtn');
            const easyTouchMenu = document.getElementById('easyTouchMenu');

            if (easyTouchBtn) {
                easyTouchBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    easyTouchMenu.classList.toggle('active');
                });
            }

            // Close menu when clicking outside
            document.addEventListener('click', function () {
                const easyTouchMenu = document.getElementById('easyTouchMenu');
                if (easyTouchMenu) {
                    easyTouchMenu.classList.remove('active');
                }
            });

            // Show easy touch button on mobile/tablet
            if (window.innerWidth <= 1024 && easyTouchBtn) {
                easyTouchBtn.style.display = 'flex';
            }
        });

        function closeAssetModal() {
            const modal = document.getElementById('assetDetailModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function showAssetDetail(assetId) {
            console.log('showAssetDetail called with ID:', assetId);

            const modal = document.getElementById('assetDetailModal');
            const content = document.getElementById('assetDetailContent');

            if (!modal || !content) {
                console.error('Modal elements not found');
                alert('Error: Modal tidak ditemukan');
                return;
            }

            // Tampilkan loading dan modal
            content.innerHTML = '<div style="text-align: center; padding: 3rem;"><div class="loading-spinner"></div><p>Loading detail aset...</p></div>';
            modal.style.display = 'flex';

            // URL untuk fetch data modal - PASTIKAN ROUTE INI SESUAI
            const url = `{{ url('assets-inv/modal-detail') }}/${assetId}`;
            console.log('Fetching from URL:', url);

            fetch(url, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'text/html',
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.text();
                })
                .then(html => {
                    console.log('Successfully loaded modal content');
                    content.innerHTML = html;

                    // Re-execute scripts in the loaded content
                    const scripts = content.querySelectorAll('script');
                    scripts.forEach(script => {
                        const newScript = document.createElement('script');
                        if (script.src) {
                            newScript.src = script.src;
                        } else {
                            newScript.text = script.text;
                        }
                        document.body.appendChild(newScript).parentNode.removeChild(newScript);
                    });
                })
                .catch(error => {
                    console.error('Error loading asset detail:', error);
                    content.innerHTML = `
                                <div style="text-align: center; padding: 2rem;">
                                    <p style="color: var(--danger-color); margin-bottom: 1rem;">
                                        Gagal memuat detail aset. Silakan coba lagi.
                                    </p>
                                    <button class="btn btn-secondary" onclick="closeAssetModal()">Tutup</button>
                                </div>
                            `;
                });
        }

        function applyFilters() {
            const search = document.getElementById('assetSearch')?.value || '';
            const status = document.getElementById('filterStatus')?.value || '';
            const type = document.getElementById('filterType')?.value || '';

            const params = new URLSearchParams();
            if (search) params.append('search', search);
            if (status) params.append('status', status);
            if (type) params.append('type', type);

            window.location.href = '{{ route('assets-inv.index') }}?' + params.toString();
        }

        // ... (fungsi lainnya tetap sama)
        function toggleBulkMode() {
            bulkModeActive = !bulkModeActive;
            const table = document.getElementById('assetsTable');
            const bulkBar = document.getElementById('bulkActionBar');

            if (bulkModeActive) {
                table.classList.add('bulk-mode-active');
                bulkBar.classList.add('active');
            } else {
                table.classList.remove('bulk-mode-active');
                bulkBar.classList.remove('active');
                document.querySelectorAll('.asset-checkbox').forEach(cb => cb.checked = false);
                document.getElementById('selectAll').checked = false;
                updateSelectedCount();
            }

            const easyTouchMenu = document.getElementById('easyTouchMenu');
            if (easyTouchMenu) {
                easyTouchMenu.classList.remove('active');
            }
        }

        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.asset-checkbox');
            checkboxes.forEach(cb => {
                cb.checked = selectAll.checked;
            });
            updateSelectedCount();
        }

        function updateSelectedCount() {
            const checked = document.querySelectorAll('.asset-checkbox:checked');
            selectedAssets = Array.from(checked).map(cb => cb.value);
            document.getElementById('selectedCount').textContent = selectedAssets.length;
        }

        // Close modal when clicking outside
        document.addEventListener('click', function (event) {
            const modal = document.getElementById('assetDetailModal');
            if (event.target === modal) {
                closeAssetModal();
            }
        });

        // Close modal with Escape key
        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closeAssetModal();
            }
        });
    </script>
@endpush