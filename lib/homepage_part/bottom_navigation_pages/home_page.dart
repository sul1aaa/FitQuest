import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/homepage_part/widgets/community_button.dart';
import 'package:fitness_app_project/homepage_part/widgets/daily_report_button.dart';
import 'package:fitness_app_project/homepage_part/widgets/habits_section.dart';
import 'package:fitness_app_project/homepage_part/widgets/header.dart';
import 'package:fitness_app_project/homepage_part/widgets/training_days.dart';
import 'package:fitness_app_project/homepage_part/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser ?? user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(user: currentUser),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WorkoutCard(),
              SizedBox(height: 30.0),

              Text(
                'What are you training today?',
                style: GoogleFonts.jetBrainsMono(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TrainingDays(),
              SizedBox(height: 30.0),

              Text(
                'Your habits',
                style: GoogleFonts.jetBrainsMono(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              HabitsSection(),
              const SizedBox(height: 30.0),
              CommunityButton(),
              const SizedBox(height: 20),
              DailyReportsButton(),
            ],
          ),
        ),
      ),
    );
  }
}
