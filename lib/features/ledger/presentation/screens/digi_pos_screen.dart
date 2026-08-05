import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/theme.dart';
import '../../../../core/utils/pdf_service.dart';

class DigiPosScreen extends ConsumerStatefulWidget {
  const DigiPosScreen({super.key});

  @override
  ConsumerState<DigiPosScreen> createState() => _DigiPosScreenState();
}

class _DigiPosScreenState extends ConsumerState<DigiPosScreen> {
  String userName = 'Loading...';
  String userPhone = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('name, phone')
            .eq('id', user.id)
            .single();
        if (mounted) {
          setState(() {
            userName = profile['name'] ?? 'User';
            userPhone = profile['phone'] ?? '';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            userName = 'DigiKhata User';
            userPhone = '0000000000';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppTheme
              .primaryBlue, // Mapped from Orange #F15424 to enforced Blue
          elevation: 0,
          toolbarHeight: 70,
          leadingWidth: double.infinity,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DIGI',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1)),
                    Text('POS',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1)),
                  ],
                ),
                const Icon(Icons.wifi_tethering, color: Colors.white, size: 28),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(userPhone,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('STATEMENT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30)),
                child: TabBar(
                  indicator: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30)),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.credit_card, size: 18),
                          SizedBox(width: 8),
                          Text('POS',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ])),
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.qr_code, size: 18),
                          SizedBox(width: 8),
                          Text('QR',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ])),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildPosTab(),
            _buildQrTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Complete KYC To\nActivate POS',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2)),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('accept card payments\ndirectly on you phone',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Icon(Icons.contactless,
                      size: 120,
                      color: AppTheme.primaryBlue.withOpacity(
                          0.2)), // Mobile Phone POS Mock Placeholder
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSubCard('Paid\nUtility Bill', Icons.receipt_long),
                    _buildSubCard('Shop\nPhotos', Icons.storefront),
                    _buildSubCard('Bank\nAccount', Icons.account_balance),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('COMPLETE KYC',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSubCard(String title, IconData icon) {
    return Container(
      width: 90,
      height: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 32),
          const Spacer(),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildQrTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            const Text('Scan & Pay',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Fast payments, one scan away',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.dangerRed)), // Red name mapping
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16)),
              child: QrImageView(
                data:
                    'https://digikhata.app/pay?phone=$userPhone', // Dummy payment payload
                version: QrVersions.auto,
                size: 250.0,
                // embeddedImage: const AssetImage('assets/images/raast.png'), // Can't resolve image on fly so omitted
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.dangerRed, // In screenshot it's Red/Orange
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('SHARE',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _downloadPdfReceipt();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.print), Icon(Icons.download)]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text('Your payment will be settled instantly.',
                    style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdfReceipt() async {
    await PdfService.generateDigiPosReceipt(
        userName: userName, userPhone: userPhone);
  }
}
