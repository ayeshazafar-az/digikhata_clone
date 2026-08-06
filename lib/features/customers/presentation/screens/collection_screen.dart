import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../providers/parties_provider.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final partiesState = ref.watch(partiesProvider);
    final balancesState = ref.watch(partyBalancesProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Collection',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('DigiBazar Store')));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Header Summary Card (matching screenshot)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: partiesState.maybeWhen(
                  data: (parties) {
                    final balances = balancesState.value ?? {};
                    final pendingCustomers = parties
                        .where((p) =>
                            p.type == 'customer' &&
                            (balances[p.remoteId] ?? 0) > 0)
                        .toList();
                    final totalAmount = pendingCustomers.fold(
                        0.0, (sum, p) => sum + (balances[p.remoteId] ?? 0));
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Send Bulk Reminder to Customers',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Rs ${totalAmount.toInt()}',
                                    style: const TextStyle(
                                        color: AppTheme.dangerRed,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                    ' is with ${pendingCustomers.length} Customer',
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              // "NEW" Ribbon
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text('NEW',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          // Search and Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: (val) =>
                          setState(() => _searchQuery = val.toLowerCase()),
                      decoration: const InputDecoration(
                        hintText: 'Search Customer',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.filter_alt_outlined,
                    color: AppTheme.primaryBlue, size: 28),
                const SizedBox(width: 12),
                const Icon(Icons.picture_as_pdf_outlined,
                    color: AppTheme.dangerRed, size: 28),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Pending'),
                _buildFilterChip('Due Today'),
                _buildFilterChip('Upcoming'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: partiesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (parties) {
                final balances = balancesState.value ?? {};
                var pendingCustomers = parties
                    .where((p) =>
                        p.type == 'customer' && (balances[p.remoteId] ?? 0) > 0)
                    .toList();

                if (_searchQuery.isNotEmpty) {
                  pendingCustomers = pendingCustomers
                      .where((p) => p.name.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                if (pendingCustomers.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 100, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text('No data found!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  );
                }

                return ListView.separated(
                  itemCount: pendingCustomers.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade200, height: 1),
                  itemBuilder: (context, index) {
                    final party = pendingCustomers[index];
                    return ListTile(
                      onTap: () => context.push('/customer_ledger/${party.id}'),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppTheme.primaryBlue.withValues(alpha: 0.1),
                        child: Text(party.name.substring(0, 1).toUpperCase(),
                            style:
                                const TextStyle(color: AppTheme.primaryBlue)),
                      ),
                      title: Text(party.name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(party.phone ?? '',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Rs ${balances[party.remoteId] ?? 0}',
                              style: const TextStyle(
                                  color: AppTheme.dangerRed,
                                  fontWeight: FontWeight.bold)),
                          Text('Due',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
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
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade400,
              width: isSelected ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
