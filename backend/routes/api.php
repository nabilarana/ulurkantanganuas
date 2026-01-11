<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CampaignController;
use App\Http\Controllers\DonationController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::get('/campaigns', [CampaignController::class, 'index']);
Route::get('/campaigns/{id}', [CampaignController::class, 'show']);

Route::post('/donations', [DonationController::class, 'store']);
Route::get('/donation-history/{userId}', [DonationController::class, 'getHistory']);
Route::delete('/donation-history/{id}', [DonationController::class, 'deleteHistory']);