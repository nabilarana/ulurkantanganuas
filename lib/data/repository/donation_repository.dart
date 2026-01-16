import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/request/donation_request.dart';
import 'package:ulurkantanganuas/domain/usecase/response/donation_response.dart';
import 'package:ulurkantanganuas/domain/usecase/response/get_all_donation_response.dart';

class DonationRepository {
  final ApiService apiService;

  DonationRepository(this.apiService);

  Future<GetAllDonationResponse> getUserDonations() async {
    try {
      final response = await apiService.get('donations/user');

      if (response.statusCode == 200) {
        final responseData = GetAllDonationResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetAllDonationResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('Error getting donations: $e');
      throw Exception('Error getting donations: $e');
    }
  }

  Future<DonationResponse> createDonation(DonationRequest request) async {
    try {
      final response = await apiService.post('donations', {
        'campaign_id': request.campaignId,
        'amount': request.amount,
        'donor_name': request.donorName,
        'donor_email': request.donorEmail ?? '',
        'message': request.message ?? '',
        'is_anonymous': request.isAnonymous,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = DonationResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = DonationResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('Error creating donation: $e');
      throw Exception('Error creating donation: $e');
    }
  }

  Future<bool> deleteDonation(int id) async {
    try {
      final response = await apiService.delete('donations/$id');
      return response.statusCode == 200;
    } catch (e) {
      log('Error deleting donation: $e');
      return false;
    }
  }
}
