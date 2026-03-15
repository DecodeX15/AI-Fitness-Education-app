import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './algo/injury_filter.dart';
import './algo//scoring.dart';

class MainExercise {
  static Future<List<Map<String, dynamic>>> getSessionExercises() async {
    final String jsonString = await rootBundle.loadString('assets/exercise_db.json');
    final String cleaned = jsonString.trimLeft();
    final List<dynamic> decoded = json.decode(cleaned);
    final List<Map<String, dynamic>> allExercises = List<Map<String, dynamic>>.from(decoded);
    print("Total exercises: ${allExercises.length}");
    final prefs = await SharedPreferences.getInstance();
    final userInjuries = List<String>.from(prefs.getStringList("injuries") ?? []);
    final userGoals = List<String>.from(prefs.getStringList("goals") ?? []);
    final userDifficulty = prefs.getString("level") ?? "beginner";

    print("User injuries: $userInjuries");
    print("User goals: $userGoals");
    print("User difficulty: $userDifficulty");

    final safeExercises = InjuryFilter.filterByInjury(
      allExercises: allExercises,
      userInjuries: userInjuries,
    );
    print("Safe exercises after injury filter: ${safeExercises.length}");
    final rankedExercises = ExerciseScoring.scoreAndRank(
      safeExercises: safeExercises,
      userGoals: userGoals,
      userDifficulty: userDifficulty,
      userIntensity: "moderate",
    );
    for (var ex in rankedExercises) {
      print("////////ranked exercises ${ex['name']} → score: ${ex['score']}");
    }
    final sessionExercises = rankedExercises.take(4).toList();
    print("Session exercises: ${sessionExercises.length}");
    for (var ex in sessionExercises) {
      print("////////${ex['name']} → score: ${ex['score']}");
    }
    return sessionExercises;
  }
}