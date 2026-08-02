import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  String? selfiePath;
  String? cnicFrontPath;
  String? cnicBackPath;

  bool _isInitCamera = false;
  bool _mockErrorThrown = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Setup front camera for selfie first
      final frontCamera = _cameras!.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first);
      _setupCamera(frontCamera);
    }
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController!.initialize();
    if (mounted) setState(() => _isInitCamera = true);
  }

  void _nextPage() {
    if (_currentIndex < 3) {
      if (_currentIndex == 1) {
        // Switching to CNIC front, change to Back camera
        final backCamera = _cameras!.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras!.first);
        _setupCamera(backCamera);
      }
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentIndex++);
    } else {
      _submitKyc();
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    
    try {
      final XFile image = await _cameraController!.takePicture();
      
      if (_currentIndex == 1) {
        selfiePath = image.path;
        _nextPage();
      } else if (_currentIndex == 2) {
        cnicFrontPath = image.path;
        _nextPage();
      } else if (_currentIndex == 3) {
        if (!_mockErrorThrown) {
           // Simulate the OCR error!
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Verification Failed: NADRA Barcode unreadable on the back. Please strictly align your CNIC within the box and retake!'),
               backgroundColor: AppTheme.dangerRed,
               duration: Duration(seconds: 4),
             )
           );
           setState(() => _mockErrorThrown = true);
           return;
        }
        cnicBackPath = image.path;
        _submitKyc();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
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
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildCameraOverlay(String title, String instruction, bool isSquare) {
    if (!_isInitCamera || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        SizedBox.expand(
          child: CameraPreview(_cameraController!),
        ),
        // Dark Overlay with Cutout
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: isSquare ? 300 : 320,
                  height: isSquare ? 300 : 200,
                  decoration: BoxDecoration(
                    color: Colors.red, // Cutout shape
                    borderRadius: BorderRadius.circular(isSquare ? 150 : 16),
                  ),
                ),
              ),
            ],
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
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _businessController,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: const Text('Start Camera Verification', style: TextStyle(fontSize: 16)),
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
