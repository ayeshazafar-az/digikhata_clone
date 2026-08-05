import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactScreen extends StatefulWidget {
  final String type; // 'Customer' or 'Supplier'
  const AddContactScreen({super.key, required this.type});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (kIsWeb) {
      setState(() => _contacts = []);
      return;
    }

    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        final contacts = await FlutterContacts.getAll();
        setState(() => _contacts = contacts);
      } else {
        setState(() => _permissionDenied = true);
      }
    } catch (e) {
      if (mounted) setState(() => _contacts = []);
    }
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
        title: Text('Add ${widget.type}',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Column(
        children: [
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
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Type Customer Name',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildContactsList(),
          )
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    if (_permissionDenied) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
              'Contact permissions strictly required to sync your address book. Please enable them in OS settings.',
              textAlign: TextAlign.center),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF60A5FA)));
    }

    final filteredContacts = _searchQuery.isEmpty
        ? _contacts!
        : _contacts!
            .where((c) =>
                (c.displayName ?? '').toLowerCase().contains(_searchQuery))
            .toList();

    return ListView(
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
                color: Color(0xFF60A5FA), size: 20),
          ),
          title: Text('Add New ${widget.type}',
              style: const TextStyle(
                  color: Color(0xFF60A5FA),
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF60A5FA)),
          onTap: () {
            context.push('/add_party?type=${widget.type.toLowerCase()}');
          },
        ),
        Divider(color: Colors.grey.shade200, height: 1),
        ...filteredContacts.map((contact) {
          final phone =
              contact.phones.isNotEmpty ? contact.phones.first.number : '';
          if (phone.isEmpty) return const SizedBox.shrink();
          return _buildContactTile((contact.displayName ?? 'Unknown'), phone);
        }),
      ],
    );
  }

  Widget _buildContactTile(String name, String phone) {
    bool isPlus = phone.startsWith('+');
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
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          title: Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87)),
          subtitle: Text(phone,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          onTap: () {
            context.push(
                '/add_party?type=${widget.type.toLowerCase()}&phone=$phone');
          },
        ),
        Divider(color: Colors.grey.shade100, height: 1, indent: 80),
      ],
    );
  }
}
