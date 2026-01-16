<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kampanye extends Model
{
    protected $table = 'kampanye';
    public $timestamps = false;
    
    protected $fillable = [
        'judul',
        'deskripsi',
        'kategori',
        'target_dana',
        'dana_terkumpul',
        'url_gambar',
        'status',
        'dibuat_oleh'
    ];

    protected $casts = [
        'target_dana' => 'decimal:2',
        'dana_terkumpul' => 'decimal:2',
    ];

    protected $appends = ['persentase', 'sisa_dana'];

    public function getPersentaseAttribute()
    {
        if ($this->target_dana == 0) return 0;
        return round(($this->dana_terkumpul / $this->target_dana) * 100, 2);
    }

    public function getSisaDanaAttribute()
    {
        return max(0, $this->target_dana - $this->dana_terkumpul);
    }
}