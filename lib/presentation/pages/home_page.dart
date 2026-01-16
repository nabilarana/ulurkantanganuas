import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ulurkantanganuas/data/repository/campaign_repository.dart';
import 'package:ulurkantanganuas/data/server/model/campaign.dart';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/presentation/campaign_detail_page.dart';
import 'package:ulurkantanganuas/presentation/history_page.dart';
import 'package:ulurkantanganuas/presentation/profile_page.dart';
import 'package:ulurkantanganuas/shared/widget/campaign_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _campaignRepo = CampaignRepository(ApiService());
  List<Campaign> _campaigns = [];
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() => _isLoading = true);

    try {
      final response = await _campaignRepo.getAllCampaigns();

      if (response.status == 'success') {
        setState(() {
          _campaigns = response.data;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      log('Error loading campaigns: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onNavTap(int index) {
    if (index == 0) {
      // Already on home
      return;
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulurkan Tangan'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _campaigns.isEmpty
              ? const Center(child: Text('Belum ada campaign'))
              : RefreshIndicator(
                  onRefresh: _loadCampaigns,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _campaigns.length,
                      itemBuilder: (context, index) {
                        return CampaignCardWidget(
                          campaign: _campaigns[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CampaignDetailPage(
                                  campaignId: _campaigns[index].id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E7D32),
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
