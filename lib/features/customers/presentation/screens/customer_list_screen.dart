import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/parties_provider.dart';

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partiesState = ref.watch(partiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers & Suppliers'),
      ),
      body: partiesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err', textAlign: TextAlign.center),
              ElevatedButton(
                onPressed: () =>
                    ref.read(partiesProvider.notifier).loadParties(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (parties) {
          if (parties.isEmpty) {
            return const Center(
              child: Text(
                'No Customers/Suppliers yet.\nTap Add Customer to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: parties.length,
            itemBuilder: (context, index) {
              final party = parties[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.secondaryBlue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(party.name),
                subtitle: Text('Tap to view ledger • ${party.phone ?? ''}'),
                trailing: Text(
                  party.type.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                onTap: () {
                  context.push('/customer_ledger', extra: party.remoteId);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddPartyDialog(context, ref);
        },
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label:
            const Text('Add Customer', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showAddPartyDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedType = 'customer';
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Party'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name *'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: const [
                    DropdownMenuItem(
                        value: 'customer', child: Text('Customer')),
                    DropdownMenuItem(
                        value: 'supplier', child: Text('Supplier')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedType = val);
                  },
                  decoration: const InputDecoration(labelText: 'Party Type'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) return;
                        setState(() => isLoading = true);
                        try {
                          await ref.read(partiesProvider.notifier).addParty(
                                nameController.text.trim(),
                                phoneController.text.trim(),
                                selectedType,
                              );
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          setState(() => isLoading = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')));
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
            ],
          );
        });
      },
    );
  }
}
