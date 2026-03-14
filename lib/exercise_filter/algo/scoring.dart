class ExerciseScoring {
  static String normalize(String s) {
    return s.toLowerCase().replaceAll(" ", "_").trim();
  }

  static List<Map<String, dynamic>> scoreAndRank({
    required List<Map<String, dynamic>> safeExercises,
    required List<String> userGoals,
    required String userDifficulty,
    required String userIntensity,
  }) {
    final normal = userGoals.map((e) => normalize(e)).toSet();

    List<Map<String, dynamic>> scored = safeExercises.map((exercise) {
      int score = 0;
      final exerciseGoals = List<String>.from(exercise["goal_tags"] ?? []);
      final hasGoalMatch = exerciseGoals.any(
        (g) => normal.contains(normalize(g)),
      );
      if (hasGoalMatch) score += 3;
      if (normalize(exercise["difficulty"] ?? "") ==
          normalize(userDifficulty)) {
        score += 2;
      }
      if (normalize(exercise["intensity"] ?? "") == normalize(userIntensity)) {
        score += 1;
      }
      return {...exercise, "score": score};
    }).toList();
    scored.sort((a, b) => (b["score"] as int).compareTo(a["score"] as int));
    return scored;
  }
}
