import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectBankScreen extends StatelessWidget {
  const SelectBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dummyBanks = [
      {'name': 'JazzCash(JC)', 'color': Colors.black87},
      {'name': 'EasyPaisa(EP)', 'color': Colors.green},
      {'name': 'Upaisa(Upaisa)', 'color': Colors.orange},
      {'name': 'Alfa Pay(Apy)', 'color': Colors.red},
      {'name': 'Allied Bank Limited(ABL)', 'color': Colors.blue},
      {'name': 'Faysal Bank Limited(FBL)', 'color': Colors.indigo},
      {'name': 'Bank AlFalah Limited(BAF)', 'color': Colors.redAccent},
      {'name': 'Meezan Bank(MEZ)', 'color': Colors.deepPurple},
      {'name': 'Muslim Commercial Bank(MCB)', 'color': Colors.teal},
      {'name': 'United Bank Limited(UBL)', 'color': Colors.lightBlue},
      {
        'name': 'Advance Microfinance Bank (AMB)',
        'color': Colors.greenAccent.shade700
      },
      {
        'name': 'Al Baraka Islamic Bank Limited(BAB)',
        'color': Colors.orangeAccent
      },
    ];

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
        title: const Text('Select Bank',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance,
                        color: Color(0xFF60A5FA), size: 20),
                  ),
                  title: const Text('Add Bank',
                      style: TextStyle(
                          color: Color(0xFF60A5FA),
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Color(0xFF60A5FA)),
                  onTap: () {
                    context.push('/add_new_bank');
                  },
                ),
                const SizedBox(height: 8),
                ...dummyBanks
                    .map((bank) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: bank['color']
                                  as Color, // Simplified logo representation
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text(
                                    (bank['name'] as String).substring(0, 1),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))),
                          ),
                          title: Text(bank['name'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87)),
                          onTap: () {
                            context
                                .push('/add_new_bank?bankName=${bank['name']}');
                          },
                        ))
                    ,
                const SizedBox(height: 24),
              ],
            ),
          )
        ],
      ),
    );
  }
}
