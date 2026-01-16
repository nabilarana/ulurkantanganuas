<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pengguna extends Model
{
    protected $table = 'pengguna';
    
    protected $fillable = [
        'nama', 
        'email', 
        'password', 
        'telepon', 
        'foto_profil'
    ];

    protected $hidden = ['password'];

    protected $casts = [
        'dibuat_pada' => 'datetime',
        'diperbarui_pada' => 'datetime',
    ];

    const CREATED_AT = 'dibuat_pada';
    const UPDATED_AT = 'diperbarui_pada';

    public function kampanye()
    {
        return $this->hasMany(Kampanye::class, 'dibuat_oleh');
    }

    public function donasi()
    {
        return $this->hasMany(Donasi::class, 'id_pengguna');
    }

    public function riwayatDonasi()
    {
        return $this->hasMany(RiwayatDonasi::class, 'id_pengguna');
    }
}