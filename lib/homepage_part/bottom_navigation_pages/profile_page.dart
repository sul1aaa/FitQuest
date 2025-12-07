import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/homepage_part/main_menu_pages/edit_profile_page.dart';
import 'package:fitness_app_project/homepage_part/widgets/about_app_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final name = currentUser.displayName ?? "User"; 
    final email = currentUser.email ?? "";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.jetBrainsMono(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.pink.shade200],
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatarImg.png',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: GoogleFonts.jetBrainsMono(
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: GoogleFonts.jetBrainsMono(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Account",
              style: GoogleFonts.jetBrainsMono(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _ProfileTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () async{
                await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => EditProfilePage(user: currentUser),)
                );
              },
            ),
            _ProfileTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {},
            ),

            const SizedBox(height: 25),

            Text(
              "Settings",
              style: GoogleFonts.jetBrainsMono(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _ProfileTile(
              icon: Icons.info_outline,
              title: "About App",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AboutAppPage())
                );
              },
            ),
            _ProfileTile(
              icon: Icons.logout_rounded,
              title: 'Log Out',
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/first_screen',
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log out: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
