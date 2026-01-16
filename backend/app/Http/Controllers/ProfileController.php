<?php

namespace App\Http\Controllers;

use App\Models\Pengguna;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class ProfileController extends Controller
{
   
    public function show($userId)
    {
        try {
            $pengguna = Pengguna::find($userId);

            if (!$pengguna) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'Data profil berhasil dimuat',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email,
                    'telepon' => $pengguna->telepon,
                    'foto_profil' => $pengguna->foto_profil
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Get profile error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat profil: ' . $e->getMessage()
            ], 500);
        }
    }

   
    public function update(Request $request, $userId)
    {
        try {
            $pengguna = Pengguna::find($userId);

            if (!$pengguna) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }

            
            $request->validate([
                'nama' => 'sometimes|string|max:100',
                'telepon' => 'sometimes|string|max:20',
                'password' => 'sometimes|string|min:6'
            ]);

          
            if ($request->has('nama')) {
                $pengguna->nama = $request->nama;
            }

            if ($request->has('telepon')) {
                $pengguna->telepon = $request->telepon;
            }

            if ($request->has('password')) {
                $pengguna->password = Hash::make($request->password);
            }

            $pengguna->save();

            return response()->json([
                'status' => 'success',
                'message' => 'Profil berhasil diperbarui',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email,
                    'telepon' => $pengguna->telepon,
                    'foto_profil' => $pengguna->foto_profil
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Update profile error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memperbarui profil: ' . $e->getMessage()
            ], 500);
        }
    }

    
    public function updatePhoto(Request $request, $userId)
    {
        try {
            $pengguna = Pengguna::find($userId);

            if (!$pengguna) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Pengguna tidak ditemukan'
                ], 404);
            }

           
            \Log::info('Request all:', $request->all());
            \Log::info('Request files:', $request->allFiles());

            $request->validate([
                'foto_profil' => 'required|image|mimes:jpeg,jpg,png|max:2048'
            ]);

           
            if ($pengguna->foto_profil && file_exists(public_path($pengguna->foto_profil))) {
                unlink(public_path($pengguna->foto_profil));
            }

            $file = $request->file('foto_profil');
            $filename = 'user_' . $userId . '_' . time() . '.' . $file->getClientOriginalExtension();
            
            
            if (!file_exists(public_path('uploads/profiles'))) {
                mkdir(public_path('uploads/profiles'), 0777, true);
            }

            $file->move(public_path('uploads/profiles'), $filename);

          
            $pengguna->foto_profil = 'uploads/profiles/' . $filename;
            $pengguna->save();

            return response()->json([
                'status' => 'success',
                'message' => 'Foto profil berhasil diperbarui',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email,
                    'foto_profil' => $pengguna->foto_profil
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Update photo error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengupload foto: ' . $e->getMessage()
            ], 500);
        }
    }
}