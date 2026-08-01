import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';

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

class BillBookScreen extends ConsumerWidget {
  const BillBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF151515), // Very dark background matching screens
      appBar: AppBar(
        title: const Text('Bill Book',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF151515),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          const Center(
              child: Text('03245423290',
                  style: TextStyle(color: Colors.white70, fontSize: 12))),
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
                  _buildCounterSaleTab(context),
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
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total sale for August',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
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
                            color: const Color(0xFF252525),
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
                                      color: Colors.white,
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
                            color: const Color(0xFF252525),
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
                                      color: Colors.white,
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
                        style: const TextStyle(color: Colors.white))),
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
                          backgroundColor: Colors.amber.withOpacity(0.2),
                          child: const Icon(Icons.receipt_long,
                              color: Colors.amber),
                        ),
                        title: Text(b['customer_name'] ?? 'Walk-in Customer',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
                                    color: Colors.white)),
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
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('CREATE NEW BILL',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
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
                child: const Icon(Icons.lock, color: Colors.white, size: 18),
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
  Widget _buildCounterSaleTab(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
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
                color: const Color(0xFF151515),
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
                                  color: Colors.white,
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
                  color: const Color(
                      0xFF1C1111), // Reddish dark tone from screenshot
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF252525),
                          ),
                          child: const Center(
                              child: Icon(Icons.add,
                                  color: Colors.green, size: 40)),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        // Cart Bottom Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: const Color(0xFF5A3125), // Dark brown cart color
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shopping_cart_checkout,
                      color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text('0 Items',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text('Rs 0.00',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }
}
