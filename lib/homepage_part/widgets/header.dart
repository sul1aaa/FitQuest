import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/homepage_part/exercises/search_exercises_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  const CustomAppBar({super.key, required this.user});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  String get userName {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!.split(" ").first;
    }

    if (user.email != null && user.email!.contains('@')) {
      return user.email!.split('@').first;
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/avatarImg.png'),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Hello,',
                      style: GoogleFonts.jetBrainsMono(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      userName,
                      style: GoogleFonts.jetBrainsMono(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchExercisesPage(),
                  ),
                );
              }, 
              icon: Icon(Icons.search)
            )
          ],
        ),
      ),
    );
  }
}
