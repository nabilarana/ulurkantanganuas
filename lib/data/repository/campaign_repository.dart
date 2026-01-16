import 'dart:developer';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/response/get_all_campaign_response.dart';
import 'package:ulurkantanganuas/domain/usecase/response/get_detail_campaign_response.dart';

class CampaignRepository {
  final ApiService apiService;

  CampaignRepository(this.apiService);

  Future<GetAllCampaignResponse> getAllCampaigns() async {
    try {
      final response = await apiService.get('campaigns');

      if (response.statusCode == 200) {
        final responseData = GetAllCampaignResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetAllCampaignResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('Error getting campaigns: $e');
      throw Exception('Error getting campaigns: $e');
    }
  }

  Future<GetDetailCampaignResponse> getCampaignDetail(int id) async {
    try {
      final response = await apiService.get('campaigns/$id');

      if (response.statusCode == 200) {
        final responseData = GetDetailCampaignResponse.fromJson(response.body);
        return responseData;
      } else {
        final errorResponse = GetDetailCampaignResponse.fromJson(response.body);
        return errorResponse;
      }
    } catch (e) {
      log('Error getting campaign detail: $e');
      throw Exception('Error getting campaign detail: $e');
    }
  }
}
