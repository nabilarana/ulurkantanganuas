import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ulurkantanganuas/data/repository/donation_repository.dart';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/data/server/service/session_manager.dart';
import 'package:ulurkantanganuas/domain/usecase/response/get_all_donation_response.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _donationRepo = DonationRepository(ApiService());
  DonationSummary? _summary;
  bool _isLoading = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadDonations();
  }

  Future<void> _initializeAndLoadDonations() async {
    // Get current user ID from session
    final userId = await SessionManager.getUserId();

    if (userId != null) {
      setState(() => _currentUserId = userId);
      _loadDonations();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User tidak ditemukan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadDonations() async {
    if (_currentUserId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await _donationRepo.getUserDonations(_currentUserId!);

      if (response.status == 'success' && response.data != null) {
        setState(() {
          _summary = response.data;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
        }
      }
    } catch (e) {
      log('Error loading donations: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if user has changed and reload donations
    _checkAndReloadIfUserChanged();
  }

  Future<void> _checkAndReloadIfUserChanged() async {
    final userId = await SessionManager.getUserId();

    if (userId != null && userId != _currentUserId) {
      setState(() => _currentUserId = userId);
      _loadDonations();
    }
  }

  Future<void> _deleteDonation(int id, double amount) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat Donasi?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Riwayat donasi akan dihapus dari sistem Anda.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: const Text(
                '⚠️ Tindakan ini tidak dapat dibatalkan.',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _donationRepo.deleteDonation(id);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Riwayat donasi berhasil dihapus'),
                backgroundColor: Colors.green,
              ),
            );
            _loadDonations();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal menghapus riwayat'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        log('Error deleting donation: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Donasi'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUserId == null
          ? const Center(
              child: Text('User tidak ditemukan. Silakan login kembali.'),
            )
          : _summary == null || _summary!.donations.isEmpty
          ? const Center(child: Text('Belum ada donasi'))
          : RefreshIndicator(
              onRefresh: _loadDonations,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 24),
                    _buildHistoryHeader(),
                    const SizedBox(height: 12),
                    _buildDonationList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Total Donasi Saya',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormatter.format(_summary!.totalAmount),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dari ${_summary!.totalDonations} donasi',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return const Text(
      'Riwayat',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDonationList() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _summary!.donations.length,
      itemBuilder: (context, index) {
        final donation = _summary!.donations[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDonationHeader(donation),
                const SizedBox(height: 8),
                _buildDonationAmount(donation, currencyFormatter),
                const SizedBox(height: 8),
                if (donation.isAnonymous) _buildAnonymousLabel(),
                if (donation.message != null &&
                    donation.message!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildDonationMessage(donation),
                ],
                const SizedBox(height: 8),
                _buildDonationDate(donation, dateFormatter),
                const SizedBox(height: 12),
                _buildDeleteButton(donation),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationHeader(donation) {
    return Row(
      children: [
        Expanded(
          child: Text(
            donation.campaign.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        if (donation.campaign.category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              donation.campaign.category!,
              style: TextStyle(fontSize: 10, color: Colors.orange[900]),
            ),
          ),
      ],
    );
  }

  Widget _buildDonationAmount(donation, NumberFormat currencyFormatter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Nominal',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          currencyFormatter.format(donation.amount),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymousLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '🔒 Donasi Anonim (Hamba Allah)',
        style: TextStyle(fontSize: 11, color: Colors.orange[900]),
      ),
    );
  }

  Widget _buildDonationMessage(donation) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: Colors.grey[400]!, width: 3)),
      ),
      child: Text(
        '"${donation.message}"',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildDonationDate(donation, DateFormat dateFormatter) {
    return Text(
      '📅 ${dateFormatter.format(donation.createdAt)}',
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget _buildDeleteButton(donation) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _deleteDonation(donation.id, donation.amount),
        icon: const Icon(Icons.delete_outline, size: 18),
        label: const Text('Hapus Riwayat'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
