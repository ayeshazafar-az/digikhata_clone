import 'package:flutter/material.dart';

class DigiCashScreen extends StatelessWidget {
  const DigiCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3752A), Color(0xFFE94326)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
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
                      child: const Text(
                        '03245423290',
                        style: TextStyle(
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
                        color: const Color(0xFFFFB300), // Yellow button
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
                                      const Text(
                                        'Rs.',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Text(
                                        '0.00',
                                        style: TextStyle(
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFC62828), // Dark Red
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
                                child: _buildGridItem(
                                    'JazzCash', 'assets/icons/jazzcash.png',
                                    isCustomIcon: true)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    'easypaisa', 'assets/icons/easypaisa.png',
                                    isCustomIcon: true)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    'Raast', 'assets/icons/raast.png',
                                    isCustomIcon: true)),
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
                                    'Bills', Icons.receipt_long)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    'Easy Load', Icons.phone_android)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem(
                                    'Vouchers', Icons.local_activity_outlined)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child:
                                    _buildGridItem('SMS', Icons.sms_outlined)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildGridItem('NFC', Icons.nfc)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _buildGridItem('Pro', Icons.stars,
                                    iconColor: Colors.amber)),
                          ],
                        ),
                        const SizedBox(
                            height:
                                100), // spacing for bottom nav if overlapping
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

  Widget _buildGridItem(String title, dynamic iconOrPath,
      {bool isCustomIcon = false, Color iconColor = Colors.black87}) {
    return Container(
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
          if (isCustomIcon)
            Container(
              height: 32,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.account_balance_wallet,
                  color: Colors.grey, size: 20), // Fallback
            )
          else
            Icon(iconOrPath as IconData, size: 32, color: iconColor),
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
    );
  }
}
