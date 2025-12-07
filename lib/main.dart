import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app_project/firebase_options.dart';
import 'package:fitness_app_project/onboarding_part/pages/journey_start_page.dart';
import 'package:fitness_app_project/registration_part/pages/first_screen_page.dart';
import 'package:fitness_app_project/registration_part/pages/login_page.dart';
import 'package:fitness_app_project/registration_part/pages/sign_up_page.dart';
import 'package:fitness_app_project/registration_part/pages/verify_email_page.dart';
import 'package:fitness_app_project/registration_part/services/firebase_stream.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/first_screen': (context) => const FirstScreenPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/verify_email': (context) => const VerifyEmailScreen(),
        '/journey_start': (context) => const JourneyStartPage(),
      },
      initialRoute: '/',
    );
  }
}
