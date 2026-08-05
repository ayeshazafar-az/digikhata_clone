import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KycOnboardingScreen extends StatefulWidget {
  const KycOnboardingScreen({super.key});

  @override
  State<KycOnboardingScreen> createState() => _KycOnboardingScreenState();
}

class _KycOnboardingScreenState extends State<KycOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();

  bool _isProcessing = false;
  bool _mockErrorThrown = false;

  void _nextPage() {
    if (_currentIndex < 3) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentIndex++);
    } else {
      _submitKyc();
    }
  }

  Future<void> _captureImage() async {
    if (_currentIndex == 1) {
      _nextPage();
    } else if (_currentIndex == 2) {
      _nextPage();
    } else if (_currentIndex == 3) {
      if (!_mockErrorThrown) {
        // Simulate the OCR error!
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Verification Failed: NADRA Barcode unreadable on the back. Please strictly align your CNIC within the box and retake!'),
          backgroundColor: AppTheme.dangerRed,
          duration: Duration(seconds: 4),
        ));
        setState(() => _mockErrorThrown = true);
        return;
      }
      _submitKyc();
    }
  }

  Future<void> _submitKyc() async {
    setState(() => _isProcessing = true);

    // Simulate complex ML upload processing...
    await Future.delayed(const Duration(seconds: 3));

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        // Just mocking the URL response for now since we don't need real storage files to prove the UI flow
        await Supabase.instance.client.from('profiles').update({
          'full_name': _nameController.text.trim(),
          'kyc_status': 'verified',
        }).eq('id', user.id);

        // Push to business creation if business name provided
        if (_businessController.text.trim().isNotEmpty) {
          await Supabase.instance.client.from('businesses').insert({
            'owner_id': user.id,
            'name': _businessController.text.trim(),
            'type': 'Retail',
          });
        }
      }
      if (mounted) context.go('/home');
    } catch (e) {
      debugPrint('KYC Submit Error: $e');
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCameraOverlay(String title, String instruction, bool isSquare) {
    return Stack(
      children: [
        // Simulated Camera Viewfinder
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isSquare ? Icons.person_outline : Icons.credit_card,
                    size: 80, color: Colors.white30),
                const SizedBox(height: 16),
                const Text('SIMULATED CAMERA',
                    style: TextStyle(
                        color: Colors.white30,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        // Dark Overlay with Cutout mockup (rendered simply as a border for simulation)
        Center(
          child: Container(
            width: isSquare ? 300 : 320,
            height: isSquare ? 300 : 200,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppTheme.successGreen, width: 3),
              borderRadius: BorderRadius.circular(isSquare ? 150 : 16),
            ),
          ),
        ),
        // UI Elements
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                instruction,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _captureImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: Colors.white30,
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.verified_user, color: Colors.white, size: 80),
              SizedBox(height: 24),
              Text(
                'Running ML Liveness & NADRA Validation...',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(color: AppTheme.successGreen),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Basic Info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.badge, size: 80, color: AppTheme.primaryBlue),
                const SizedBox(height: 24),
                const Text('KYC Identity Check',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text(
                    'As per local regulations, DigiKhata requires identity verification for full platform access.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name (As per CNIC)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _businessController,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().length > 3) _nextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Start Camera Verification',
                      style: TextStyle(fontSize: 16)),
                )
              ],
            ),
          ),
          // Selfie
          _buildCameraOverlay(
            'Liveness Check',
            'Please align your face perfectly inside the circle.',
            true,
          ),
          // CNIC Front
          _buildCameraOverlay(
            'CNIC Front',
            'Align the front of your ID card within the frame bounds.',
            false,
          ),
          // CNIC Back
          _buildCameraOverlay(
            'CNIC Back',
            'Turn the card over and explicitly capture the machine readable barcode.',
            false,
          ),
        ],
      ),
    );
  }
}
