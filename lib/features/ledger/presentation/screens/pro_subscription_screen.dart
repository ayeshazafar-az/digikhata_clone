import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class ProSubscriptionScreen extends StatefulWidget {
  const ProSubscriptionScreen({super.key});

  @override
  State<ProSubscriptionScreen> createState() => _ProSubscriptionScreenState();
}

class _ProSubscriptionScreenState extends State<ProSubscriptionScreen> {
  int _selectedPlan = 0; // 0 = 1 Year, 1 = 3 Month, 2 = 1 Month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header explicitly converted to Blue as mandated by user overriding the orange gradient
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue.withValues(
                        alpha: 0.2), // Light blue base matching the peach mapping
                    AppTheme.primaryBlue.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close,
                              color: Colors.black, size: 20)),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Positioned(
                    bottom: 24,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.workspace_premium,
                            color: Colors.amber, size: 36), // Crown equivalent
                        Text(
                          'DigiKhata Pro',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(
                                0xFF42210B), // Original dark brown text from screenshot
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Plan Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      '- You will be charged Rs ${_getPlanPrice()} every ${_getPlanDuration()}\n'
                      '- Free Trial is not included in plans given below.\n'
                      '- The subscription automatically renews.',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Pricing Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildPlanCard(
                            index: 0,
                            price: '5,500.00',
                            oldPrice: '11,000.00',
                            badgeText: '1 Year',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPlanCard(
                            index: 1,
                            price: '1,850.00',
                            oldPrice: '3,700.00',
                            badgeText: '3 Month',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPlanCard(
                            index: 2,
                            price: '790.00',
                            oldPrice: '1,580.00',
                            badgeText: '1 Month',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const Text('Benefits for Pro Users',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Benefits Outline Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.primaryBlue
                                .withValues(alpha: 0.3)), // Blue-aligned border
                      ),
                      child: const Column(
                        children: [
                          _BenefitRow(
                              icon: Icons.wifi_off, text: 'Offline Access'),
                          SizedBox(height: 16),
                          _BenefitRow(
                              icon: Icons.devices,
                              text: 'Multi-device access',
                              iconColor: Colors.orange),
                          SizedBox(height: 16),
                          _BenefitRow(
                              icon: Icons.add_to_drive,
                              text: 'Google backup',
                              iconColor: Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Subscribed to ${_getPlanDuration()} DigiKhata Pro!'),
                          backgroundColor: AppTheme.successGreen));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.primaryBlue, // Mandated blue over orange
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'SUBSCRIBE ${_getPlanDuration().toUpperCase()}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recurring billing. Cancel anytime on Google play. By continuing, you\n'
                    'agree to our terms of service.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Privacy Policy',
                          style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('|', style: TextStyle(color: Colors.grey)),
                      ),
                      Text('T&C',
                          style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlanPrice() {
    switch (_selectedPlan) {
      case 0:
        return '5,500.00';
      case 1:
        return '1,850.00';
      case 2:
        return '790.00';
      default:
        return '';
    }
  }

  String _getPlanDuration() {
    switch (_selectedPlan) {
      case 0:
        return '1 Year';
      case 1:
        return '3 Month';
      case 2:
        return '1 Month';
      default:
        return '';
    }
  }

  Widget _buildPlanCard(
      {required int index,
      required String price,
      required String oldPrice,
      required String badgeText}) {
    final isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text('Rs $price',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('Rs $oldPrice',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : Colors
                        .blueGrey.shade100, // Replaced orange to primaryBlue
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(7), // fit just inside the border
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Text(
                badgeText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blueGrey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _BenefitRow({required this.icon, required this.text, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 24),
        const SizedBox(width: 16),
        Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
