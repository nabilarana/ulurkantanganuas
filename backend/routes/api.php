<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\KampanyeController;
use App\Http\Controllers\DonasiController;
use App\Http\Controllers\ProfileController;

Route::get('/test', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'API Ulurkan Tangan berjalan dengan baik!',
        'timestamp' => now()->toDateTimeString()
    ]);
});

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/campaigns', [KampanyeController::class, 'index']);
Route::get('/campaigns/{id}', [KampanyeController::class, 'show']);

Route::post('/donations', [DonasiController::class, 'store']);
Route::get('/donation-history/{userId}', [DonasiController::class, 'getHistory']);
Route::delete('/donation-history/{id}', [DonasiController::class, 'deleteHistory']);

Route::get('/profile/{userId}', [ProfileController::class, 'show']);
Route::put('/profile/{userId}', [ProfileController::class, 'update']);
Route::post('/profile/{userId}/photo', [ProfileController::class, 'updatePhoto']);
