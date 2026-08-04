import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddContactScreen extends StatefulWidget {
  final String type; // 'Customer' or 'Supplier'
  const AddContactScreen({super.key, required this.type});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final List<String> dummyContacts = [
    '+923355563280',
    '+923430009010',
    '0331 5888567',
    '0332 5449024',
  ];

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Add ${widget.type}',
            style: const TextStyle(
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
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type Customer Name',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.close, color: Colors.grey),
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
                    child: const Icon(Icons.person_add_alt_1,
                        color: Color(0xFFE94326), size: 20),
                  ),
                  title: Text('Add New ${widget.type}',
                      style: const TextStyle(
                          color: Color(0xFFE94326),
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Color(0xFFE94326)),
                  onTap: () {
                    // Route directly to native AddParty screen to persist via Supabase
                    context
                        .push('/add_party?type=${widget.type.toLowerCase()}');
                  },
                ),
                Divider(color: Colors.grey.shade200, height: 1),
                ...dummyContacts
                    .map((contact) => _buildContactTile(contact))
                    .toList(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContactTile(String contact) {
    bool isPlus = contact.startsWith('+');
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Text(isPlus ? '+' : '0',
                style: const TextStyle(
                    color: Color(0xFFE94326),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          title: Text(contact,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87)),
          subtitle: Text(contact,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          onTap: () {
            context.push(
                '/add_party?type=${widget.type.toLowerCase()}&phone=$contact');
          },
        ),
        Divider(color: Colors.grey.shade100, height: 1, indent: 80),
      ],
    );
  }
}
