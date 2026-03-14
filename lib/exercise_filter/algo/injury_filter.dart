class InjuryFilter {
  static String normalize(String s) {
    return s.toLowerCase().replaceAll(" ", "_").trim();
  }
  static List<Map<String, dynamic>> filterByInjury({
    required List<Map<String, dynamic>> allExercises,
    required List<String> userInjuries,
  }) {
    final normal = userInjuries
        .map((e) => normalize(e))
        .toSet();

    return allExercises.where((exercise) {
      final contraindications = exercise["contraindications"] as List<dynamic>? ?? [];
      final hasConflict = contraindications.any((c) {
        return normal.contains(normalize(c.toString()));
      });

      return !hasConflict;
    }).toList();
  }
}