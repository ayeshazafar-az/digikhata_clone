\import 'package:flutter/material.dart';
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
    const dOrange = Color(0xFFD63C1B); // DigiKhata Native Orange Theme

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: dOrange,
        elevation: 0,
        title: const Text('Collection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          // Banner Card
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Send Bulk Reminder to Customers', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    balancesState.maybeWhen(
                      data: (balances) {
                         // Fallbacks
                        return Row(
                          children: [
                            const Text('Rs 0', style: TextStyle(color: AppTheme.dangerRed, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(' is with 0 Customer', style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        );
                      },
                      orElse: () => Row(
                         children: [
                           const Text('Rs 0', style: TextStyle(color: AppTheme.dangerRed, fontWeight: FontWeight.bold, fontSize: 16)),
                           Text(' is with 0 Customer', style: TextStyle(color: Colors.grey.shade600)),
                         ],
                       ), // Emulate the SS literally
                    ),
                  ],
                ),
              ),
              // "NEW" Ribbon
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                      decoration: const InputDecoration(
                        hintText: '  0 Customer',
                        hintStyle: TextStyle(color: Colors.black38),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.filter_alt_outlined, color: dOrange, size: 28),
                const SizedBox(width: 12),
                const Icon(Icons.picture_as_pdf_outlined, color: dOrange, size: 28),
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
                _buildFilterChip('All', dOrange),
                _buildFilterChip('Pending', dOrange),
                _buildFilterChip('Due Today', dOrange),
                _buildFilterChip('Upcoming', dOrange),
              ],
            ),
          ),

          const Spacer(),

          // Empty state explicitly replicating the screenshot
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded, size: 100, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text('No data found!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, Color dOrange) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? dOrange : Colors.grey.shade400,
              width: isSelected ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? dOrange : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
