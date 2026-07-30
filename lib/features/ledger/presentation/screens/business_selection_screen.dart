import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';

class BusinessSelectionScreen extends StatelessWidget {
  const BusinessSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Businesses'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Icon(Icons.store, color: Colors.white),
            ),
            title: Text('Business ${index + 1}'),
            subtitle: const Text('Tap to switch'),
            trailing: index == 0
                ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
                : null,
            onTap: () {
              context.pop(); // go back to dashboard
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show dialog to add new business
        },
        icon: const Icon(Icons.add),
        label: const Text('New Business'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
