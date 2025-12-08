import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/homepage_part/bottom_navigation_pages/stats_screen.dart';
import 'package:fitness_app_project/onboarding_part/widgets/selectable_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JourneyStep5Page extends StatefulWidget {
  const JourneyStep5Page({super.key});

  @override
  State<JourneyStep5Page> createState() => _JourneyStep5PageState();
}

class _JourneyStep5PageState extends State<JourneyStep5Page> {
  int? selectedIndex;

  final List<String> options = ["No, I don’t have", "Yes, I have"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Step 5",
              style: GoogleFonts.jetBrainsMono(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            Spacer(),
            Icon(Icons.sports_gymnastics_rounded),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(color: Colors.pinkAccent, width: 50, height: 5),
                  Container(color: Colors.pinkAccent, width: 50, height: 5),
                  Container(color: Colors.pinkAccent, width: 50, height: 5),
                  Container(color: Colors.pinkAccent, width: 50, height: 5),
                  Container(color: Colors.pinkAccent, width: 50, height: 5),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Do you have any health problems that can affect your trainings?",
                style: GoogleFonts.jetBrainsMono(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.pinkAccent,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Select what fits best:",
                style: GoogleFonts.jetBrainsMono(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Dynamic options
              ...List.generate(options.length, (index) {
                return SelectableOption(
                  text: options[index],
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() => selectedIndex = index);
                  },
                );
              }),

              const Spacer(),

              /// Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedIndex != null
                      ? () {
                        final user = FirebaseAuth.instance.currentUser;

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  StatsScreen(user: user!),
                              transitionDuration: Duration.zero,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex != null
                        ? Colors.pinkAccent
                        : Colors.pinkAccent.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.jetBrainsMono(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
