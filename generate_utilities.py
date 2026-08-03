import os
import re

utilities_dir = r"c:\Projects\digikhata_clone\lib\features\utilities\presentation\screens"
os.makedirs(utilities_dir, exist_ok=True)

screens = {
    'calculator_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  
  void _onPress(String text) {
    setState(() {
      if (_display == '0') {
        _display = text;
      } else {
        _display += text;
      }
    });
  }

  void _clear() => setState(() => _display = '0');
  void _calculate() => setState(() => _display = 'Error: Parsing Engine Needed');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              color: Colors.grey.shade100,
              child: Text(_display, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  for (var btn in ['7','8','9','/','4','5','6','*','1','2','3','-','C','0','=','+'])
                    InkWell(
                      onTap: () {
                         if (btn == 'C') _clear();
                         else if (btn == '=') _calculate();
                         else _onPress(btn);
                      },
                      child: Center(
                        child: Text(btn, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: btn == '=' || btn == 'C' ? AppTheme.primaryBlue : Colors.black87)),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
""",
    'business_card_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class BusinessCardScreen extends StatelessWidget {
  const BusinessCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Card'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0,5))]
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text('My Business Name', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('+92 300 1234567 | business@digikhata.pk', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
""",
    'recycle_bin_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycle Bin'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.delete_outline, size: 80, color: Colors.grey.shade400),
             const SizedBox(height: 16),
             const Text('Recycle Bin is Empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
           ],
         ),
      ),
    );
  }
}
""",
    'tasdeeq_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class TasdeeqScreen extends StatelessWidget {
  const TasdeeqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasdeeq Verification'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.verified_user, size: 64, color: AppTheme.successGreen),
            const SizedBox(height: 16),
            const Text('Verify your customers reliably using Tasdeeq.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 32),
            TextField(
               decoration: InputDecoration(
                  labelText: 'Enter CNIC',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
               ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
               onPressed: () {},
               style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
               child: const Text('Verify Now'),
            )
          ],
        ),
      ),
    );
  }
}
""",
    'multi_devices_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class MultiDevicesScreen extends StatelessWidget {
  const MultiDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Devices'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 100, color: Colors.black87),
            const SizedBox(height: 16),
            const Text('Scan to login on Web', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text('Go to web.digikhata.pk on your Desktop.', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
""",
    'distributor_screen.dart': """import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class DistributorScreen extends StatelessWidget {
  const DistributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Distributor'), backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            const Text('Join the DigiKhata Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            const Text('Become a distributor and earn commissions on POS hardware and premium subscriptions in your area.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton(
               onPressed: () {},
               style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryOrange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
               child: const Text('Contact Sales Team'),
            )
          ],
        ),
      ),
    );
  }
}
"""
}

for name, content in screens.items():
    with open(os.path.join(utilities_dir, name), 'w', encoding='utf-8') as f:
        f.write(content)

# Update App Router
router_path = r"c:\Projects\digikhata_clone\lib\core\router\app_router.dart"
with open(router_path, 'r', encoding='utf-8') as f:
    router_content = f.read()

imports = """
import '../../features/utilities/presentation/screens/calculator_screen.dart';
import '../../features/utilities/presentation/screens/business_card_screen.dart';
import '../../features/utilities/presentation/screens/tasdeeq_screen.dart';
import '../../features/utilities/presentation/screens/recycle_bin_screen.dart';
import '../../features/utilities/presentation/screens/multi_devices_screen.dart';
import '../../features/utilities/presentation/screens/distributor_screen.dart';
"""

routes = """
      GoRoute(path: '/calculator', builder: (context, state) => const CalculatorScreen()),
      GoRoute(path: '/business_card', builder: (context, state) => const BusinessCardScreen()),
      GoRoute(path: '/tasdeeq', builder: (context, state) => const TasdeeqScreen()),
      GoRoute(path: '/recycle_bin', builder: (context, state) => const RecycleBinScreen()),
      GoRoute(path: '/multi_devices', builder: (context, state) => const MultiDevicesScreen()),
      GoRoute(path: '/distributor', builder: (context, state) => const DistributorScreen()),
"""

if 'CalculatorScreen' not in router_content:
    router_content = router_content.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';" + imports)
    router_content = router_content.replace("initialLocation: '/splash',", "initialLocation: '/splash',\n    routes: [\n" + routes)
    # The find/replace for routes might be tricky. Let's do it via regex insertion into the routes array.
    routes_pattern = re.compile(r'(routes:\s*\[)')
    router_content = routes_pattern.sub(r'\\1' + routes, router_content)
    
    with open(router_path, 'w', encoding='utf-8') as f:
        f.write(router_content)

print("Generated Utilities & Updated Router")

# Now update HomeGridScreen
grid_path = r"c:\Projects\digikhata_clone\lib\features\ledger\presentation\screens\home_grid_screen.dart"
with open(grid_path, 'r', encoding='utf-8') as f:
    grid_content = f.read()

grid_content = grid_content.replace("_buildGridItem(Icons.devices, 'Multi Devices', () {})", "_buildGridItem(Icons.devices, 'Multi Devices', () => context.push('/multi_devices'))")
grid_content = grid_content.replace("_buildGridItem(Icons.badge_outlined, 'Business Card', () {})", "_buildGridItem(Icons.badge_outlined, 'Business Card', () => context.push('/business_card'))")
grid_content = grid_content.replace("_buildGridItem(Icons.calculate, 'Calculator', () {})", "_buildGridItem(Icons.calculate, 'Calculator', () => context.push('/calculator'))")
grid_content = grid_content.replace("_buildGridItem(Icons.verified_user, 'Tasdeeq', () {})", "_buildGridItem(Icons.verified_user, 'Tasdeeq', () => context.push('/tasdeeq'))")
grid_content = grid_content.replace("_buildGridItem(Icons.delete, 'Recycle Bin', () {})", "_buildGridItem(Icons.delete, 'Recycle Bin', () => context.push('/recycle_bin'))")
grid_content = grid_content.replace("_buildGridItem(Icons.local_shipping, 'Distributor', () {})", "_buildGridItem(Icons.local_shipping, 'Distributor', () => context.push('/distributor'))")
grid_content = grid_content.replace("_buildGridItem(Icons.receipt_long, 'Bills', () => context.push('/bill_book'))", "_buildGridItem(Icons.receipt_long, 'Bills', () => context.push('/bill_book'))")

with open(grid_path, 'w', encoding='utf-8') as f:
    f.write(grid_content)

print("Updated HomeGridScreen")
