import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/parties_provider.dart';

class AddNewBankScreen extends ConsumerStatefulWidget {
  final String? bankName;
  const AddNewBankScreen({super.key, this.bankName});

  @override
  ConsumerState<AddNewBankScreen> createState() => _AddNewBankScreenState();
}

class _AddNewBankScreenState extends ConsumerState<AddNewBankScreen> {
  late TextEditingController _bankNameController;
  final _accountNumberController = TextEditingController();
  final _accountTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController(text: widget.bankName ?? '');
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Add New Bank Account',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Bank Name Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF2EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance,
                          color: Color(0xFF60A5FA), size: 18),
                    ),
                  ),
                  hintText: 'Bank Name',
                  hintStyle: const TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account Number
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey
                        .shade200), // Slightly lighter border matching reference
              ),
              child: TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  hintText: 'Account Number',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account Title
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _accountTitleController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  hintText: 'Account Title',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button (implicit since user didn't show it but we need it functional)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final bn = _bankNameController.text.trim();
                  final num = _accountNumberController.text.trim();
                  final title = _accountTitleController.text.trim();

                  if (bn.isEmpty || num.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Bank name and account number are required')));
                    return;
                  }

                  final finalName = title.isNotEmpty ? '$bn - $title' : bn;

                  try {
                    await ref
                        .read(partiesProvider.notifier)
                        .addParty(finalName, num, 'bank');
                    if (context.mounted) {
                      context.pop();
                      context.pop(); // Returns to Party tab
                    }
                  } catch (e) {
                    if (context.mounted)
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60A5FA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('SAVE ACCOUNT',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
