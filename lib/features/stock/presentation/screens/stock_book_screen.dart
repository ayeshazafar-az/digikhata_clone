import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/theme.dart';

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
  const StockBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock & Inventory',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: stockAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildEmptyState(context, ref),
        data: (products) {
          if (products.isEmpty) return _buildEmptyState(context, ref);

          double totalStockValue = 0;
          for (var p in products) {
            totalStockValue += (double.parse(p['current_stock'].toString()) *
                double.parse(p['purchase_price'].toString()));
          }

          return Column(
            children: [
              _buildHeader(totalStockValue),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.inventory_2,
                            color: AppTheme.primaryBlue),
                      ),
                      title: Text(p['item_name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle:
                          Text('Selling Price: Rs. ${p['selling_price']}'),
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
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      onTap: () {
                        // Action to edit stock, can be added later
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductModal(context, ref),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Item',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(double totalValue) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Stock Value',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            'Rs. $totalValue',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No Items in Stock',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Add products to track inventory and generate bills.',
              style: TextStyle(color: Colors.grey.shade500)),
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
                decoration: const InputDecoration(
                    labelText: 'Item Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: sellPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Selling Price (Rs)',
                              border: OutlineInputBorder()))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: TextField(
                          controller: buyPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Purchase Price (Rs)',
                              border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Opening Stock',
                              border: OutlineInputBorder()))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: TextField(
                          controller: unitController,
                          decoration: const InputDecoration(
                              labelText: 'Unit (pcs, kg, etc)',
                              border: OutlineInputBorder()))),
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Error: Database tables not created yet!')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAVE ITEM',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
