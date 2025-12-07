import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/registration_part/widgets/bottom_elevated_button.dart';
import 'package:fitness_app_project/registration_part/widgets/custom_text_field.dart';
import 'package:fitness_app_project/registration_part/widgets/quote_header.dart';
import 'package:fitness_app_project/registration_part/widgets/quotes_swipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late QuotesSwipes _quotesSwipes;

  @override
  void initState() {
    super.initState();
    _quotesSwipes = QuotesSwipes(totalQuotes: 4);
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Reset link sent to your email",
            style: GoogleFonts.jetBrainsMono(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Error occurred"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.pink[50],
        body: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: QuoteHeader(
                      quotesSwipes: _quotesSwipes,
                      onDotTap: (i) => setState(() => _quotesSwipes.currentIndex = i),
                      onSwipeLeft: () => setState(() => _quotesSwipes.swipeLeft()),
                      onSwipeRight: () => setState(() => _quotesSwipes.swipeRight()),
                    ),
                  ),

                  Expanded(
                    flex: 10,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),

                              Text(
                                "Forgot password?",
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pinkAccent,
                                    fontSize: 24,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              Text(
                                "Don’t worry! It happens.\nEnter the email associated with your account.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              CustomTextField(
                                controller: _emailController,
                                hintText: "Insert email address",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  if (!value.contains("@") || !value.contains(".")) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              BottomElevatedButton(
                                formKey: _formKey,
                                submitButton: resetPassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
