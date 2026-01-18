import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulurkantanganuas/data/repository/donation_repository.dart';
import 'package:ulurkantanganuas/data/server/model/campaign.dart';
import 'package:ulurkantanganuas/data/server/service/api_service.dart';
import 'package:ulurkantanganuas/domain/usecase/request/donation_request.dart';
import 'package:ulurkantanganuas/shared/widget/custom_button.dart';

class DonationPage extends StatefulWidget {
  final Campaign campaign;

  const DonationPage({Key? key, required this.campaign}) : super(key: key);

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _donationRepo = DonationRepository(ApiService());

  bool _isLoading = false;
  bool _useProfileData = true;
  bool _isAnonymous = false;
  double? _selectedAmount;

  final List<double> _quickAmounts = [
    10000,
    25000,
    50000,
    100000,
    250000,
    500000,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? '';
    final userEmail = prefs.getString('user_email') ?? '';

    setState(() {
      _nameCtrl.text = userName;
      _emailCtrl.text = userEmail;
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountCtrl.text = amount.toStringAsFixed(0);
    });
  }

  Future<void> _showConfirmation() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => _buildConfirmationDialog(),
      );

      if (confirmed == true) {
        _submitDonation();
      }
    }
  }

  Widget _buildConfirmationDialog() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final amount = double.tryParse(_amountCtrl.text) ?? 0;

    return AlertDialog(
      title: const Text('Konfirmasi Donasi'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pastikan data sudah benar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildConfirmItem('Campaign', widget.campaign.judul),
            _buildConfirmItem('Nama Donatur', _nameCtrl.text),
            _buildConfirmItem(
              'Email',
              _emailCtrl.text.isEmpty ? '-' : _emailCtrl.text,
            ),
            _buildConfirmItem('Nominal', currencyFormatter.format(amount)),
            _buildConfirmItem(
              'Keterangan',
              _messageCtrl.text.isEmpty ? '-' : _messageCtrl.text,
            ),
            _buildConfirmItem('Status', _isAnonymous ? 'Anonim' : 'Publik'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Text(
                '⚠️ Donasi tidak dapat dibatalkan setelah dikonfirmasi.',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Edit Data'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
          child: const Text('Ya, Konfirmasi'),
        ),
      ],
    );
  }

  Widget _buildConfirmItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitDonation() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 0;

      if (userId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID tidak ditemukan. Silakan login kembali.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final amount = double.tryParse(_amountCtrl.text) ?? 0;

      final request = DonationRequest(
        userId: userId,
        campaignId: widget.campaign.id,
        amount: amount,
        donorName: _nameCtrl.text.trim(),
        donorEmail: _emailCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
        isAnonymous: _isAnonymous,
      );

      final response = await _donationRepo.createDonation(request);

      if (mounted) {
        if (response.status == 'success') {
          await showDialog(
            context: context,
            builder: (context) => _buildSuccessDialog(),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      log('Error creating donation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSuccessDialog() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final amount = double.tryParse(_amountCtrl.text) ?? 0;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          const Text(
            'Donasi Berhasil!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Terima kasih atas donasi Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Nominal', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(amount),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Donasi'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.campaign.judul,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Isi data donasi Anda',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              const Text(
                'Pilih Nominal Cepat',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _quickAmounts.length,
                itemBuilder: (context, index) {
                  final amount = _quickAmounts[index];
                  final isSelected = _selectedAmount == amount;

                  return InkWell(
                    onTap: () => _selectQuickAmount(amount),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Rp ${(amount / 1000).toStringAsFixed(0)}K',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Atau Nominal Lainnya',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan nominal',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (amount < 10000) {
                    return 'Minimal donasi Rp 10.000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              const Text(
                '💡 Minimal Rp 10.000',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Donatur',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Donatur (Opsional)',
                  hintText: 'Untuk pengiriman receipt',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _messageCtrl,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: 'Keterangan/Pesan (Opsional)',
                  hintText: 'Tulis pesan dukungan Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('Gunakan data profil saya'),
                value: _useProfileData,
                onChanged: (value) {
                  setState(() => _useProfileData = value ?? true);
                  if (value == true) {
                    _loadUserData();
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              CheckboxListTile(
                title: const Text('Donasi sebagai anonim (Hamba Allah)'),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() => _isAnonymous = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Lanjutkan',
                isLoading: _isLoading,
                onPressed: _showConfirmation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
