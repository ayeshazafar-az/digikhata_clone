import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class DigiBazarScreen extends StatelessWidget {
  const DigiBazarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue,
                AppTheme.primaryBlue.withOpacity(0.8)
              ], // Original pink gradient mapped to Blue theme natively
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
                  const SizedBox(width: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DigiBazar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.1)),
                      Text('WHOLESALE',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              letterSpacing: 2,
                              height: 1.1)),
                    ],
                  ),
                  const Spacer(),
                  _buildTopNavCircle(Icons.menu),
                  const SizedBox(width: 8),
                  _buildTopNavCircle(Icons.shopping_cart_outlined),
                  const SizedBox(width: 8),
                  _buildTopNavCircle(Icons.info_outline),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search products...'))),
                        Icon(Icons.filter_alt_outlined, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.favorite_border,
                    color: AppTheme
                        .dangerRed), // Replacing the heart color with red
              ],
            ),
            const SizedBox(height: 16),

            // Promo Banner
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [
                  AppTheme.primaryBlue.withOpacity(0.9),
                  AppTheme.primaryBlue.withOpacity(0.5)
                ]), // Mapped from purple/pink
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '100+ VERIFIED BRANDS\nA NEW ERA OF SHOPPING IS\nComing soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabs Categories vs Brands
            Row(
              children: [
                Expanded(
                    child:
                        _buildActionTab('Categories', Icons.layers_outlined)),
                const SizedBox(width: 16),
                Expanded(
                    child:
                        _buildActionTab('Brands', Icons.local_offer_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            // Product Grid Mockup
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
              children: [
                _buildProductCard(
                    'Men Loose Fit Cargo Pants...', '1,999', Icons.inventory),
                _buildProductCard(
                    'Pack of 5 Printed Cotton...', '1,000', Icons.checkroom),
                _buildProductCard('Men Straight Fit Jeans - Me...', '1,299',
                    Icons.inventory_2),
                _buildProductCard('Eternity Men Black Sando...', '900',
                    Icons.accessibility_new,
                    discount: '25% Discount', oldPrice: '1,200'),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon,
          color: AppTheme.primaryBlue,
          size: 20), // Colored icon mapping theme rules
    );
  }

  Widget _buildActionTab(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: AppTheme
                  .dangerRed), // Matches the exact reddish tone from the screenshot (which bypasses theme slightly, but we need to stay close)
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, IconData fallbackIcon,
      {String? discount, String? oldPrice}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // Image area mockup
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child:
                      Icon(fallbackIcon, size: 60, color: Colors.grey.shade300),
                ),
                // Favourite heart
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.grey),
                ),
                // Discount pill if present
                if (discount != null)
                  Positioned(
                    top: 8,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(discount,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                // MOQ badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('5 MOQ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rs. $price',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    if (oldPrice != null) ...[
                      const SizedBox(width: 4),
                      Text('Rs. $oldPrice',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough)),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
