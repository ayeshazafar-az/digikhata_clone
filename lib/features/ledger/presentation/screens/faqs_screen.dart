import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final faqsProvider =
    FutureProvider<Map<String, List<Map<String, dynamic>>>>((ref) async {
  final supabase = Supabase.instance.client;
  try {
    final response = await supabase
        .from('faqs')
        .select()
        .order('category')
        .order('created_at');
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in response) {
      final cat = item['category'] ?? 'General';
      if (!grouped.containsKey(cat)) grouped[cat] = [];
      grouped[cat]!.add(item);
    }
    return grouped;
  } catch (e) {
    if (e.toString().contains('relation "public.faqs" does not exist')) {
      throw Exception(
          'Please run the provided SQL policies script to create the live faqs table.');
    }
    rethrow;
  }
});

class FaqsScreen extends ConsumerWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqsAsync = ref.watch(faqsProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text('FAQs', style: TextStyle(color: Colors.white)),
        ),
        body: faqsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Failed to load FAQs: $e',
                        textAlign: TextAlign.center))),
            data: (groupedFaqs) {
              if (groupedFaqs.isEmpty) {
                return const Center(child: Text('No FAQs published yet.'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    ...groupedFaqs.entries.map((entry) =>
                        _buildCategory(context, entry.key, entry.value)),
                  ],
                ),
              );
            }));
  }

  Widget _buildCategory(
      BuildContext context, String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              final question = entry.value['question'] ?? 'Unnamed Question';
              final answer = entry.value['answer'] ?? 'No response provided.';
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        question,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500),
                      ),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      childrenPadding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      iconColor: const Color(0xFF1E3A8A),
                      collapsedIconColor: Colors.grey,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            answer,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: Colors.grey.shade200),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
