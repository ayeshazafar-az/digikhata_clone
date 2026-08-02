import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/parties_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor:
            const Color(0xFF1E1E1E), // Dark Background mimicking image
        appBar: AppBar(
          backgroundColor: const Color(0xFF181818),
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text('Party',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.secondaryOrange, // Using matching tone
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: const Text('COLLECTION',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            )
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF9900),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(text: 'Customers'),
              Tab(text: 'Suppliers'),
              Tab(text: 'Banks'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PartyTab(
                type: 'customer',
                title1: 'Add customers',
                title3: 'Send payment reminders'),
            _PartyTab(
                type: 'supplier',
                title1: 'Add suppliers',
                title3: 'Manage your purchases'),
            _PartyTab(
                type: 'bank',
                title1: 'Add banks',
                title3: 'Manage your bank balance'),
            _PartyTab(
                type: 'all',
                title1: 'Add customers',
                title3: 'Send payment reminders'),
          ],
        ),
      ),
    );
  }
}

class _PartyTab extends ConsumerWidget {
  final String type;
  final String title1;
  final String title3;

  const _PartyTab(
      {required this.type, required this.title1, required this.title3});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partiesState = ref.watch(partiesProvider);

    // Determine dynamic properties based on strictly scoped type
    final isSupplier = type == 'supplier';
    final isBank = type == 'bank';
    final btnColor = isBank
        ? AppTheme.dangerRed
        : (isSupplier ? Colors.green : AppTheme.secondaryOrange);

    return Stack(
      children: [
        Column(
          children: [
            _buildStatsHeader(isSupplier, isBank),
            Expanded(
              child: partiesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.white))),
                data: (parties) {
                  final filtered = type == 'all'
                      ? parties
                      : parties.where((p) => p.type == type).toList();
                  if (filtered.isEmpty) {
                    return _buildEmptyState(title1, title3, context);
                  }
                  return _buildPartyList(filtered, context);
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_forward_outlined,
                    color: AppTheme.dangerRed, size: 28),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.push(
                      '/add_party?type=${type == "all" ? "customer" : type}'),
                  icon: const Icon(Icons.person_add_alt_1,
                      color: Colors.white, size: 20),
                  label: Text(
                      'ADD ${type == 'all' ? 'CUSTOMER' : type.toUpperCase()}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatsHeader(bool isSupplier, bool isBank) {
    String leftLabel = isSupplier
        ? 'Total purchase for Aug'
        : (isBank ? 'Total in for Aug' : 'You will give');
    String rightLabel =
        isSupplier ? "You'll Give" : (isBank ? 'Bank Balance' : 'You will get');

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hide Balance',
              style: TextStyle(
                  color: AppTheme.secondaryOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Rs 0',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(leftLabel,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: Colors.grey.shade800),
              Expanded(
                child: Column(
                  children: [
                    const Text('Rs 0',
                        style: TextStyle(
                            color: AppTheme.dangerRed,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(rightLabel,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(String t1, String t3, BuildContext context) {
    IconData visualIcon = Icons.supervised_user_circle;
    if (type == 'supplier') visualIcon = Icons.local_shipping;
    if (type == 'bank') visualIcon = Icons.account_balance;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.brown.withValues(alpha: 0.3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(visualIcon, size: 90, color: Colors.white),
                Positioned(
                  top: 20,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child:
                        const Icon(Icons.lock, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildStepRow('1- $t1'),
          _buildStepRow('2- Add entries & maintain khata'),
          _buildStepRow('3- $t3'),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStepRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ),
    );
  }

  Widget _buildPartyList(List parties, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80), // Fab spacing
      child: ListView.builder(
        itemCount: parties.length,
        itemBuilder: (context, index) {
          final party = parties[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.secondaryBlue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title:
                Text(party.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text('Tap to view ledger • ${party.phone ?? ''}',
                style: const TextStyle(color: Colors.white54)),
            trailing: Text(
              party.type.toUpperCase(),
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
            onTap: () =>
                context.push('/customer_ledger', extra: party.remoteId),
          );
        },
      ),
    );
  }
}
