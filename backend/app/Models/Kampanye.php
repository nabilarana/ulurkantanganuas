<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kampanye extends Model
{
    protected $table = 'kampanye';
    
    protected $fillable = [
        'judul', 'deskripsi', 'kategori', 
        'target_dana', 'dana_terkumpul', 
        'url_gambar', 'status', 'dibuat_oleh'
    ];

    protected $casts = [
        'target_dana' => 'decimal:2',
        'dana_terkumpul' => 'decimal:2',
        'dibuat_pada' => 'datetime',
        'diperbarui_pada' => 'datetime',
    ];

    const CREATED_AT = 'dibuat_pada';
    const UPDATED_AT = 'diperbarui_pada';

    public function user()
    {
        return $this->belongsTo(User::class, 'dibuat_oleh');
    }

    public function donasi()
    {
        return $this->hasMany(Donasi::class, 'id_kampanye');
    }
}