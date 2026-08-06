import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  final List<Map<String, dynamic>> _brands = const [
    {'name': 'Khaadi', 'icon': Icons.local_florist, 'color': Colors.green},
    {'name': 'J.', 'icon': Icons.person, 'color': Colors.black87},
    {'name': 'Nishat', 'icon': Icons.diamond, 'color': Colors.purple},
    {'name': 'Bonanza', 'icon': Icons.eco, 'color': Colors.teal},
  ];

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
              ], // Adhering to the unified app theme
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                const Text('All Brands',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.75,
          ),
          itemCount: _brands.length,
          itemBuilder: (context, index) {
            final brand = _brands[index];
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Icon(
                        brand['icon'] as IconData,
                        size: 40,
                        color: brand['color'] as Color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  brand['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
