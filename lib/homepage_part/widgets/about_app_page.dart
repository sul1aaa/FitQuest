import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  final String overview =
      "Our fitness app is a comprehensive platform designed to help users achieve their health and fitness goals through personalized guidance, community support, and interactive features. It combines AI-assisted recommendations, detailed exercise information, and goal tracking to create a fully immersive fitness experience.";

  final List<String> features = [
    "AI Assistant:\n- Provides personalized workout suggestions based on user goals, fitness level, and body characteristics.\n- Tracks progress and adjusts recommendations dynamically.\n- Answers fitness-related questions and guides users through exercises.",
    "Community Chat:\n- Enables users to interact, share achievements, ask questions, and motivate each other.\n- Supports group and individual chats for different interests or fitness challenges.",
    "Exercise Library:\n- Contains a wide range of exercises with detailed descriptions, step-by-step instructions, and video demonstrations (linked to YouTube).\n- Users can mark exercises as completed, add to favorites, or assign to goals.\n- Filters and categories make it easy to find exercises for strength, cardio, flexibility, or weight loss.",
    "Goal Management:\n- Users can set fitness goals (e.g., weight loss, muscle gain, endurance improvement).\n- Exercises and plans can be linked to these goals for easy tracking.\n- Progress is visualized, allowing users to see achievements and areas needing improvement.",
    "Body Profile & Analytics:\n- Users can input body characteristics (weight, height, measurements, etc.).\n- The app tracks changes over time and offers insights for better results.\n- Personalized recommendations for nutrition, exercise intensity, and recovery.",
    "User Experience Enhancements:\n- Bookmark favorite exercises for quick access.\n- Track completed exercises and visualize workout streaks.\n- Integrate video tutorials seamlessly to enhance learning and engagement.",
  ];

  final List<String> benefits = [
    "Personalized fitness guidance without needing a personal trainer.",
    "Motivating community support.",
    "Clear progress tracking to achieve goals efficiently.",
    "Easy access to high-quality exercise videos and instructions.",
  ];

  AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness App Description'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overview",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(overview, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text("Key Features",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text("• $feature", style: TextStyle(fontSize: 16)),
                  )),
              SizedBox(height: 16),
              Text("Benefits",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text("• $benefit", style: TextStyle(fontSize: 16)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}