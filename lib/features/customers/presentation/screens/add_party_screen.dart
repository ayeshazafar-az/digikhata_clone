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

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      String finalPhone = _phoneController.text.trim();
      if (finalPhone.isNotEmpty && !finalPhone.startsWith('+')) {
        finalPhone = '$_selectedCountryCode$finalPhone';
      }

      await ref.read(partiesProvider.notifier).addParty(
            name,
            finalPhone,
            widget.partyType,
          );

      if (mounted) {
        context.pop();
        context.pop();
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Add Customer';
    if (widget.partyType == 'supplier') title = 'Add Supplier';
    if (widget.partyType == 'bank') title = 'Add Bank';

    const dOrange = Color(0xFFD63C1B); // DigiKhata Orange Theme from SS4

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
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: dOrange))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Type ${title.split(' ').last} Name',
                          hintStyle: const TextStyle(color: Colors.black38),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () => _nameController.clear(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone Field with Country Code Picker
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (val) {
                              setState(() {
                                _selectedCountryCode = val.dialCode ?? '+92';
                              });
                            },
                            initialSelection: 'PK',
                            favorite: const ['+92', 'PK'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            textStyle: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.black87),
                              decoration: const InputDecoration(
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(color: Colors.black38),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 64),

                    // Continue Button (like SS 4)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBE4D8),
                          foregroundColor: dOrange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) _submit();
                        },
                        child: Text('CONTINUE',
                            style: TextStyle(
                                color: dOrange.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
