import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/theme.dart';
import '../../../../core/utils/pdf_service.dart';
import '../../../../core/database/local_db.dart';

final stockProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final profileRes =
      await supabase.from('profiles').select('active_business_id').single();
  final activeBusinessId = profileRes['active_business_id'];

  if (activeBusinessId == null) return [];

  final res = await supabase
      .from('products')
      .select()
      .eq('business_id', activeBusinessId)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
});

class StockBookScreen extends ConsumerWidget {
  final bool isRoot;
  const StockBookScreen({super.key, this.isRoot = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Stock Book',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: isRoot
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 16.0, top: 12.0, bottom: 12.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('STOCK VALUE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'All Items'),
                Tab(text: 'Low Stock'),
              ],
            ),
            Expanded(
              child: stockAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.black87))),
                data: (products) {
                  return TabBarView(
                    children: [
                      _buildStockView(context, ref, products, false), // All
                      _buildStockView(
                          context,
                          ref,
                          products
                              .where((p) =>
                                  double.parse(p['current_stock'].toString()) <
                                  5)
                              .toList(),
                          true), // Low
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 8.0),
        child: ElevatedButton.icon(
          onPressed: () => _showAddProductModal(context, ref),
          icon: const Icon(Icons.add, color: Colors.black87),
          label: const Text('ADD ITEM',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: Size.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildStockView(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> products, bool isLowStock) {
    return Column(
      children: [
        _buildStatsHeader(products.length, products),
        if (products.isEmpty)
          Expanded(child: _buildEmptyState())
        else
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade800),
              itemBuilder: (context, index) {
                final p = products[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(p['item_name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                  subtitle: Text('Selling Price: Rs. ${p['selling_price']}',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${p['current_stock']} ${p['unit']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.successGreen)),
                      const Text('In Stock',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 80), // Fab space
      ],
    );
  }

  Widget _buildStatsHeader(
      int totalItems, List<Map<String, dynamic>> products) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Items: $totalItems',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text('View Rate List',
                        style:
                            TextStyle(color: Colors.redAccent, fontSize: 14)),
                  ],
                ),
                const Icon(Icons.chevron_right, color: Colors.white, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (products.isEmpty) return;
                    await PdfService.generateStockReport(
                      items: products
                          .map((p) => {
                                'name': p['name'],
                                'current_stock': p['current_stock'],
                                'unit': p['unit'],
                                'purchase_price': p['purchase_price'],
                                'selling_price': p['selling_price'],
                              })
                          .toList(),
                      reportType: 'IN',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('Stock IN Report',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (products.isEmpty) return;
                    await PdfService.generateStockReport(
                      items: products
                          .map((p) => {
                                'name': p['name'],
                                'current_stock': p['current_stock'],
                                'unit': p['unit'],
                                'purchase_price': p['purchase_price'],
                                'selling_price': p['selling_price'],
                              })
                          .toList(),
                      reportType: 'OUT',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('Stock OUT Report',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: const Icon(Icons.inventory,
                    size: 100, color: Color(0xFFE8C17F)),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
                child: const Icon(Icons.lock, color: Colors.black87, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1- Add items",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("2- Add stock in/out entries",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("3- Manage your stock easily",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductModal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final unitController = TextEditingController(text: 'pcs');
    final sellPriceController = TextEditingController();
    final buyPriceController = TextEditingController();
    final stockController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Item',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue)),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: sellPriceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            labelText: 'Selling Price (Rs)',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)),
                          ))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: TextField(
                          controller: buyPriceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            labelText: 'Purchase Price (Rs)',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)),
                          ))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            labelText: 'Opening Stock',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)),
                          ))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: TextField(
                          controller: unitController,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            labelText: 'Unit (pcs, kg, etc)',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)),
                          ))),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty) return;

                  final supabase = Supabase.instance.client;
                  final profileRes = await supabase
                      .from('profiles')
                      .select('active_business_id')
                      .single();
                  final activeBusinessId = profileRes['active_business_id'];

                  if (activeBusinessId != null) {
                    try {
                      final startingQty =
                          double.tryParse(stockController.text) ?? 0;
                      await supabase.from('products').insert({
                        'business_id': activeBusinessId,
                        'item_name': nameController.text,
                        'unit': unitController.text,
                        'selling_price':
                            double.tryParse(sellPriceController.text) ?? 0,
                        'purchase_price':
                            double.tryParse(buyPriceController.text) ?? 0,
                        'opening_stock': startingQty,
                        'current_stock': startingQty,
                      });
                      ref.invalidate(stockProvider);
                      Navigator.pop(ctx);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error saving item.')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('SAVE ITEM',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
