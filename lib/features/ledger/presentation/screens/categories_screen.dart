import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/digi_bazar_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(bazarCategoriesProvider);

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
            child: categoriesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error')),
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Center(child: Text('Empty'));
                  }
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = index == _selectedIndex;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppTheme.primaryBlue, width: 1.5),
                                )
                              : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  category['icon_url'],
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
                                      ? AppTheme.primaryBlue
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),

          // Right Content Canvas
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16.0),
              child: categoriesState.when(
                  loading: () => const SizedBox(),
                  error: (e, s) => const SizedBox(),
                  data: (categories) {
                    if (categories.isEmpty) return const SizedBox();
                    final activeCategory = categories[
                        _selectedIndex < categories.length
                            ? _selectedIndex
                            : 0];

                    List<String> subcategories = [];
                    try {
                      subcategories = List<String>.from(
                          jsonDecode(activeCategory['subcategories'] ?? '[]'));
                    } catch (e) {}

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(activeCategory['icon_url']),
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Shop by Category',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Subcategories List
                        Expanded(
                          child: ListView.separated(
                            itemCount: subcategories.length,
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
                                        color: AppTheme.primaryBlue
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.grid_view_rounded,
                                          color: AppTheme.primaryBlue,
                                          size: 18),
                                    ),
                                    title: Text(
                                      subcategories[index],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Explore items for ${subcategories[index].toLowerCase()}...',
                                            style: const TextStyle(
                                                color: Colors.grey),
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
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
