import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/onnx_service.dart';
import '../exercise_filter/main_exercise.dart';
import './main_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late OnnxService onnx;
  bool modelLoaded = false;
  List<Map<String, dynamic>> sessionExercises = [];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    print("Step 1: Creating ONNX service");
    onnx = OnnxService();

    print("Step 2: Starting model initialization");

    await onnx.init();

    print("Step 3: Model loaded successfully");
    final exercises = await MainExercise.getSessionExercises();
    setState(() {
      modelLoaded = true;
      sessionExercises = exercises;
    });
    print("Step 4: UI state updated, modelLoaded = true");
  }

  @override
  Widget build(BuildContext context) {
    if (!modelLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    print("Model ready -> rendering Home UI");
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hey Champ ", style: textTheme.headlineMedium),
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
              ],
            ),

            const SizedBox(height: 24),

            _buildWeekCalendar(textTheme),

            const SizedBox(height: 28),

            Text("Your 4 exercises of today", style: textTheme.titleMedium),

            const SizedBox(height: 16),

            ...sessionExercises
                .map((exercise) => _exerciseCard(textTheme, exercise))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(TextTheme textTheme) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isSelected = index == 6;

        return Column(
          children: [
            Text(days[index], style: textTheme.labelMedium),

            const SizedBox(height: 6),

            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.card,
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _exerciseCard(TextTheme textTheme, Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),

      child: Row(
        children: [
          const Icon(Icons.fitness_center, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise["name"], style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  "${exercise["estimated_duration"]} • ${exercise["body_region"]}",
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),

          SizedBox(
            width: 90,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainexerciseScreen(exercises: sessionExercises),
                  ),
                );
              },
              child: const Text("Start"),
            ),
          ),
        ],
      ),
    );
  }
}
