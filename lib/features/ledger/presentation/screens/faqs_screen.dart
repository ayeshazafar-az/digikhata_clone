import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3752A), Color(0xFFE94326)],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildCategory('Manage Customers', [
              'How To Add A New Customer?',
              'How To Add An Entry In Customer Ledger?',
              'How To Share The Transaction?',
              'How To Edit or Delete A Customer?',
              'How To Edit or Delete A Transaction (Entry)?',
              'How To Send A WhatsApp or SMS Collection Reminder To The Customer?',
              'How To Schedule Free Automatic SMS Collection Reminders For The Customers?',
              'How To Enable Free SMS Collection Reminder For The Customer?',
              'How To Share the Customer\'s Ledger Via SMS?',
              'How To Change The Language Of SMS Collection Reminder That Is Sent To The Customer?',
              'How To Schedule SMS Collection Reminder For A Specific Customer?',
              'How To Upload Customer\'s Profile Picture?',
            ]),
            _buildCategory('Manage Suppliers', [
              'How To Add A New Supplier?',
              'How To Add An Entry In Supplier Ledger?',
              'How To Share The Transaction?',
              'How To Edit or Delete A Supplier?',
              'How To Edit or Delete A Transaction (Entry)?',
              'How To Enable Free SMS Collection Reminder For The Supplier?',
              'How To Share the Supplier\'s Ledger Via SMS?',
              'How To Change The Language Of SMS Collection Reminder That Is Sent To The Suppliers?',
              'How To Upload Supplier\'s Profile Picture?',
            ]),
            _buildCategory('My Profile', [
              'How Can I Complete My Profile To 100%?',
              'What is an "App Lock"?',
              'How To Set An App Lock in DigiKhata?',
            ]),
            _buildCategory('Reports', [
              'How Can I Download A Summary Of All Customer\'s Transactions?',
              'How Can I Download A Summary Of All Transactions Of One Customer?',
              'How To Download A Cash Report?',
              'How To Download A Stock Report?',
            ]),
            _buildCategory('Data Backup', [
              'What Is Automatic Data Backup?',
              'Can I Transfer My Data To Another Device?',
              'Can I Manually Backup My Data?',
            ]),
            _buildCategory('Manage Stock & Create Invoice', [
              'How To Add A New Item?',
              'How To Manage Your Inventory?',
              'How To Create Digital Invoice With DigiKhata App?',
            ]),
            _buildCategory('Generate & Share Digital Bills', [
              'How To Create Digital Bills With DigiKhata App?',
              'How To Download A PDF Report About Bills?',
            ]),
            _buildCategory('Sell Easyload/Bundles & Send Payments', [
              'How To Sign In Digi Cash?',
              'How To Complete the Process Of Customer Verification Request In Digi Cash?',
              'How To Add A Bank Account To Your Digi Cash Account?',
              'How To Sell Easyload With DigiKhata?',
              'How To Sell Packages With DigiKhata?',
              'How To Send Payment Link To Your Customers?',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String title, List<String> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: questions.asMap().entries.map((entry) {
              final isLast = entry.key == questions.length - 1;
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
