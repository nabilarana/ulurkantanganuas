<?php

namespace App\Http\Controllers;

use App\Models\Donasi;
use App\Models\Kampanye;
use App\Models\RiwayatDonasi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class DonasiController extends Controller
{
    /**
     * Store - Buat donasi baru
     * 
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        
        $validator = Validator::make($request->all(), [
            'id_pengguna' => 'required|integer|exists:pengguna,id',
            'id_kampanye' => 'required|integer|exists:kampanye,id',
            'jumlah' => 'required|numeric|min:10000',
            'pesan' => 'nullable|string|max:500',
            'anonim' => 'boolean',
        ], [
            'id_pengguna.required' => 'ID pengguna wajib diisi',
            'id_pengguna.exists' => 'Pengguna tidak ditemukan',
            'id_kampanye.required' => 'ID kampanye wajib diisi',
            'id_kampanye.exists' => 'Kampanye tidak ditemukan',
            'jumlah.required' => 'Jumlah donasi wajib diisi',
            'jumlah.min' => 'Minimal donasi adalah Rp 10.000',
        ]);

       
        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
         
            DB::beginTransaction();

            
            $kampanye = Kampanye::find($request->id_kampanye);
            
            if ($kampanye->status != 'aktif') {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Kampanye sudah tidak aktif'
                ], 400);
            }

           
            $donasi = Donasi::create([
                'id_pengguna' => $request->id_pengguna,
                'id_kampanye' => $request->id_kampanye,
                'jumlah' => $request->jumlah,
                'pesan' => $request->pesan,
                'anonim' => $request->anonim ?? false,
                'status' => 'selesai',
            ]);

            $kampanye->dana_terkumpul += $request->jumlah;
            
            if ($kampanye->dana_terkumpul >= $kampanye->target_dana) {
                $kampanye->status = 'selesai';
            }
            
            $kampanye->save();

           
            RiwayatDonasi::create([
                'id_pengguna' => $request->id_pengguna,
                'id_donasi' => $donasi->id,
                'id_kampanye' => $request->id_kampanye,
                'jumlah' => $request->jumlah,
                'pesan' => $request->pesan,
                'anonim' => $request->anonim ?? false,
            ]);

          
            DB::commit();

           
            $donasi->load('kampanye:id,judul,url_gambar');

            return response()->json([
                'status' => 'success',
                'message' => 'Donasi berhasil! Terima kasih atas kebaikan Anda.',
                'data' => [
                    'id' => $donasi->id,
                    'jumlah' => $donasi->jumlah,
                    'kampanye' => $donasi->kampanye,
                    'pesan' => $donasi->pesan,
                    'anonim' => $donasi->anonim,
                    'dibuat_pada' => $donasi->dibuat_pada,
                ]
            ], 201);

        } catch (\Exception $e) {
           
            DB::rollBack();
            
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memproses donasi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get History - Ambil riwayat donasi user
     * 
     * @param int $userId
     * @return \Illuminate\Http\JsonResponse
     */
    public function getHistory($userId)
    {
        try {
           
            $riwayat = RiwayatDonasi::where('id_pengguna', $userId)
                ->with([
                    'kampanye:id,judul,url_gambar,kategori,status',
                    'donasi:id,jumlah,status'
                ])
                ->orderBy('dibuat_pada', 'desc')
                ->get();

           
            $totalDonasi = $riwayat->sum('jumlah');
            $totalKampanye = $riwayat->unique('id_kampanye')->count();

            return response()->json([
                'status' => 'success',
                'message' => 'Riwayat donasi berhasil dimuat',
                'summary' => [
                    'total_donasi' => $totalDonasi,
                    'total_kampanye' => $totalKampanye,
                    'total_transaksi' => $riwayat->count(),
                ],
                'data' => $riwayat
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat riwayat: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete History - Hapus riwayat donasi
     * 
     * @param int $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function deleteHistory($id)
    {
        try {
            
            $riwayat = RiwayatDonasi::find($id);

            if (!$riwayat) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Riwayat tidak ditemukan'
                ], 404);
            }

           
            $riwayat->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Riwayat berhasil dihapus'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus riwayat: ' . $e->getMessage()
            ], 500);
        }
    }
}