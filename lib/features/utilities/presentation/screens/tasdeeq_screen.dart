import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TasdeeqScreen extends StatelessWidget {
  const TasdeeqScreen({super.key});

  Future<void> _launchPlayStore() async {
    final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.apl.tasdeeq');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch play store');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Tasdeeq - Apne credit scores hasil karein',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dummy Banner Image Placeholder (Blue Theme)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                    'TASDEEQ\nPAKISTAN\'S 1ST STATE BANK\nLICENSED CREDIT BUREAU',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('About TASDEEQ',
                        style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Tasdeeq, Pakistan ka pehla State Bank se licensed credit bureau, mo'tabar credit maloomat aur analytics faraham karta hai taake mali idaron aur afrad ko empower kiya ja sake.",
                    style: TextStyle(
                        color: Colors.black54, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text('Services for Individuals',
                      style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      '• Credit reports\n• Credit scores (darkhwast par)',
                      style: TextStyle(
                          color: Colors.black54, fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text('Why?',
                      style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      "• Qarza aur credit card ki eligibility behtar karein\n• Apni financial standing hamesha jaanen\n• Banks aur financial institutions ka mo'tabar partner",
                      style: TextStyle(
                          color: Colors.black54, fontSize: 16, height: 1.5)),
                  const SizedBox(height: 16),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _launchPlayStore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            child: const Text('APNE CREDIT SCORES HASIL KAREIN',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
