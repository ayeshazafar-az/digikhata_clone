import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/utils/pdf_service.dart';
import '../../../stock/presentation/screens/stock_book_screen.dart'; // import stockProvider

final billsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final profileRes =
      await supabase.from('profiles').select('active_business_id').single();
  final activeBusinessId = profileRes['active_business_id'];

  if (activeBusinessId == null) return [];

  final res = await supabase
      .from('bills')
      .select()
      .eq('business_id', activeBusinessId)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
});

// Cart State: productId -> quantity
class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  void add(String pid) {
    state = {...state, pid: (state[pid] ?? 0) + 1};
  }

  void clear() {
    state = {};
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>(
    (ref) => CartNotifier());

class BillBookScreen extends ConsumerWidget {
  const BillBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Very dark background matching screens
      appBar: AppBar(
        title: const Text('Bill Book',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const Center(
              child: Text('03245423290',
                  style: TextStyle(color: Colors.black87, fontSize: 12))),
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0, top: 12.0, bottom: 12.0, left: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryOrange,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('STOCK BOOK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
              indicatorColor: AppTheme.secondaryOrange,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Bills'),
                Tab(text: 'Counter Sale'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBillsTab(context, ref),
                  _buildCounterSaleTab(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsTab(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsProvider);

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total sale for August',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 16)),
                        Text('Rs 0',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month,
                                  color: Colors.grey, size: 20),
                              SizedBox(width: 8),
                              Text('Start Date',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Container(width: 1, height: 20, color: Colors.white24),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_month,
                                  color: Colors.grey, size: 20),
                              SizedBox(width: 8),
                              Text('End Date',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: billsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.black87))),
                data: (bills) {
                  if (bills.isEmpty) return _buildBillsEmptyState();
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 16, bottom: 80),
                    itemCount: bills.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade800),
                    itemBuilder: (context, index) {
                      final b = bills[index];
                      final date = DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(b['created_at']));
                      final isPaid = b['status'] == 'paid';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.withValues(alpha: 0.2),
                          child: const Icon(Icons.receipt_long,
                              color: Colors.amber),
                        ),
                        title: Text(b['customer_name'] ?? 'Walk-in Customer',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        subtitle: Text('Date: $date',
                            style: const TextStyle(color: Colors.grey)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Rs. ${b['total_amount']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87)),
                            Text(isPaid ? 'PAID' : 'UNPAID',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isPaid ? Colors.green : Colors.red)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.black87),
            label: const Text('CREATE NEW BILL',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF05A28),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillsEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: const Icon(Icons.receipt_long,
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
                Text("1- Create bills",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("2- Share with customers",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("3- Get paid 3X faster",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // POS MATRIX COUNTER SALE
  Widget _buildCounterSaleTab(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockProvider);
    final cart = ref.watch(cartProvider);

    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(Icons.qr_code_scanner, color: AppTheme.secondaryOrange),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Nav
              Container(
                width: 80,
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFF252525),
                        border: Border(
                            left: BorderSide(
                                color: AppTheme.secondaryOrange, width: 4)),
                      ),
                      child: const Center(
                          child: Text('All',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF1C1C1C),
                      child: const Center(
                          child:
                              Icon(Icons.add, color: Colors.green, size: 32)),
                    )
                  ],
                ),
              ),
              // Grid View
              Expanded(
                child: Container(
                  color: const Color(0xFF1C1111), // Reddish dark tone
                  child: stockAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => const Center(
                          child: Text('Error',
                              style: TextStyle(color: Colors.black87))),
                      data: (products) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Use Stock Book to Add Items')));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black87,
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.add,
                                          color: Colors.green, size: 40)),
                                ),
                              );
                            }
                            final p = products[index - 1];
                            final pid = p['id'].toString();
                            final qtyInCart = cart[pid] ?? 0;

                            return InkWell(
                              onTap: () =>
                                  ref.read(cartProvider.notifier).add(pid),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black87,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.inventory_2,
                                              color: Colors.grey, size: 40),
                                          const SizedBox(height: 12),
                                          Text(p['item_name'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text('Rs. ${p['selling_price']}',
                                              style: const TextStyle(
                                                  color: Colors.green)),
                                        ],
                                      ),
                                    ),
                                    if (qtyInCart > 0)
                                      Positioned(
                                          top: 8,
                                          right: 8,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor:
                                                AppTheme.secondaryOrange,
                                            child: Text(qtyInCart.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              )
            ],
          ),
        ),
        // Cart Bottom Bar
        Consumer(builder: (context, ref, child) {
          final currentCart = ref.watch(cartProvider);
          final activeProducts = ref.watch(stockProvider).value ?? [];

          int totalItems = 0;
          double totalPrice = 0;

          currentCart.forEach((pid, qty) {
            totalItems += qty;
            final prod = activeProducts
                .firstWhere((p) => p['id'].toString() == pid, orElse: () => {});
            if (prod.isNotEmpty) {
              totalPrice +=
                  (double.tryParse(prod['selling_price'].toString()) ?? 0) *
                      qty;
            }
          });

          return InkWell(
            onTap: () async {
              if (totalItems == 0) return;
              // Real Checkout Logic
              final supabase = Supabase.instance.client;
              final pRes = await supabase
                  .from('profiles')
                  .select('active_business_id')
                  .single();
              final bId = pRes['active_business_id'];
              if (bId != null) {
                // Generate Invoice Data
                List<Map<String, dynamic>> invoiceItems = [];

                // 1. Deduct Stock for all cart items!
                for (var pid in currentCart.keys) {
                  final qty = currentCart[pid]!;
                  final prod = activeProducts.firstWhere(
                      (p) => p['id'].toString() == pid,
                      orElse: () => {});
                  if (prod.isNotEmpty) {
                    final currentStock =
                        int.tryParse(prod['opening_stock'].toString()) ?? 0;
                    final price =
                        double.tryParse(prod['selling_price'].toString()) ??
                            0.0;

                    // Supabase mutation
                    await supabase.from('products').update({
                      'opening_stock': (currentStock - qty).toString(),
                    }).eq('id', pid);

                    invoiceItems.add({
                      'name': prod['item_name'],
                      'qty': qty,
                      'price': price,
                    });
                  }
                }

                // 2. Generate Real Bill Record
                await supabase.from('bills').insert({
                  'business_id': bId,
                  'customer_name': 'Walk-in Counter Sale',
                  'total_amount': totalPrice,
                  'status': 'paid' // immediate checkout mark as paid
                });

                // 3. Clear and Invalidate Providers
                ref.read(cartProvider.notifier).clear();
                ref.invalidate(billsProvider);
                ref.invalidate(stockProvider);

                // 4. Generate And Launch Invoice PDF!
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Sale logged. Generating PDF Invoice...'),
                      backgroundColor: Colors.green));
                }

                await PdfService.generateInvoice(
                    items: invoiceItems, totalAmount: totalPrice);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: const Color(0xFF5A3125), // Dark brown cart color
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart_checkout,
                          color: Colors.black87, size: 24),
                      const SizedBox(width: 8),
                      Text('$totalItems Items',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('Rs $totalPrice (CHECKOUT)',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
