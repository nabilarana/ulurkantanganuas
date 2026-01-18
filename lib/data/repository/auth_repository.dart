import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/request/login_request.dart';
import 'package:ulurkantanganuas/domain/usecase/request/register_request.dart';
import 'package:ulurkantanganuas/domain/usecase/response/login_response.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await apiService.post('login', request.toMap());

      if (response.statusCode == 200) {
        final responseData = LoginResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = LoginResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('Error login: $e');
      throw Exception('Error login: $e');
    }
  }

  Future<LoginResponse> register(RegisterRequest request) async {
    try {
      final response = await apiService.post('auth/register', request.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = LoginResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = LoginResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('[auth] Error register: $e');
      throw Exception('[auth] Error register: $e');
    }
  }

  Future<bool> logout() async {
    try {
      final response = await apiService.post('auth/logout', {});
      return response.statusCode == 200;
    } catch (e) {
      log('Error logout: $e');
      return false;
    }
  }
}
