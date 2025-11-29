<div class="asset-detail-modal-content">
    <div style="display: grid; grid-template-columns: 200px 1fr; gap: 2rem; margin-bottom: 2rem;">
        <div>
            <!-- Tampilkan Gambar Aset -->
            <img src="{{ $asset->image ? Storage::url($asset->image) : asset('assets/default-asset.png') }}"
                alt="{{ $asset->name }}" style="width: 100%; border-radius: 12px; box-shadow: var(--shadow);">
        </div>
        <div>
            <h3 style="margin-bottom: 1rem; color: var(--text-primary);">{{ $asset->name }}</h3>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">ID Aset</p>
                    <p style="font-weight: 600;">{{ $asset->asset_id }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Jenis</p>
                    <p style="font-weight: 600;">{{ $asset->assetType->name ?? '-' }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Merek</p>
                    <p style="font-weight: 600;">{{ $asset->brand }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Nomor Seri</p>
                    <p style="font-weight: 600;">{{ $asset->serial_number }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Lokasi</p>
                    <p style="font-weight: 600;">{{ $asset->location }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Kondisi</p>
                    <p style="font-weight: 600;">{{ $asset->condition }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Tanggal Beli
                    </p>
                    <p style="font-weight: 600;">{{ \Carbon\Carbon::parse($asset->purchase_date)->format('d F Y') }}</p>
                </div>
                <div>
                    <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Harga Beli</p>
                    <p style="font-weight: 600;">Rp {{ number_format($asset->price, 0, ',', '.') }}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Status dan Peminjaman Aktif -->
    <h4
        style="margin-bottom: 0.75rem; padding-bottom: 0.5rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary);">
        Status Aset
    </h4>
    <div style="display: flex; gap: 2rem; align-items: center; margin-bottom: 1.5rem;">
        <div>
            <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Status Saat Ini</p>
            <span class="status-badge 
                @if($asset->status === 'Tersedia') available 
                @elseif($asset->status === 'Dipinjam') borrowed 
                @elseif($asset->status === 'Dalam Perbaikan') maintenance 
                @endif" style="font-size: 1rem; padding: 0.25rem 0.75rem; border-radius: 8px;">
                {{ $asset->status }}
            </span>
        </div>

        @php
            // Ambil peminjaman aktif yang dimuat oleh AssetController@showModal
            $activeBorrowing = $asset->borrowings->first();
        @endphp

        <!-- PERBAIKAN: Gunakan optional($activeBorrowing) untuk menghindari error jika tidak ada peminjaman -->
        @if ($activeBorrowing)
            <div>
                <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Sedang Dipinjam Oleh
                </p>
                <p style="font-weight: 600; color: var(--danger-color);">
                    {{ $activeBorrowing->user->name ?? 'Pengguna Tidak Dikenal' }}</p>
            </div>
            <div>
                <p style="font-size: 0.75rem; color: var(--text-secondary); margin-bottom: 0.25rem;">Jatuh Tempo</p>
                <p style="font-weight: 600; color: var(--danger-color);">
                    {{ \Carbon\Carbon::parse($activeBorrowing->due_date)->format('d F Y') }}</p>
            </div>
        @endif
    </div>

    <!-- Tombol Aksi -->
    <div class="btn-group"
        style="justify-content: flex-end; padding-top: 1rem; border-top: 1px solid var(--border-color);">
        <button class="btn btn-secondary"
            onclick="printAssetQrCode('{{ $asset->name }}', '{{ $asset->qr_code }}', '{{ $asset->qr_code_url }}')">
            Cetak QR Code
        </button>
        <a href="{{ route('assets-inv.edit', $asset) }}" class="btn btn-primary">Edit Aset</a>
        <a href="{{ route('assets-inv.show', $asset) }}" class="btn btn-info">Lihat Detail Penuh</a>
    </div>
</div>

{{-- Skrip untuk fungsi Cetak QR Code --}}
<script>
    // Asumsi script QRCode.js sudah dimuat di layout utama
    function printAssetQrCode(assetName, qrCode, qrUrl) {
        // PERBAIKAN: Gunakan fungsi window.open dan print
        const printWindow = window.open('', '_blank', 'width=300,height=300');

        // Membangun konten HTML untuk dicetak
        printWindow.document.write(`
            <html>
            <head>
                <title>Cetak QR Code</title>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<style>
    @page {
        size: 70mm 45mm;
        margin: 0;
    }

    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100vw;
        height: 100vh;
        overflow: hidden;
    }

    .label-container {
        text-align: center;
        width: 70mm;
        height: 45mm;
        padding: 2mm;
        box-sizing: border-box;
    }

    .institution-name {
        font-weight: bold;
        font-size: 7pt;
        margin: 0;
        color: #333;
    }

    .asset-name {
        font-weight: bold;
        font-size: 9pt;
        margin: 1mm 0;
        color: #000;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    #qrcode {
        margin-top: 2mm;
        display: flex;
        justify-content: center;
        margin: 0 auto;
        width: 30mm;
        height: 30mm;
    }

    #qrcode img {
        width: 30mm !important;
        height: 30mm !important;
    }

    .code-number {
        font-size: 7pt;
        letter-spacing: 1px;
        margin-top: 1mm;
        color: #555;
    }
</style>
</head>

<body>
    <div class="label-container">
        <div class="institution-name">Inventaris STT Indonesia Cirebon</div>
        <div class="asset-name">${assetName}</div>
        <div id="qrcode"></div>
        <div class="code-number">${qrCode}</div>
    </div>
    <script>
                    window.onload = function() {
                        new QRCode(document.getElementById("qrcode"), {
                            text: "${qrUrl}",
                            width: 128,
                            height: 128,
                            correctLevel: QRCode.CorrectLevel.H
                        });
                        setTimeout(() => {
                            window.focus();
                            window.print();
                            // window.close(); // Biarkan user menutup jika sudah selesai cetak
                        }, 500);
                    };
                </\script>
            </body>
            </html>
        `);
            printWindow.document.close();
        }
    </script>