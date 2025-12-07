import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app_project/homepage_part/exercises/muscle_detail_page.dart';
import 'package:fitness_app_project/homepage_part/services/exercise_api_service.dart';
import 'package:fitness_app_project/homepage_part/services/models/exercise.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCoursesPage extends StatefulWidget {
  final User user;
  const AllCoursesPage({super.key, required this.user});

  @override
  State<AllCoursesPage> createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  final _api = ExerciseApiService();
  Map<String, List<Exercise>> data = {};
  bool loading = true;

  final muscleImages = {
    "abdominals": "assets/images/abs_training.png",
    "biceps": "assets/images/biceps_training.png",
    "chest": "assets/images/chest_training.png",
    "forearms": "assets/images/forearms_training.png",
    "glutes": "assets/images/glutes_training.png",
    "lats": "assets/images/lats_training.png",
    "lower_back": "assets/images/lower_back_training.png",
    "middle_back": "assets/images/middle_back_training.png",
    "neck": "assets/images/neck_training.png",
    "quadriceps": "assets/images/quad_training.png",
    "triceps": "assets/images/triceps_training.png",
  };

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final result = await _api.getAllMuscleExercises(); 
    if (!mounted) return;
    setState(() {
      data = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading && data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Workouts",
          style: GoogleFonts.jetBrainsMono(
            textStyle: const TextStyle(
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final muscle = data.keys.elementAt(index);
          final exercises = data[muscle] ?? [];
          if (exercises.isEmpty) return const SizedBox.shrink();

          final level = exercises.isNotEmpty ? exercises.first.difficulty : 'N/A';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MuscleDetailsPage(
                    muscle: muscle,
                    exercisesCount: exercises.length,
                    level: level,
                    exercises: exercises,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  width: 2,
                  color: Colors.pinkAccent.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      muscleImages[muscle] ?? "assets/images/abss.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          muscle.replaceAll("_", " ").toUpperCase(),
                          style: GoogleFonts.jetBrainsMono(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${exercises.length} exercises • ${exercises.length * 2} min",
                          style: GoogleFonts.jetBrainsMono(
                            textStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Level: $level",
                          style: GoogleFonts.jetBrainsMono(
                            textStyle: const TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
