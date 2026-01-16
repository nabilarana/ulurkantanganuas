<?php

namespace App\Http\Controllers;

use App\Models\Pengguna;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'password' => 'required'
            ]);

            $pengguna = Pengguna::where('email', $request->email)->first();

            if (!$pengguna) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Email tidak ditemukan!'
                ], 404);
            }

            if (!Hash::check($request->password, $pengguna->password)) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Password salah!'
                ], 401);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'Login berhasil!',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email,
                    'telepon' => $pengguna->telepon,
                    'foto_profil' => $pengguna->foto_profil
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Login error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function register(Request $request)
    {
        try {
            $request->validate([
                'nama' => 'required|string|max:100',
                'email' => 'required|email|unique:pengguna,email',
                'password' => 'required|min:6',
                'telepon' => 'nullable|string|max:20'
            ]);

            $pengguna = Pengguna::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'telepon' => $request->telepon
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Registrasi berhasil!',
                'data' => [
                    'id' => $pengguna->id,
                    'nama' => $pengguna->nama,
                    'email' => $pengguna->email
                ]
            ], 201);

        } catch (\Exception $e) {
            Log::error('Register error: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Registrasi gagal: ' . $e->getMessage()
            ], 500);
        }
    }
}