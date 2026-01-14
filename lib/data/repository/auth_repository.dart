import 'dart:convert';
import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/data/server/service/session_manager.dart';
import 'package:ulurkantanganuas/domain/usecase/request/login_request.dart';
import 'package:ulurkantanganuas/domain/usecase/response/auth_response.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      log('📤 Login request: ${request.toJson()}');

      final response = await apiService.post('login', request.toJson());

      log('📥 Response status: ${response.statusCode}');
      log('📥 Response body: ${response.body}');

      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

      if (authResponse.status == 'success' && authResponse.data != null) {
        await SessionManager.saveSession(authResponse.data, null);
      }

      return authResponse;
    } catch (e) {
      log('❌ Error login: $e');
      throw Exception('Error login: $e');
    }
  }
}
