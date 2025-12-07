import 'package:dio/dio.dart';
import 'package:fitness_app_project/homepage_part/services/models/exercise.dart';
import 'package:logger/web.dart';
import 'package:fitness_app_project/homepage_part/services/data/video_map.dart';

class ExerciseApiService {
  static final ExerciseApiService _instance = ExerciseApiService._internal();
  factory ExerciseApiService() => _instance;
  ExerciseApiService._internal();
  final logger = Logger();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/v1',
      headers: {
        'X-Api-Key': 'UqNIY1SmgwmyvUjLl1xK6Q==duNfTCklnJxrv3Ta',
      },
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  final Map<String, List<Exercise>> _cache = {};
  bool _isAllDataCached = false;

  Future<Map<String, List<Exercise>>> getAllMuscleExercises() async {
    if (_isAllDataCached) {
      logger.i("✅ Returning all data from cache");
      return Map.from(_cache);
    }

    const muscles = [
      'abdominals', 'biceps', 'chest', 'forearms',
      'glutes', 'lats', 'lower_back',
      'middle_back', 'neck', 'quadriceps', 'triceps'
    ];

    try {
      logger.i("🚀 Starting parallel fetch for all muscles...");

      final futures = muscles.map((muscle) => _fetchSingleMuscle(muscle));

      final results = await Future.wait(futures);

      final Map<String, List<Exercise>> resultMap = {};

      for (var entry in results) {
        if (entry.value.isNotEmpty) {
          resultMap[entry.key] = entry.value;
          _cache[entry.key] = entry.value;
        }
      }

      _isAllDataCached = true;
      logger.i("✅ All muscle data loaded in parallel");
      return resultMap;

    } catch (e) {
      logger.e("Error in getAllMuscleExercises: $e");
      return _cache.isNotEmpty ? Map.from(_cache) : {};
    }
  }

  Future<MapEntry<String, List<Exercise>>> _fetchSingleMuscle(String muscle) async {
    try {
      if (_cache.containsKey(muscle)) {
        return MapEntry(muscle, _cache[muscle]!);
      }

      final response = await _dio.get(
        '/exercises',
        queryParameters: {
          'muscle': muscle,
          'type': 'strength', 
        },
      );

      if (response.statusCode == 200) {
        final List list = response.data;
        
        if (list.isEmpty) {
          logger.w("No exercises returned for $muscle");
          return MapEntry(muscle, <Exercise>[]);
        }

        final exercises = list.map((e) {
          String name = e['name'] ?? 'Unknown';
          String video = exerciseVideosMap[name] ?? '';
          
          Map<String, dynamic> exerciseData = Map<String, dynamic>.from(e);
          exerciseData['videoUrl'] = video;

          return Exercise.fromJson(exerciseData);
        }).toList();

        return MapEntry(muscle, exercises);
      }
      
      logger.w("Non-200 response for $muscle: ${response.statusCode}");
      return MapEntry(muscle, <Exercise>[]);
      
    } on DioException catch (e) {
      logger.e("Error fetching $muscle: ${e.message}");
      
      if (e.response != null) {
        logger.e("Status Code: ${e.response?.statusCode}");
        logger.e("Response data: ${e.response?.data}");
        logger.e("Request URL: ${e.requestOptions.uri}");
      }
      
      // If API is down, we could return mock data here
      return MapEntry(muscle, <Exercise>[]);
      
    } catch (e) {
      logger.e("Unexpected error fetching $muscle: $e");
      return MapEntry(muscle, <Exercise>[]);
    }
  }

  // Method to get more exercises using offset (requires premium)
  Future<List<Exercise>> fetchMoreExercises(String muscle, int offset) async {
    try {
      final response = await _dio.get(
        '/exercises',
        queryParameters: {
          'muscle': muscle,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final List list = response.data;
        return list.map((e) {
          String name = e['name'];
          String video = exerciseVideosMap[name] ?? '';
          
          Map<String, dynamic> exerciseData = Map<String, dynamic>.from(e);
          exerciseData['videoUrl'] = video;
          
          return Exercise.fromJson(exerciseData);
        }).toList();
      }
      
      return [];
    } catch (e) {
      logger.e("Error fetching more exercises: $e");
      return [];
    }
  }

  void clearCache() {
    _cache.clear();
    _isAllDataCached = false;
    logger.i("Cache cleared");
  }

  Future<List<Exercise>> getExercises({required String muscle}) async {
    try {
      final response = await _dio.get('/exercises', queryParameters: {
        'muscle': muscle,
      });

      final List list = response.data;
      return list.map((e) => Exercise.fromJson(e)).toList();
    } catch (e) {
      logger.e("API error: $e");
      return [];
    }
  }

  Future<List<Exercise>> fetchExercisesByMuscle(String muscle, {int limit = 5}) async {
    try {
      if (_cache.containsKey(muscle)) {
        return _cache[muscle]!;
      }

      final res = await _dio.get(
        '/exercises',
        queryParameters: {
          'muscle': muscle,
        },
      );

      final List raw = res.data;

      final exercises = raw.map((e) {
        String name = e['name'];
        String video = exerciseVideosMap[name] ?? '';
        
        Map<String, dynamic> exerciseData = Map<String, dynamic>.from(e);
        exerciseData['videoUrl'] = video;
        
        return Exercise.fromJson(exerciseData);
      }).toList();

      _cache[muscle] = exercises;
      return exercises;
      
    } catch (e) {
      logger.e("API error: $e");
      return [];
    }
  }
}
