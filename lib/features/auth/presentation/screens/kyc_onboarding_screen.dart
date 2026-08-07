import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class KycOnboardingScreen extends StatefulWidget {
  const KycOnboardingScreen({super.key});

  @override
  State<KycOnboardingScreen> createState() => _KycOnboardingScreenState();
}

class _KycOnboardingScreenState extends State<KycOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isNotBusinessPerson = false;
  bool _isLoading = false;
  bool _isLoadingLocation = false;

  String? _selfiePath;
  String? _cnicFrontPath;
  String? _cnicBackPath;

  @override
  void initState() {
    super.initState();
    _autoFetchLocation();
  }

  Future<void> _autoFetchLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) return;
      }

      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';

        if (mounted) {
          setState(() {
            _locationController.text = address
                .replaceAll(RegExp(r'^,\s*'), '')
                .replaceAll(RegExp(r',\s*,'), ',')
                .trim();
            if (_locationController.text.endsWith(',')) {
              _locationController.text = _locationController.text
                  .substring(0, _locationController.text.length - 1);
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Location fetch error: $e');
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  String? _businessType;
  String? _businessCategory;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    // Note: Can be generalized to pick from camera directly or show a dialog chooser
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'selfie') _selfiePath = image.path;
        if (type == 'cnic_front') _cnicFrontPath = image.path;
        if (type == 'cnic_back') _cnicBackPath = image.path;
      });
    }
  }

  void _showBusinessTypeSheet() {
    final types = [
      {'name': 'Retailer/ Shop', 'icon': Icons.storefront},
      {'name': 'Wholesaler', 'icon': Icons.inventory},
      {'name': 'Distributor', 'icon': Icons.local_shipping},
      {'name': 'Manufacturer', 'icon': Icons.precision_manufacturing},
      {'name': 'Services', 'icon': Icons.handyman},
      {'name': 'Others', 'icon': Icons.category},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apke business ki type kya hai?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: types.map((t) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _businessType = t['name'] as String;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width / 2) - 24,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(t['icon'] as IconData,
                              color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t['name'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showCategorySheet() {
    final categories = [
      'Grocery',
      'Fashion & Textile',
      'Pharmacy & Medical Care',
      'Mobile & Electronics',
      'Vehicle Accessories',
      'Gym & Sports',
      'Babies & Toys',
      'Bakery & Cake',
      'Books & Stationery',
      'Chicken & Meat',
      'Gardening',
      'Hardware Tools',
      'Home Décor',
      'Jewellery',
      'Restaurants & Hotels'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(categories[index]),
                        onTap: () {
                          setState(() {
                            _businessCategory = categories[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Update KYC status
        await Supabase.instance.client.from('profiles').update({
          'kyc_status': 'verified',
        }).eq('id', user.id);

        // All users (Personal & Business) receive a ledger in the businesses table
        await Supabase.instance.client.from('businesses').insert({
          'owner_id': user.id,
          'name': _nameController.text.trim(),
          'type':
              _isNotBusinessPerson ? 'Personal' : (_businessType ?? 'Retail'),
        });
      }

      if (mounted) context.go('/pin_setup', extra: !_isNotBusinessPerson);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_rounded,
                color: AppTheme.primaryBlue, size: 28),
            const SizedBox(width: 8),
            const Text(
              'DigiKhata',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's create your profile",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please enter your profile & business information",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Personal Section
            const Text(
              "Personal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImagePickerBox('Selfie', _selfiePath, 'selfie'),
                _buildImagePickerBox(
                    'CNIC Front', _cnicFrontPath, 'cnic_front'),
                _buildImagePickerBox('CNIC Back', _cnicBackPath, 'cnic_back'),
              ],
            ),

            const SizedBox(height: 32),

            // Business Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Business",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isNotBusinessPerson,
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) {
                          setState(() {
                            _isNotBusinessPerson = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "I am not a business person",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Form Elements Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: _isNotBusinessPerson
                          ? 'Personal ledger name'
                          : 'Apny business ka Nam dein',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),

                  if (!_isNotBusinessPerson) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showBusinessTypeSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _businessType ?? 'Apke business ki type kya hai?',
                              style: TextStyle(
                                color: _businessType != null
                                    ? Colors.black
                                    : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showCategorySheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _businessCategory ??
                                  'Apke business ki category kya hai?',
                              style: TextStyle(
                                color: _businessCategory != null
                                    ? Colors.black
                                    : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Location Simulation
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, bottom: 16, right: 48),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _locationController,
                          maxLines: null,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Enter your address or pin location',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          color: Colors.white,
                          child: Text(
                            _isNotBusinessPerson
                                ? 'Address'
                                : 'Shop / Building Number',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Icon(Icons.location_on,
                            color: AppTheme.primaryBlue),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(
      String label, String? currentPath, String typeTag) {
    bool hasImage = currentPath != null;
    return GestureDetector(
      onTap: () => _pickImage(typeTag),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(currentPath),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.camera_alt_outlined,
                    color: Colors.grey, size: 48),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          )
        ],
      ),
    );
  }
}
