<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pengguna extends Model
{
    protected $table = 'pengguna';
    public $timestamps = false;
    
    protected $fillable = [
        'nama', 
        'email', 
        'password', 
        'telepon', 
        'foto_profil'
    ];

    protected $hidden = ['password'];
}