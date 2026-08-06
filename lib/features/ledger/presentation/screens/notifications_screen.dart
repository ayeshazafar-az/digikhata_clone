import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBlue,
          // Re-enforcing the blue theme specifically requested over the original orange gradients
          title: const Text('Notifications',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Entry'),
              Tab(text: 'Others'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NotificationEmptyState(
              title: 'Entry Notifications',
              description:
                  "Here you'll see the entries made by your customers & suppliers in DigiKhata.",
            ),
            _NotificationEmptyState(
              title: 'Notifications',
              description:
                  "Here you'll see all the news and updates from DigiKhata",
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const _NotificationEmptyState({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // White header card containing the text overview
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(description,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Tiny illustration replica
              Expanded(
                flex: 1,
                child: _buildPhoneIllustration(size: 60),
              )
            ],
          ),
        ),

        Expanded(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPhoneIllustration(size: 120),
                  const SizedBox(height: 24),
                  const Text('No notifications found!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14, height: 1.5),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Composed widget simulating the phone & bell illustration
  Widget _buildPhoneIllustration({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background generic splash color matching blue theme integration (or teal as in screenshot, but sticking to branding)
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: const BoxDecoration(
              color: Colors
                  .tealAccent, // The screenshot uses a teal/greenish backdrop drop
              shape: BoxShape.circle,
            ),
          ),
          // Phone Body
          Container(
            width: size * 0.45,
            height: size * 0.8,
            decoration: BoxDecoration(
              color: AppTheme
                  .primaryBlue, // Primary phone color (screenshot uses a blue/purple hue)
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Phone Screen lines
          Positioned(
            bottom: size * 0.25,
            child: Container(
              width: size * 0.35,
              height: size * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            bottom: size * 0.12,
            child: Container(
              width: size * 0.35,
              height: size * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Bell Icon
          Positioned(
            top: size * 0.15,
            child: Icon(Icons.notifications,
                color: Colors.amber, size: size * 0.35),
          ),
          // Mock hand wrapping
          Positioned(
            right: size * 0.15,
            bottom: size * 0.05,
            child: Container(
              width: size * 0.25,
              height: size * 0.55,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCCAA), // Hand skin tone
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(30)),
              ),
            ),
          ),
          // Thumbs wrapping over
          Positioned(
            left: size * 0.2,
            top: size * 0.45,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFCCAA), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: size * 0.2,
            top: size * 0.6,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFCCAA), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
