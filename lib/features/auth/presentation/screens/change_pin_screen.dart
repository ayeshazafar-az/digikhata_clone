import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Change Login PIN',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.vpn_key_rounded,
                      color: Colors.grey, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Jab bhi ap ya ap ki koi dosri device DigiKhata me login krte hn toh ap ye PIN istemal karein ge',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildPinField('Old PIN', _obscureOld,
                  (val) => setState(() => _obscureOld = val)),
              const SizedBox(height: 16),
              _buildPinField('New PIN', _obscureNew,
                  (val) => setState(() => _obscureNew = val)),
              const SizedBox(height: 16),
              _buildPinField('Confirm New PIN', _obscureConfirm,
                  (val) => setState(() => _obscureConfirm = val)),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'FORGOT PIN?',
                    style: TextStyle(
                      color: Color(0xFFE94326),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinField(
      String label, bool isObscure, Function(bool) onObscureToggle) {
    return TextField(
      obscureText: isObscure,
      keyboardType: TextInputType.number,
      maxLength: 4,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: label == 'Old PIN'
                ? const Color(0xFFE94326)
                : Colors.grey.shade600,
            fontWeight: FontWeight.w500),
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
          onPressed: () => onObscureToggle(!isObscure),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: label == 'Old PIN'
                  ? const Color(0xFFE94326)
                  : Colors.grey.shade300,
              width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE94326), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
