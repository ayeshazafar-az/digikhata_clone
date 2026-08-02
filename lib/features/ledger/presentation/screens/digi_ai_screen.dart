import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DigiAiScreen extends ConsumerStatefulWidget {
  const DigiAiScreen({super.key});

  @override
  ConsumerState<DigiAiScreen> createState() => _DigiAiScreenState();
}

class _DigiAiScreenState extends ConsumerState<DigiAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();

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

  void _sendMessage(String text) {
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

    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text':
                "I am Digi-AI Beta! I am currently analyzing your Khata ledgers to assist with that request, please check back soon.",
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
      backgroundColor: const Color(0xFF121212), // Deep AppBackground Dark
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
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
              Icon(Icons.auto_awesome, color: Colors.deepOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Digi-AI Beta v1.0',
                style: TextStyle(
                  color: Colors.deepOrange,
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
            icon: const Icon(Icons.history, color: Colors.white70),
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
          backgroundColor: Colors.deepOrange,
          radius: 16,
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Dark bubble color
              borderRadius:
                  BorderRadius.circular(16).copyWith(topLeft: Radius.zero),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
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
                      const Icon(Icons.volume_up,
                          color: Colors.deepOrange, size: 16),
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
              color: Colors.deepOrange.withValues(alpha: 0.15),
              border:
                  Border.all(color: Colors.deepOrange.withValues(alpha: 0.5)),
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
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white70, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white70),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                onSubmitted: _sendMessage,
                decoration: InputDecoration(
                  hintText: 'Ask Digi-AI anything...',
                  hintStyle: const TextStyle(
                      color: Colors.white54, fontStyle: FontStyle.italic),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepOrange),
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
