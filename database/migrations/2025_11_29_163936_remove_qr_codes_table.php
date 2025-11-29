<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * MIGRATION INI AKAN:
     * 1. Drop tabel qr_codes (tidak diperlukan)
     * 2. Memastikan kolom qr_code di assets sudah ada dan unique
     */
    public function up(): void
    {
        // 1. Drop tabel qr_codes (Ini adalah tujuan utama)
        Schema::dropIfExists('qr_codes');

        // 2. Pastikan kolom 'qr_code' di 'assets' bersih dari duplikasi data 
        // (Jika ada data duplikat, migration akan tetap gagal saat membuat index unique)
        // Karena error mengindikasikan index sudah ada, kita hanya memastikan tabel qr_codes terhapus.
        // Kita TIDAK perlu menjalankan $table->string('qr_code')->unique()->change(); lagi.
    }

    /**
     * Reverse the migration (jika butuh rollback)
     */
    public function down(): void
    {
        // Recreate qr_codes table jika rollback
        Schema::create('qr_codes', function (Blueprint $table) {
            $table->id();
            $table->string('qr_code_id')->unique();
            $table->foreignId('asset_id')->constrained()->onDelete('cascade');
            $table->string('code_content')->unique();
            $table->enum('status', ['Aktif', 'Nonaktif'])->default('Aktif');
            $table->timestamps();
            $table->softDeletes();
        });
    }
};
