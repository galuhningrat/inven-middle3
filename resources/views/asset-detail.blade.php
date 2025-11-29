<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Detail Aset - Inventaris STTI</title>
    @vite(['resources/css/app.css'])

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 1rem;
        }

        .detail-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 480px;
            overflow: hidden;
        }

        .table-header {
            background: #4f46e5;
            /* Primary Color */
            padding: 1.5rem;
            text-align: center;
        }

        .table-title {
            color: white;
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
        }

        .detail-content {
            padding: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .detail-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 1rem;
            border: 1px solid #e5e7eb;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #f3f4f6;
            padding-bottom: 0.5rem;
        }

        .label {
            color: #6b7280;
            font-size: 0.875rem;
        }

        .value {
            font-weight: 600;
            color: #111827;
            font-size: 0.875rem;
            text-align: right;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .tersedia {
            background-color: #d1fae5;
            color: #065f46;
        }

        .dipinjam {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .maintenance {
            background-color: #ffedd5;
            color: #9a3412;
        }

        .error-msg {
            text-align: center;
            color: #ef4444;
            padding: 2rem;
        }
    </style>
</head>

<body>

    <div class="detail-card">
        <div class="table-header">
            <h3 class="table-title">Detail Informasi Aset</h3>
        </div>

        <div class="detail-content">
            @if(isset($error))
                <div class="error-msg">
                    <svg style="width: 48px; height: 48px; margin-bottom: 1rem;" fill="none" stroke="currentColor"
                        viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z">
                        </path>
                    </svg>
                    <p>{{ $error }}</p>
                </div>
            @else
                <img src="{{ $asset->image ? Storage::url($asset->image) : asset('images/default-asset.png') }}"
                    alt="{{ $asset->name }}" class="detail-image"
                    onerror="this.src='{{ asset('images/default-asset.png') }}'">

                <div class="info-row" style="display: block; text-align: center; border: none;">
                    <h2 style="margin: 0; color: #1f2937;">{{ $asset->name }}</h2>
                    <p style="margin: 0.25rem 0 0; color: #6b7280; font-family: monospace;">{{ $asset->asset_id }}</p>
                </div>

                <div class="info-row">
                    <span class="label">Jenis Aset</span>
                    <span class="value">{{ $asset->assetType->name ?? '-' }}</span>
                </div>

                <div class="info-row">
                    <span class="label">Merek</span>
                    <span class="value">{{ $asset->brand }}</span>
                </div>

                <div class="info-row">
                    <span class="label">Nomor Seri</span>
                    <span class="value">{{ $asset->serial_number }}</span>
                </div>

                <div class="info-row">
                    <span class="label">Lokasi</span>
                    <span class="value">{{ $asset->location }}</span>
                </div>

                <div class="info-row">
                    <span class="label">Status</span>
                    <span class="value">
                        <span class="status-badge {{ strtolower($asset->status) }}">
                            {{ $asset->status }}
                        </span>
                    </span>
                </div>

                <div class="info-row">
                    <span class="label">Kondisi</span>
                    <span class="value">{{ $asset->condition }}</span>
                </div>

                <div class="info-row">
                    <span class="label">Tanggal Pembelian</span>
                    <span class="value">{{ $asset->purchase_date->format('d F Y') }}</span>
                </div>

                <div style="text-align: center; margin-top: 1rem;">
                    <p style="font-size: 0.75rem; color: #9ca3af;">Inventaris STT Indonesia Cirebon</p>
                </div>
            @endif
        </div>
    </div>

</body>

</html>