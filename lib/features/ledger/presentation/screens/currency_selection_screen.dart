import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  final List<Map<String, String>> _currencies = [
    {'name': 'Pakistan Rupee', 'flag': '🇵🇰'},
    {'name': 'Afghanistan Afghani', 'flag': '🇦🇫'},
    {'name': 'Argentine Peso', 'flag': '🇦🇷'},
    {'name': 'Australian Dollar', 'flag': '🇦🇺'},
    {'name': 'Bahraini Dinar', 'flag': '🇧🇭'},
    {'name': 'Bangladeshi Taka', 'flag': '🇧🇩'},
    {'name': 'Barbados Dollar', 'flag': '🇧🇧'},
    {'name': 'Belize Dollar', 'flag': '🇧🇿'},
    {'name': 'Bhutanese Ngultrum', 'flag': '🇧🇹'},
    {'name': 'Bolivia Boliviano', 'flag': '🇧🇴'},
    {'name': 'Brazil Real', 'flag': '🇧🇷'},
    {'name': 'British Pound', 'flag': '🇬🇧'},
    {'name': 'Brunei Darussalam Dollar', 'flag': '🇧🇳'},
    {'name': 'Bulgarian Lev', 'flag': '🇧🇬'},
    {'name': 'Canada Dollar', 'flag': '🇨🇦'},
  ];

  List<Map<String, String>> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = _currencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      _filteredCurrencies = _currencies
          .where((currency) =>
              currency['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF3752A), Color(0xFFE94326)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE94326),
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: _filterCurrencies,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCurrencies.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Text(
                    currency['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    currency['name']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    context.pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
