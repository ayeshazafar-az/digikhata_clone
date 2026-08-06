import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../app/theme.dart';
import '../../providers/parties_provider.dart';

class AddPartyScreen extends ConsumerStatefulWidget {
  final String partyType;
  const AddPartyScreen({super.key, required this.partyType});

  @override
  ConsumerState<AddPartyScreen> createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends ConsumerState<AddPartyScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+92';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Parse name and phone from GoRouter if pushing from AddContactScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      final prefillPhone = state.uri.queryParameters['phone'] ?? '';
      final prefillName = state.uri.queryParameters['name'] ?? '';
      if (prefillPhone.isNotEmpty) {
        _phoneController.text = prefillPhone;
      }
      if (prefillName.isNotEmpty) {
        _nameController.text = prefillName;
      }
    });
  }

  void _triggerMockContactPermission() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.contacts, color: Colors.white70, size: 40),
            const SizedBox(height: 16),
            const Text(
              'Allow DigiKhata to access your contacts?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  // Normally would launch a contact picker here
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacts linked.')));
                },
                child: const Text('Allow',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Don't allow",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveParty() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
      await ref.read(partiesProvider.notifier).addParty(
          name, phone.replaceAll(RegExp(r'\s+'), ''), widget.partyType);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Add Customer';
    if (widget.partyType == 'supplier') title = 'Add Supplier';
    if (widget.partyType == 'bank') title = 'Add Bank';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type $title Name',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: Icon(Icons.close, color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.partyType != 'bank')
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: CountryCodePicker(
                      onChanged: (code) {
                        setState(() {
                          _selectedCountryCode = code.dialCode ?? '+92';
                        });
                      },
                      initialSelection: 'PK',
                      favorite: const ['+92', 'PK'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      textStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      searchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey.shade800,
                        filled: true,
                      ),
                      dialogBackgroundColor: Colors.grey.shade900,
                      dialogTextStyle: const TextStyle(color: Colors.white),
                    ),
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ListTile(
              onTap: _triggerMockContactPermission,
              leading: Icon(Icons.person_add_alt_1,
                  color: AppTheme.dangerRed), // matching screenshot UI
              title: Text('Import from Contacts',
                  style: TextStyle(color: Colors.grey.shade400)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.dangerRed, // using matching theme primary
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _saveParty,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SAVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
