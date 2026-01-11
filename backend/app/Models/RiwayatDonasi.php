<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RiwayatDonasi extends Model
{
    protected $table = 'riwayat_donasi';
    
    protected $fillable = [
        'id_user', 'id_donasi', 'id_kampanye',
        'jumlah', 'pesan', 'anonim'
    ];

    protected $casts = [
        'jumlah' => 'decimal:2',
        'anonim' => 'boolean',
        'dibuat_pada' => 'datetime',
    ];

    const CREATED_AT = 'dibuat_pada';
    const UPDATED_AT = null;

    public function kampanye()
    {
        return $this->belongsTo(Kampanye::class, 'id_kampanye');
    }
}