<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Asset extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'asset_id',
        'name',
        'asset_type_id',
        'brand',
        'serial_number',
        'price',
        'purchase_date',
        'location',
        'condition',
        'status',
        'image',
        'qr_code', // QR code adalah kolom biasa, bukan relasi!
    ];

    protected $casts = [
        'purchase_date' => 'date',
        'price' => 'decimal:2',
    ];

    public function assetType()
    {
        return $this->belongsTo(AssetType::class);
    }

    public function borrowings()
    {
        return $this->hasMany(Borrowing::class);
    }

    public function maintenances()
    {
        return $this->hasMany(Maintenance::class);
    }

    /**
     * Generate QR Code URL untuk asset ini
     */
    public function getQrCodeUrlAttribute()
    {
        return route('asset.detail', ['qrcode' => $this->qr_code]);
    }
}
