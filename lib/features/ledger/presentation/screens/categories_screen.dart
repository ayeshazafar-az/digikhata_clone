import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Men',
      'imageUrl':
          'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=200&q=80'
    },
    {
      'name': 'Women',
      'imageUrl':
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=200&q=80'
    },
    {
      'name': 'Kids',
      'imageUrl':
          'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=200&q=80'
    },
  ];

  final List<String> _subcategories = [
    'Accessories',
    'Clothing',
    'Footwear',
    'Underwear & Sleepwear'
  ];

  @override
  Widget build(BuildContext context) {
    final activeCategory = _categories[_selectedIndex];

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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                const Text('Categories',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Rail Navigation
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppTheme.dangerRed, width: 1.5),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            category['imageUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.dangerRed
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right Content Canvas
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Category Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(activeCategory['imageUrl']),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        activeCategory['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search in categories...',
                                isDense: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subcategories Tiles
                  Expanded(
                    child: ListView.separated(
                      itemCount: _subcategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors
                                  .transparent, // Removes internal ExpansionTile borders
                            ),
                            child: ExpansionTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.dangerRed.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.grid_view_rounded,
                                    color: AppTheme.dangerRed, size: 18),
                              ),
                              title: Text(
                                _subcategories[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Explore items for ${_subcategories[index].toLowerCase()}...',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
