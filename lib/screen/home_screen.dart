import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hey Champ 👋", style: textTheme.headlineMedium),
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
              ],
            ),

            const SizedBox(height: 24),
            _buildWeekCalendar(textTheme),
            const SizedBox(height: 28),
            Text(
              "Your 4 exercises of today by AI",
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) => _exerciseCard(textTheme)),
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

  Widget _exerciseCard(TextTheme textTheme) {
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
                Text("Jumping Jacks", style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text("30 sec • Cardio", style: textTheme.bodySmall),
              ],
            ),
          ),

          SizedBox(
            width: 90,
            child: ElevatedButton(onPressed: () {}, child: const Text("Start")),
          ),
        ],
      ),
    );
  }
}
