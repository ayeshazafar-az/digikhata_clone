import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../app/theme.dart';

class DigiAiScreen extends ConsumerStatefulWidget {
  const DigiAiScreen({super.key});

  @override
  ConsumerState<DigiAiScreen> createState() => _DigiAiScreenState();
}

class _DigiAiScreenState extends ConsumerState<DigiAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Supabase.instance.client.auth.currentUser;
      final identity = user?.phone ?? 'User';

      setState(() {
        _messages.add({
          'text': "Welcome, $identity!\nHow can I help you today?",
          'time': TimeOfDay.now().format(context),
          'sender': 'ai',
        });
      });
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'time': TimeOfDay.now().format(context),
        'sender': 'user',
      });
    });

    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        String responseText =
            "I'm currently scanning your Khata algorithms to provide a precise response.";

        final lower = text.toLowerCase();

        if (lower.contains('kyc') ||
            lower.contains('verify') ||
            lower.contains('cnic') ||
            lower.contains('id ')) {
          responseText =
              "Your KYC status is currently PENDING. A Super Admin must approve your submitted CNIC documents before full premium access is granted.";
        } else if (lower.contains('mid') ||
            lower.contains('pos') ||
            lower.contains('point of sale')) {
          responseText =
              "Your Merchant ID (MID) for POS transactions is Active! You can now accept credit card payments using the POS hardware sync on your Home Dashboard.";
        } else if (lower.contains('profit') ||
            lower.contains('stock') ||
            lower.contains('margin') ||
            lower.contains('earn')) {
          responseText =
              "I'm scanning your metrics... Based on your Stock Book margins and today's Cash entries, your estimated net profit stands exactly at Rs 4,500!";
        } else if (lower.contains('cash') ||
            lower.contains('hand') ||
            lower.contains('drawer')) {
          responseText =
              "Your Cashbook is currently secure. You reported Rs 20,000 cash-in-hand this morning, and processed Rs 1,400 in generalized out-flow thus far today.";
        } else if (lower.contains('staff') ||
            lower.contains('attendance') ||
            lower.contains('salary') ||
            lower.contains('pay')) {
          responseText =
              "Staff module engaged. Today's attendance marks 4 employees present and 1 absent. The estimated monthly payroll overhead is Rs 120,500 based on standard metrics.";
        } else if (lower.contains('bill') ||
            lower.contains('invoice') ||
            lower.contains('pdf')) {
          responseText =
              "You have generated 12 PDF invoices today through the Billbook engine. All invoices have been successfully cached and synced offline to the Isar DB.";
        } else if (lower.contains('party') ||
            lower.contains('customer') ||
            lower.contains('supplier') ||
            lower.contains('get') ||
            lower.contains('give')) {
          responseText =
              "You currently have 5 Active Customer Ledgers and 2 Supplier Ledgers mapped. Overall 'You Will Get' accounts receivable sum up to Rs 15,250.";
        } else if (lower.contains('expense') ||
            lower.contains('cost') ||
            lower.contains('rent')) {
          responseText =
              "Your Expense tracker indicates Rs 8,500 in miscellaneous outflow this week. The heaviest categorization impact stems from 'Transport' and 'Utilities'.";
        } else if (lower.contains('hello') ||
            lower.contains('hi') ||
            lower.contains('hey') ||
            lower.startsWith('hel')) {
          responseText =
              "Hello there! I'm Digi-AI, your algorithmic FinTech assistant. Feel free to ask me about your Khata balances, Stock inventory, or Staff payroll!";
        } else if (lower.contains('who are you') ||
            lower.contains('what are you')) {
          responseText =
              "I am Digi-AI Beta, a custom-built artificial intelligence tailored specifically for the DigiKhata ecosystem to manage your financial data effortlessly.";
        } else if (lower.contains('thanks') || lower.contains('thank you')) {
          responseText =
              "You're very welcome! If you need anything else regarding your Khatas, just ask.";
        } else if (lower.contains('help')) {
          responseText =
              "I can help you review your KYC status, analyze your Stock profit margins, summarize your Cashbook, or track Staff attendance grids. What do you need?";
        } else {
          if (text.length <= 6) {
            responseText =
                "I didn't quite catch that! Could you ask me about your Khata, Stock, or KYC status?";
          } else {
            final words = text.split(' ').take(3).join(' ');
            responseText =
                "I am actively analyzing your internal ledger structure regarding '$words...'. As a Beta model, my algorithms are still learning to process complex variables!";
          }
        }

        setState(() {
          _messages.add({
            'text': responseText,
            'time': TimeOfDay.now().format(context),
            'sender': 'ai',
          });
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black87,
          onPressed: () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: AppTheme.primaryBlue, size: 20),
              SizedBox(width: 8),
              Text(
                'Digi-AI Beta v1.0',
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['sender'] == 'ai') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildAiMessage(msg['text']!, msg['time']!),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildUserMessage(msg['text']!, msg['time']!),
                  );
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSuggestionChip("What's my KYC status?"),
                  const SizedBox(width: 8),
                  _buildSuggestionChip("What's my MID/POS status?"),
                  const SizedBox(width: 8),
                  _buildSuggestionChip("Show me today's profit."),
                ],
              ),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildAiMessage(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: AppTheme.primaryBlue,
          radius: 16,
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16).copyWith(topLeft: Radius.zero),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(time,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 10)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          await flutterTts.speak(text);
                        },
                        child: const Icon(Icons.volume_up,
                            color: AppTheme.primaryBlue, size: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Spacer(flex: 1), // Constrains width
      ],
    );
  }

  Widget _buildUserMessage(String text, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(flex: 1),
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.15),
              border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.5)),
              borderRadius:
                  BorderRadius.circular(16).copyWith(topRight: Radius.zero),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(time,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return InkWell(
      onTap: () => _sendMessage(text),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border:
              Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: AppTheme.primaryBlue, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primaryBlue),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.black87),
                onSubmitted: _sendMessage,
                decoration: InputDecoration(
                  hintText: 'Ask Digi-AI anything...',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.primaryBlue),
                    onPressed: () {
                      _sendMessage(_controller.text);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
