import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class BusinessCardScreen extends StatefulWidget {
  const BusinessCardScreen({super.key});

  @override
  State<BusinessCardScreen> createState() => _BusinessCardScreenState();
}

class _BusinessCardScreenState extends State<BusinessCardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 1;

  final TextEditingController _businessNameCtrl = TextEditingController();
  final TextEditingController _userPhoneCtrl = TextEditingController();
  final TextEditingController _ownerNameCtrl = TextEditingController();
  final TextEditingController _businessTypeCtrl = TextEditingController();
  final TextEditingController _businessCategoryCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameCtrl.dispose();
    _userPhoneCtrl.dispose();
    _ownerNameCtrl.dispose();
    _businessTypeCtrl.dispose();
    _businessCategoryCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String get businessName => _businessNameCtrl.text.isEmpty
      ? 'Your Business Name'
      : _businessNameCtrl.text;
  String get userPhone =>
      _userPhoneCtrl.text.isEmpty ? '0000 0000000' : _userPhoneCtrl.text;
  String get ownerName =>
      _ownerNameCtrl.text.isEmpty ? 'Owner Name' : _ownerNameCtrl.text;
  String get businessCategory => _businessCategoryCtrl.text.isEmpty
      ? 'Select Business Category'
      : _businessCategoryCtrl.text;
  String get address =>
      _addressCtrl.text.isEmpty ? 'Islamabad, Pakistan' : _addressCtrl.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title:
            const Text('Business Card', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 16),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Carousel
            SizedBox(
              height: 200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  _buildCardTemplate1(), // Mandala
                  _buildCardTemplate2(), // Hexagonal Mesh simulation
                  _buildCardTemplate3(), // Angular Slashes
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.primaryBlue
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Avatar Logo Box
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.storefront, color: Colors.white, size: 50),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 20),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Registered Mobile Number',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              userPhone,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Input Fields
            _buildInputField(
                'Business Name', _businessNameCtrl, Icons.storefront),
            _buildInputField('Phone Number', _userPhoneCtrl, Icons.phone,
                inputType: TextInputType.phone),
            _buildInputField('Your Name', _ownerNameCtrl, Icons.person_outline),
            _buildInputField(
                'Business Type', _businessTypeCtrl, Icons.local_offer_outlined),
            _buildInputField(
                'Business Category', _businessCategoryCtrl, Icons.work_outline),
            _buildInputField(
                'Address', _addressCtrl, Icons.location_on_outlined,
                maxLines: 2),
            _buildInputField('Email', _emailCtrl, Icons.email_outlined,
                inputType: TextInputType.emailAddress),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFFB91C1C), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add details to share Business Card',
                  style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('ADD DETAILS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
      String hint, TextEditingController controller, IconData icon,
      {int maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: inputType,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: hint.contains('+') || hint.contains('J47P')
                    ? FontWeight.normal
                    : FontWeight.w500),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: Icon(icon, color: const Color(0xFFD32F2F)),
          ),
        ),
      ),
    );
  }

  // --- Templates ---

  // Template 1: Beige Mandala aesthetic
  Widget _buildCardTemplate1() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFFFDECD4)),
        child: Stack(
          children: [
            // Mock Mandala Header Generator
            Positioned(
                top: -60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      5,
                      (i) => Container(
                            width: 80,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                Color(0xFFE53935),
                                Color(0xFFFBC02D),
                                Color(0xFF00796B)
                              ]),
                            ),
                          )),
                )),
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Container(
                  height: 80, color: const Color(0xFFFDECD4).withOpacity(0.5)),
            ),
            // Text Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(businessName,
                      style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(businessCategory,
                      style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontStyle: FontStyle.italic,
                          fontSize: 14)),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ownerName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    Text(userPhone, style: const TextStyle(fontSize: 10)),
                  ]),
            ),
            Positioned(
                bottom: 16,
                right: 16,
                child: SizedBox(
                  width: 150,
                  child: Text(address,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 9)),
                ))
          ],
        ),
      ),
    );
  }

  // Template 2: Hexagonal Midnight Blue / Magenta Mesh
  Widget _buildCardTemplate2() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [Color(0xFF0F172A), Color(0xFF701A75), Color(0xFF991B1B)],
        )),
        child: Stack(
          children: [
            Positioned.fill(
                child: Opacity(
                    opacity: 0.2,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 15),
                      itemBuilder: (_, __) => Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white54, width: 0.5),
                              shape: BoxShape.circle)),
                    ))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(businessName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(businessCategory,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 12)),
                  const SizedBox(height: 16),
                  Text(ownerName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(userPhone,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Text(address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 9)),
            )
          ],
        ),
      ),
    );
  }

  // Template 3: Luxury Black and Gold Slashes
  Widget _buildCardTemplate3() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              top: -20,
              bottom: -20,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 80,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFF3E5AB),
                    Color(0xFF996515)
                  ])),
                ),
              ),
            ),
            Positioned(
              right: -40,
              top: -20,
              bottom: -20,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 80,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFF3E5AB),
                    Color(0xFF996515)
                  ])),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(businessName,
                      style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(businessCategory,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 12)),
                  const SizedBox(height: 16),
                  Text(ownerName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(userPhone,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              left: 32,
              right: 32,
              child: Text(address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 8)),
            )
          ],
        ),
      ),
    );
  }
}
