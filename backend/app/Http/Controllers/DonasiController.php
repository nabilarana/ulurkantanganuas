<?php

namespace App\Http\Controllers;

use App\Models\Donasi;
use App\Models\Kampanye;
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
           
            $donations = Donasi::where('id_pengguna', $userId)
                ->with([
                    'kampanye:id,judul,url_gambar,kategori,status',
                ])
                ->orderBy('dibuat_pada', 'desc')
                ->get();

           
            $totalAmount = $donations->sum('jumlah');
            $totalCampaigns = $donations->unique('id_kampanye')->count();

            return response()->json([
                'status' => 'success',
                'message' => 'Riwayat donasi berhasil dimuat',
                'data' => [
                    'total_donations' => $donations->count(),
                    'total_amount' => $totalAmount,
                    'total_campaigns' => $totalCampaigns,
                    'donations' => $donations->map(function ($donation) {
                        return [
                            'id' => $donation->id,
                            'amount' => $donation->jumlah,
                            'donor_name' => $donation->anonim ? 'Anonymous' : 'Donor',
                            'message' => $donation->pesan,
                            'is_anonymous' => (bool) $donation->anonim,
                            'created_at' => $donation->dibuat_pada,
                            'campaign' => [
                                'id' => $donation->kampanye->id,
                                'title' => $donation->kampanye->judul,
                                'image_url' => $donation->kampanye->url_gambar,
                                'category' => $donation->kampanye->kategori,
                            ],
                        ];
                    }),
                ],
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
            
            $donation = Donasi::find($id);

            if (!$donation) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Riwayat tidak ditemukan'
                ], 404);
            }

           
            $donation->delete();

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