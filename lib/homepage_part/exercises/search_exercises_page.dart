import 'package:flutter/material.dart';
import 'package:fitness_app_project/homepage_part/services/exercise_api_service.dart';
import 'package:fitness_app_project/homepage_part/services/models/exercise.dart';
import 'package:fitness_app_project/homepage_part/exercises/exercise_details_page.dart';
import 'package:fitness_app_project/homepage_part/widgets/exercise_box.dart';

class SearchExercisesPage extends StatefulWidget {
  const SearchExercisesPage({super.key});

  @override
  State<SearchExercisesPage> createState() => _SearchExercisesPageState();
}

class _SearchExercisesPageState extends State<SearchExercisesPage> {
  final ExerciseApiService _api = ExerciseApiService();

  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final data = await _api.getAllMuscleExercises();
    final List<Exercise> list = data.values.expand((e) => e).toList();

    setState(() {
      _allExercises = list;
      _filteredExercises = list;
      _loading = false;
    });
  }

  void _search(String query) {
    final q = query.toLowerCase();

    setState(() {
      _filteredExercises = _allExercises.where((ex) {
        return ex.name.toLowerCase().contains(q) ||
               ex.muscle.toLowerCase().contains(q) ||
               ex.difficulty.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Exercises"),
        backgroundColor: Colors.pinkAccent,
      ),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: "Search by name, muscle, difficulty...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: _filteredExercises.isEmpty
                      ? Center(child: Text("Nothing found"))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredExercises.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, i) {
                            final ex = _filteredExercises[i];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ExerciseDetailsPage(exercise: ex),
                                  ),
                                );
                              },
                              child: ExerciseBox(ex: ex),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
