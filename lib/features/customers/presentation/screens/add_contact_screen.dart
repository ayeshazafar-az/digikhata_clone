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
        // Fetch phones properly in the newer flutter_contacts version
        final contacts = await FlutterContacts.getAll(
            properties: {ContactProperty.name, ContactProperty.phone});
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
    // DigiKhata native orange
    const dOrange = Color(0xFFD63C1B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: dOrange,
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
                      color: Colors.black.withValues(alpha: 0.02),
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
            child: _buildContactsList(dOrange),
          )
        ],
      ),
    );
  }

  Widget _buildContactsList(Color dOrange) {
    if (_permissionDenied) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.contacts, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                  'Contact sharing required to sync your address book. Please enable them in OS settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => openAppSettings(),
                style: ElevatedButton.styleFrom(backgroundColor: dOrange),
                child: const Text('Open Settings',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    }

    if (_contacts == null) {
      return Center(child: CircularProgressIndicator(color: dOrange));
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
                color: Colors.red.shade50, shape: BoxShape.circle),
            child: Icon(Icons.person_add_alt_1, color: dOrange, size: 20),
          ),
          title: Text('Add New ${widget.type}',
              style: TextStyle(
                  color: dOrange, fontWeight: FontWeight.w500, fontSize: 16)),
          trailing: Icon(Icons.chevron_right, color: dOrange),
          onTap: () {
            context.push('/add_party?type=${widget.type}');
          },
        ),
        Divider(color: Colors.grey.shade200, height: 1),
        ...filteredContacts.map((contact) {
          final firstPhone =
              contact.phones.isNotEmpty ? contact.phones.first : null;
          final normNum = firstPhone?.normalizedNumber ?? '';
          final rawNum = firstPhone?.number ?? '';
          final phone = normNum.isNotEmpty ? normNum : rawNum;
          if (phone.isEmpty) return const SizedBox.shrink();
          return _buildContactTile(
              contact.displayName ?? '', phone, dOrange, contact);
        }),
      ],
    );
  }

  Widget _buildContactTile(
      String name, String phone, Color dOrange, Contact contact) {
    bool isPlus = phone.startsWith('+');
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Text(isPlus ? '+' : '0',
                style: TextStyle(
                    color: dOrange, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          title: Text(phone,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(phone,
              style: const TextStyle(
                  color: Colors.black54)), // Mirroring SS3 logic
          onTap: () {
            // They chose an existing contact. Pass it to add_party auto-filled.
            context
                .push('/add_party?type=${widget.type}&name=$name&phone=$phone');
          },
        ),
        Divider(
            color: Colors.grey.shade200, indent: 80, endIndent: 24, height: 1),
      ],
    );
  }
}
