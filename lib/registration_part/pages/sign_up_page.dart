import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/registration_part/pages/login_page.dart';
import 'package:fitness_app_project/registration_part/widgets/quote_header.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app_project/registration_part/widgets/custom_text_field.dart';
import 'package:fitness_app_project/registration_part/widgets/quotes_swipes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late QuotesSwipes _quotesSwipes;
  bool isHiddenPassword = true;
  final logger = Logger();

  @override
  void initState() {
    _quotesSwipes = QuotesSwipes(totalQuotes: 4);
    super.initState();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    UserCredential cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    User? user = cred.user;

    await user?.updateDisplayName(
        "${_fNameController.text.trim()} ${_lNameController.text.trim()}");
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    await user?.sendEmailVerification();

    if (!mounted) return;

    Navigator.pushNamed(
      context,
      '/verify_email',
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    logger.e("FIREBASE ERROR: ${e.code} — ${e.message}");

    String message = 'Something went wrong';
    if (e.code == 'email-already-in-use') {
      message = 'Email is already in use';
    } else if (e.code == 'weak-password') {
      message = 'Password must be at least 6 characters';
    } else if (e.code == 'invalid-email') {
      message = 'Invalid email format';
    } else if (e.code == 'operation-not-allowed') {
      message = 'Email/password sign-in is disabled in Firebase';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.pinkAccent,
            ),
          ),
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Sign up',
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
          
                              Text(
                                "Hello there! Let’s create your account.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.jetBrainsMono(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
          
                              const SizedBox(height: 20),
          
                              CustomTextField(
                                hintText: 'First Name',
                                controller: _fNameController,
                                validator: (v) =>
                                    v!.isEmpty ? "Field cannot be empty" : null,
                              ),
          
                              const SizedBox(height: 12),
          
                              CustomTextField(
                                hintText: 'Last Name',
                                controller: _lNameController,
                                validator: (v) =>
                                    v!.isEmpty ? "Field cannot be empty" : null,
                              ),
          
                              const SizedBox(height: 12),
          
                              CustomTextField(
                                hintText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (email) =>
                                    email != null && !EmailValidator.validate(email)
                                    ? "Input correct email"
                                    : null,
                              ),
          
                              const SizedBox(height: 12),
          
                              CustomTextField(
                                keyboardType: TextInputType.phone,
                                hintText: 'Phone number',
                                controller: _phoneController,
                                validator: (v) =>
                                    v!.isEmpty ? "Phone cannot be empty" : null,
                              ),
          
                              const SizedBox(height: 12),
          
                              CustomTextField(
                                obscure: true,
                                hintText: 'Password',
                                controller: _passwordController,
                                validator: (v) =>
                                    v!.isEmpty ? "Password cannot be empty" : null,
                                isHiddenPassword: isHiddenPassword,
                                togglePasswordView: togglePasswordView,
                              ),
          
                              const SizedBox(height: 20),
          
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'I agree to Terms and Privacy Policy',
                                  style: GoogleFonts.jetBrainsMono(
                                    textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
          
                              const SizedBox(height: 20),
          
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  minimumSize: const Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  signUp();
                                },
                                child: const Text(
                                  "Create account",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
          
                              const SizedBox(height: 10),
          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Joined us before?",
                                    style: GoogleFonts.jetBrainsMono(
                                      textStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.jetBrainsMono(
                                        textStyle: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
