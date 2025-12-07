import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/onboarding_part/pages/journey_start_page.dart';
import 'package:fitness_app_project/registration_part/pages/first_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _initVerification();
  }

  Future<void> _initVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    isEmailVerified = user.emailVerified;

    if (!isEmailVerified) {
      await sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      timer?.cancel();
      return;
      }

    await user.reload();
    final verified = user.emailVerified;

    if (!mounted) return;

    setState(() => isEmailVerified = verified);

    if (verified) {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => JourneyStartPage(),
        ),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await user.sendEmailVerification();

      if (!mounted) return;
      setState(() => canResendEmail = false);

      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return;
      setState(() => canResendEmail = true);
    } catch (e) {
      logger.e("Error sending email: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to send email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined, size: 100, color: Colors.pinkAccent),
                const SizedBox(height: 24),
                const Text(
                  'A confirmation email has been sent.\nPlease check your mailbox.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (!isEmailVerified) const CircularProgressIndicator(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  child: const Text('Resend email'),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FirstScreenPage(), 
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Go to Main Menu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
