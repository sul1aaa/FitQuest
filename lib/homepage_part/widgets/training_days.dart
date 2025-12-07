import 'package:flutter/material.dart';
import 'package:fitness_app_project/homepage_part/exercises/muscle_detail_page.dart';
import 'package:fitness_app_project/homepage_part/services/models/exercise.dart';
import 'package:fitness_app_project/homepage_part/services/exercise_api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingDays extends StatefulWidget {
  const TrainingDays({super.key});

  @override
  State<TrainingDays> createState() => _TrainingDaysState();
}

class _TrainingDaysState extends State<TrainingDays> {
  final List<String> muscles = [
    'abdominals', 'biceps', 'chest', 'forearms',
    'glutes', 'lats', 'lower_back', 'middle_back',
    'neck', 'quadriceps', 'triceps'
  ];

  final muscleImages = {
    "abdominals": "assets/images/abss.png",
    "biceps": "assets/images/bicepss.png",
    "chest": "assets/images/chest.png",
    "forearms": "assets/images/forearms.png",
    "glutes": "assets/images/glutess.png",
    "lats": "assets/images/latss.png",
    "lower_back": "assets/images/lower_backk.png",
    "middle_back": "assets/images/middle_backk.png",
    "neck": "assets/images/neckk.png",
    "quadriceps": "assets/images/quadricepss.png",
    "triceps": "assets/images/triceps.png",
  };

  final ExerciseApiService api = ExerciseApiService();
  Map<String, List<Exercise>> exercisesByMuscle = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final data = await api.getAllMuscleExercises(); 
    if (!mounted) return;
    setState(() {
      exercisesByMuscle = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading && exercisesByMuscle.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: muscles.length,
        itemBuilder: (context, index) {
          final muscle = muscles[index];
          final exercises = exercisesByMuscle[muscle] ?? [];
          if (exercises.isEmpty) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MuscleDetailsPage(
                    muscle: muscle,
                    exercisesCount: exercises.length,
                    level: exercises.first.difficulty,
                    exercises: exercises,
                  ),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: Image.asset(muscleImages[muscle]!),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    muscle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
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
