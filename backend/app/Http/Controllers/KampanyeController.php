<?php

namespace App\Http\Controllers;

use App\Models\Kampanye;
use Illuminate\Http\Request;

class KampanyeController extends Controller
{
    public function index()
    {
        $kampanye = Kampanye::where('status', 'aktif')
            ->orderBy('dibuat_pada', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Data kampanye berhasil dimuat',
            'data' => $kampanye
        ]);
    }

    public function show($id)
    {
        $kampanye = Kampanye::find($id);

        if (!$kampanye) {
            return response()->json([
                'status' => 'error',
                'message' => 'Kampanye tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Detail kampanye',
            'data' => $kampanye
        ]);
    }
}