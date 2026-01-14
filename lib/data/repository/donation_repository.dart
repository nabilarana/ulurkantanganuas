import 'dart:convert';
import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/request/donation_request.dart';
import 'package:ulurkantanganuas/domain/usecase/response/donation_response.dart';

class DonationRepository {
  final ApiService apiService;

  DonationRepository(this.apiService);

  // Create Donation
  Future<DonationResponse> createDonation(DonationRequest request) async {
    try {
      log('📤 Creating donation: ${request.toJson()}');

      final response = await apiService.post('donations', request.toJson());

      log('📥 Response status: ${response.statusCode}');
      log('📥 Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return DonationResponse.fromJson(jsonDecode(response.body));
      } else {
        return DonationResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      log('❌ Error creating donation: $e');
      throw Exception('Error donasi: $e');
    }
  }
}
