<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RiwayatDonasi extends Model
{
    protected $table = 'riwayat_donasi';
    
    protected $fillable = [
        'id_pengguna',
        'id_donasi',
        'id_kampanye',
        'jumlah',
        'pesan',
        'anonim'
    ];

    protected $casts = [
        'jumlah' => 'decimal:2',
        'anonim' => 'boolean',
        'dibuat_pada' => 'datetime',
    ];

    const CREATED_AT = 'dibuat_pada';
    const UPDATED_AT = null;

    public function pengguna()
    {
        return $this->belongsTo(Pengguna::class, 'id_pengguna');
    }

    public function donasi()
    {
        return $this->belongsTo(Donasi::class, 'id_donasi');
    }

    public function kampanye()
    {
        return $this->belongsTo(Kampanye::class, 'id_kampanye');
    }
}