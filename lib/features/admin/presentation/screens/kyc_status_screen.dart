import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/theme.dart';

class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({super.key});

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen> {
  String _kycStatus = 'unverified';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKycStatus();
  }

  Future<void> _fetchKycStatus() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      try {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('kyc_status')
            .eq('id', userId)
            .maybeSingle();
        if (response != null && mounted) {
          setState(() {
            _kycStatus = response['kyc_status'] as String? ?? 'unverified';
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        debugPrint('KYC Status Error: $e');
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isPending = _kycStatus == 'pending';
    final isApproved = _kycStatus == 'approved';

    final headerText =
        isApproved ? 'Approved' : (isPending ? 'Pending' : 'Unverified');
    final headerColor = isApproved
        ? AppTheme.successGreen
        : (isPending ? Colors.red.shade900 : Colors.grey.shade700);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('KYC',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              Supabase.instance.client.auth.currentUser?.phone ?? 'N/A',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_in_talk_outlined,
                color: Color(0xFF60A5FA), size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Warning/Pending Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(
                    0xFFF4C57B), // Mustard Yellow matching screenshot
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('KYC Status',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      Text(headerText,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: headerColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isApproved
                        ? 'Congratulations! Your business is verified and Digi POS is fully activated.'
                        : 'Before we turn on Digi POS in your DigiKhata App, we need to know more about your business, it will only take 15 min.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // STEP 1 - CNIC
            _buildStepCard(
              iconWidget: _buildCnicIcon(),
              title: 'Step 1 - CNIC',
              subtitle: (isPending || isApproved)
                  ? 'Approved'
                  : 'Provide Details add karein',
              subtitleColor: (isPending || isApproved)
                  ? AppTheme.successGreen
                  : Colors.grey.shade400,
              trailing: (isPending || isApproved)
                  ? const Icon(Icons.check_circle,
                      color: AppTheme.successGreen, size: 28)
                  : const Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('Add ',
                          style: TextStyle(
                              color: Color(0xFF60A5FA), fontSize: 16)),
                      Icon(Icons.chevron_right,
                          color: Color(0xFF60A5FA), size: 20)
                    ]),
              cardColor: Colors.white,
            ),
            const SizedBox(height: 12),

            // STEP 2 - Business
            _buildStepCard(
              iconWidget: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.business_center,
                    color: Color(0xFF6D4E41), size: 36), // Briefcase
              ),
              iconContainerColor: const Color(0xFFEFE8E6), // Light brown bg
              title: 'Step 2 - Business',
              subtitle: isApproved ? 'Approved' : 'Business Details add karein',
              subtitleColor:
                  isApproved ? AppTheme.successGreen : Colors.grey.shade400,
              trailing: isApproved
                  ? const Icon(Icons.check_circle,
                      color: AppTheme.successGreen, size: 28)
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add ',
                            style: TextStyle(
                                color: Color(0xFF60A5FA), fontSize: 16)),
                        Icon(Icons.chevron_right,
                            color: Color(0xFF60A5FA), size: 20),
                      ],
                    ),
              opacity: (isPending || isApproved) ? 1.0 : 0.5,
              cardColor: (isPending || isApproved)
                  ? Colors.white
                  : const Color(0xFFF0F0F0),
            ),
            const SizedBox(height: 12),

            // STEP 3 - Bank (Greyed Out dynamically)
            _buildStepCard(
              iconWidget: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.account_balance,
                    color: Color(0xFFE3C565), size: 36), // Bank icon
              ),
              iconContainerColor: const Color(0xFFF3EFE6),
              title: 'Step 3 -Bank',
              subtitle: isApproved ? 'Approved' : 'Bank Info add karein',
              subtitleColor:
                  isApproved ? AppTheme.successGreen : Colors.grey.shade400,
              titleColor: isApproved ? Colors.black87 : Colors.grey.shade600,
              opacity: isApproved ? 1.0 : 0.5,
              cardColor: isApproved ? Colors.white : const Color(0xFFF0F0F0),
              trailing: isApproved
                  ? const Icon(Icons.check_circle,
                      color: AppTheme.successGreen, size: 28)
                  : null,
            ),
            const SizedBox(height: 12),

            // STEP 4 - Agreement (Greyed Out dynamically)
            _buildStepCard(
              iconWidget: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.edit_document,
                    color: Color(0xFF7CB3D8), size: 36), // Document icon
              ),
              iconContainerColor: const Color(0xFFEBF1F6),
              title: 'Step 4 -Agreement',
              subtitle: isApproved ? 'Approved' : 'Sign Agreement',
              subtitleColor:
                  isApproved ? AppTheme.successGreen : Colors.grey.shade400,
              titleColor: isApproved ? Colors.black87 : Colors.grey.shade600,
              opacity: isApproved ? 1.0 : 0.5,
              cardColor: isApproved ? Colors.white : const Color(0xFFF0F0F0),
              trailing: isApproved
                  ? const Icon(Icons.check_circle,
                      color: AppTheme.successGreen, size: 28)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required Widget iconWidget,
    Color? iconContainerColor,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    Color? titleColor,
    Widget? trailing,
    double opacity = 1.0,
    Color? cardColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardColor == null
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Opacity(
        opacity: opacity,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconContainerColor ?? const Color(0xFFF6EAE7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          title: Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? Colors.black87)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(subtitle,
                style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor ?? Colors.grey.shade600)),
          ),
          trailing: trailing,
        ),
      ),
    );
  }

  Widget _buildCnicIcon() {
    return SizedBox(
      width: 40,
      height: 30,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.shade300, width: 1.5),
            ),
          ),
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              width: 10,
              height: 12,
              color: Colors.blue.shade300,
            ),
          ),
          Positioned(
            right: 4,
            top: 6,
            child: Container(
              width: 16,
              height: 2,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            right: 4,
            top: 10,
            child: Container(
              width: 12,
              height: 2,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Container(
              height: 2,
              color: const Color(0xFF60A5FA), // red bottom line
            ),
          ),
        ],
      ),
    );
  }
}
