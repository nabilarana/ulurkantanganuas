<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Donasi extends Model
{
    protected $table = 'donasi';
    
    protected $fillable = [
        'id_user', 'id_kampanye', 'jumlah', 
        'pesan', 'anonim', 'status'
    ];

    protected $casts = [
        'jumlah' => 'decimal:2',
        'anonim' => 'boolean',
        'dibuat_pada' => 'datetime',
    ];

    const CREATED_AT = 'dibuat_pada';
    const UPDATED_AT = null; 

    public function user()
    {
        return $this->belongsTo(user::class, 'id_user');
    }

    public function kampanye()
    {
        return $this->belongsTo(Kampanye::class, 'id_kampanye');
    }
}