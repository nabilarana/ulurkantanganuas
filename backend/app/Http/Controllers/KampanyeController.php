<?php

namespace App\Http\Controllers;

use App\Models\Kampanye;
use Illuminate\Http\Request;

class KampanyeController extends Controller
{
    public function index()
    {
        try {
            $kampanye = Kampanye::select(
                'id',
                'judul',
                'deskripsi',
                'kategori',
                'target_dana',
                'dana_terkumpul',
                'url_gambar',
                'status',
                'dibuat_oleh',
                'dibuat_pada',
                'diperbarui_pada'
            )
            ->orderBy('dibuat_pada', 'desc')
            ->get();

            
            $kampanye = $kampanye->map(function($item) {
                $item->persentase = $item->target_dana > 0 
                    ? round(($item->dana_terkumpul / $item->target_dana) * 100, 2) 
                    : 0;
                $item->sisa_dana = max(0, $item->target_dana - $item->dana_terkumpul);
                return $item;
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Data kampanye berhasil dimuat',
                'total' => $kampanye->count(),
                'data' => $kampanye
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat kampanye: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $kampanye = Kampanye::select(
                'id',
                'judul',
                'deskripsi',
                'kategori',
                'target_dana',
                'dana_terkumpul',
                'url_gambar',
                'status',
                'dibuat_oleh',
                'dibuat_pada',
                'diperbarui_pada'
            )
            ->find($id);

            if (!$kampanye) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Kampanye tidak ditemukan'
                ], 404);
            }

           
            $kampanye->persentase = $kampanye->target_dana > 0 
                ? round(($kampanye->dana_terkumpul / $kampanye->target_dana) * 100, 2) 
                : 0;
            $kampanye->sisa_dana = max(0, $kampanye->target_dana - $kampanye->dana_terkumpul);

            return response()->json([
                'status' => 'success',
                'message' => 'Detail kampanye berhasil dimuat',
                'data' => $kampanye
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat kampanye: ' . $e->getMessage()
            ], 500);
        }
    }
}