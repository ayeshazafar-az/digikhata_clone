import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../providers/digi_bazar_provider.dart';

class DigiBazarScreen extends ConsumerStatefulWidget {
  const DigiBazarScreen({super.key});

  @override
  ConsumerState<DigiBazarScreen> createState() => _DigiBazarScreenState();
}

class _DigiBazarScreenState extends ConsumerState<DigiBazarScreen> {
  String _selectedBrand = 'All';

  @override
  Widget build(BuildContext context) {
    final brandsState = ref.watch(bazarBrandsProvider);
    // Watch the family provider filtering dynamically by currently selected brand
    final productsState = ref.watch(digiBazarProvider(_selectedBrand));
    final formatter = NumberFormat('#,###');

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
              ],
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
        child: Column(
          children: [
            Padding(
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
                              Icon(Icons.filter_alt_outlined,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.favorite_border,
                          color: AppTheme.dangerRed),
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
                      ]),
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
                ],
              ),
            ),

            // Tabs Categories vs Brands
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionTab('Categories', Icons.layers_outlined,
                        onTap: () => context.push('/categories')),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionTab('Brands', Icons.local_offer_outlined,
                        onTap: () => context.push('/all_brands')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Brand Filters Ribbon
            SizedBox(
              height: 45,
              child: brandsState.when(
                loading: () => const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (brandsData) {
                  final brands = [
                    'All',
                    ...brandsData.map((e) => e['name'] as String)
                  ];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      final isSelected = _selectedBrand == brand;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(brand,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87)),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryBlue,
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.shade300),
                          ),
                          onSelected: (selected) {
                            if (selected)
                              setState(() => _selectedBrand = brand);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: productsState.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(child: Text('Error: $err')),
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                          child: Text(
                              'No Wholesale Products Available for this Brand')),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (ctx) => Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(product.brandName,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(product.title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 16),
                                        Text(
                                            'Rs. ${formatter.format(product.price)} (MOQ: ${product.moq})',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Added ${product.moq}x ${product.brandName} ${product.title} to cart!',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor:
                                                        AppTheme.successGreen));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.primaryBlue,
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                          ),
                                          child: const Text('Add to Cart',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        child: _buildProductCard(
                          product.brandName,
                          product.title,
                          formatter.format(product.price),
                          imageUrl: product.imageUrl,
                          discount: product.discount,
                          oldPrice: product.oldPrice != null
                              ? formatter.format(product.oldPrice)
                              : null,
                          moq: product.moq,
                        ),
                      );
                    },
                  );
                },
              ),
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
      child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
    );
  }

  Widget _buildActionTab(String title, IconData icon,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.dangerRed),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String brandName, String title, String price,
      {String? imageUrl, String? discount, String? oldPrice, int? moq}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    image: imageUrl != null && imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover)
                        : null,
                  ),
                  child: imageUrl == null || imageUrl.isEmpty
                      ? Icon(Icons.image_not_supported,
                          color: Colors.grey.shade300)
                      : null,
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.grey),
                ),
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
                if (moq != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('$moq MOQ',
                          style: const TextStyle(
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
                Text(brandName.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
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
