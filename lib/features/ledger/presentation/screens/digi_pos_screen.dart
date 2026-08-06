import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
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
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(30)),
                child: TabBar(
                  indicator: BoxDecoration(
                      color: const Color(0xFFF05A28),
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
            padding:
                const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                                color: Colors.black87),
                            children: [
                          TextSpan(text: 'Complete KYC To\n'),
                          TextSpan(
                              text: 'Activate POS',
                              style: TextStyle(color: AppTheme.primaryBlue)),
                        ]))),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('accept card payments\ndirectly on you phone',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                const SizedBox(height: 16),

                // Smartphone Mockup Graphic
                SizedBox(
                    height: 220,
                    child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // The phone body
                          Transform.rotate(
                            angle: 0.15,
                            child: Container(
                                width: 130,
                                height: 220,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.black87, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(5, 5))
                                    ]),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 12),
                                      const Text('DigiKhata',
                                          style: TextStyle(
                                              color: AppTheme.primaryBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                            color: AppTheme.primaryBlue,
                                            shape: BoxShape.circle),
                                        child: const Icon(Icons.check,
                                            color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Payment Received',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10)),
                                      const Text('Rs. 2,450',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      const Icon(Icons.contactless,
                                          color: Colors.grey, size: 24),
                                      const SizedBox(height: 16),
                                    ])),
                          ),
                          // Floating credit card
                          Positioned(
                            bottom: 10,
                            right: -10,
                            child: Transform.rotate(
                              angle: -0.1,
                              child: Container(
                                  width: 120,
                                  height: 70,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFF97316),
                                            Color(0xFFEA580C)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(2, 4))
                                      ]),
                                  child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.memory,
                                            color: Colors.amber, size: 20),
                                        Text('1234 5678 9012 3456',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'monospace')),
                                        Text('12/28',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontFamily: 'monospace')),
                                      ])),
                            ),
                          )
                        ])),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSubCard(
                        'Paid Utility\nBill', Icons.receipt_long, Colors.green),
                    _buildSubCard(
                        'Shop\nPhotos', Icons.storefront, Colors.orange),
                    _buildSubCard(
                        'Bank\nAccount', Icons.account_balance, Colors.brown),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.push('/kyc_onboarding');
                  },
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

  Widget _buildSubCard(String title, IconData icon, Color iconColor) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const Spacer(),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.black87)),
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
                    onPressed: () {
                      if (context.mounted)
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Feature coming soon...')));
                    },
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
