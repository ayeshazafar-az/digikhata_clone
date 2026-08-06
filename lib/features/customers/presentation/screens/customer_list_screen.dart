import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/parties_provider.dart';
import '../../../../core/providers/currency_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  final bool isRoot;
  const CustomerListScreen({super.key, this.isRoot = false});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100, // Reverted Dark Theme
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBlue, // STRICTLY requested feature
          elevation: 0,
          leading: widget.isRoot
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white, size: 20),
                  onPressed: () => context.pop(),
                ),
          title: const Text('Party',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue
                      .withValues(alpha: 0.9), // Match blue theme
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  context.push('/collection');
                },
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
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor:
                Colors.white54, // Fixed invisible contrast bug
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
    final currency = ref.watch(currencyProvider);

    return Stack(
      children: [
        Column(
          children: [
            _buildStatsHeader(isSupplier, isBank, type, currency, context),
            Expanded(
              child: partiesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.black))),
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
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == 'customer')
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.arrow_forward,
                      color: Color(0xFFD63C1B), size: 28),
                ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue, // Enforced Blue theme
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                ),
                onPressed: () {
                  if (isBank) {
                    context.push('/select_bank');
                  } else if (isSupplier) {
                    context.push('/add_contact?type=supplier');
                  } else {
                    context.push('/add_contact?type=customer');
                  }
                },
                icon: Icon(
                    isBank ? Icons.account_balance : Icons.person_add_alt_1,
                    color: Colors.white,
                    size: 20),
                label: Text(
                    isBank
                        ? 'ADD BANK'
                        : 'ADD ${type == 'all' ? 'CUSTOMER' : type.toUpperCase()}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStatsHeader(bool isSupplier, bool isBank, String type,
      String currency, BuildContext context) {
    String leftLabel = isSupplier
        ? 'Total purchase for Aug'
        : (isBank ? 'Total in for Aug' : 'You will give');
    String rightLabel =
        isSupplier ? "You'll Give" : (isBank ? 'Bank Balance' : 'You will get');

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hide Balance',
              style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('$currency 0',
                        style: const TextStyle(
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
                    Text('$currency 0',
                        style: const TextStyle(
                            color: AppTheme.dangerRed,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(rightLabel,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  context.push('/all_transactions_route?type=$type');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: const Icon(Icons.arrow_forward_ios,
                      color: AppTheme.dangerRed, size: 20),
                ),
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, color: Colors.white, size: 24),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE4D8), // Light skin UI circle blob
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(visualIcon,
                      size: 80, color: const Color(0xFF1F5F99)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildStepRow('1- $t1'),
          _buildStepRow('2- Add entries & maintain khata'),
          _buildStepRow('3- $t3'),
          const SizedBox(height: 60),
          // Bouncing arrow mimicking screenshot 1
          const _EmptyStateArrow(),
          const SizedBox(height: 40),
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
            style: const TextStyle(color: Colors.black87, fontSize: 16)),
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
                style: const TextStyle(color: Colors.black54)),
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
