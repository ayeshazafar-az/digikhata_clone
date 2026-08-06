import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../app/theme.dart';

final _digicashProfileProvider =
    FutureProvider<Map<String, String>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return {'phone': '---', 'balance': '0.00'};
  try {
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('phone')
        .eq('id', user.id)
        .single();
    return {
      'phone': profile['phone'] ?? user.phone ?? '---',
      'balance': '0.00', // Real balance would come from a wallet table
    };
  } catch (_) {
    return {'phone': user.phone ?? '---', 'balance': '0.00'};
  }
});

class DigiCashScreen extends ConsumerWidget {
  const DigiCashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_digicashProfileProvider);
    final phone = profileAsync.when(
      data: (d) => d['phone'] ?? '---',
      loading: () => '...',
      error: (_, __) => '---',
    );
    final balance = profileAsync.when(
      data: (d) => d['balance'] ?? '0.00',
      loading: () => '...',
      error: (_, __) => '0.00',
    );
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header section
          Container(
            color: AppTheme.primaryBlue,
            padding:
                const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIGI\nCASH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                // Phone & Statement
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        phone,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.goldAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'STATEMENT',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body content relative overlap
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Scrollable container for grid
                Positioned.fill(
                  top: -40,
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Balance Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$currency ',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        balance,
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Balance',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Money Out feature coming soon')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.dangerRed,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  'MONEY OUT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Money In',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildGridItem(context, 'JazzCash',
                                    Icons.account_balance_wallet)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(context, 'easypaisa',
                                    Icons.account_balance)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    context, 'Raast', Icons.swap_horiz)),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Payments',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildGridItem(
                                    context, 'Bills', Icons.receipt_long)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    context, 'Easy Load', Icons.phone_android)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(context, 'Vouchers',
                                    Icons.local_activity_outlined)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _buildGridItem(
                                    context, 'SMS', Icons.sms_outlined)),
                            const SizedBox(width: 12),
                            Expanded(
                                child:
                                    _buildGridItem(context, 'NFC', Icons.nfc)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    context, 'Pro', Icons.stars,
                                    iconColor: AppTheme.goldAccent)),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon,
      {Color iconColor = Colors.black87}) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title — Coming soon')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
