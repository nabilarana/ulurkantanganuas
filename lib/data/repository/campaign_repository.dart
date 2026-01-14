import 'dart:convert';
import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/response/campaign_response.dart';

class CampaignRepository {
  final ApiService apiService;

  CampaignRepository(this.apiService);

  Future<GetAllCampaignResponse> getAllCampaigns() async {
    try {
      log('📤 Getting all campaigns');

      final response = await apiService.get('campaigns');

      log('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return GetAllCampaignResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load campaigns');
      }
    } catch (e) {
      log('❌ Error getting campaigns: $e');
      throw Exception('Error: $e');
    }
  }
}
