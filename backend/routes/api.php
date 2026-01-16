<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CampaignController;
use App\Http\Controllers\DonationController;
use App\Http\Controllers\ProfileController;

Route::get('/test', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'API Ulurkan Tangan berjalan dengan baik!',
        'timestamp' => now()->toDateTimeString()
    ]);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/campaigns', [CampaignController::class, 'index']);
Route::get('/campaigns/{id}', [CampaignController::class, 'show']);

Route::post('/donations', [DonationController::class, 'store']);
Route::get('/donation-history/{userId}', [DonationController::class, 'getHistory']);
Route::delete('/donation-history/{id}', [DonationController::class, 'deleteHistory']);

Route::get('/profile/{userId}', [ProfileController::class, 'show']);
Route::put('/profile/{userId}', [ProfileController::class, 'update']);
Route::post('/profile/{userId}/photo', [ProfileController::class, 'updatePhoto']);
