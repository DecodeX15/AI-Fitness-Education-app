import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screen/onboarding/welcome_screen.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  print("User data debug ");
  print("All keys: ${prefs.getKeys()}");
  print("goals: ${prefs.getStringList("goals")}");
  print("custom_goal: ${prefs.getString("custom_goal")}");
  print("motivation: ${prefs.getStringList("motivation")}");
  print("custom_motivation: ${prefs.getString("custom_motivation")}");
  print("level: ${prefs.getString("level")}");
  print("custom_injury: ${prefs.getString("custom_injury")}");

  bool isOnboarded =
      prefs.containsKey("goals") &&
      prefs.containsKey("time") &&
      prefs.containsKey("motivation") &&
      prefs.containsKey("injury") &&
      prefs.containsKey("level");

  print("Is onboarded: $isOnboarded");
  runApp(MyApp(isOnboarded));
}

class MyApp extends StatelessWidget {
  final bool isOnboarded;

  const MyApp(this.isOnboarded, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Fitness',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: isOnboarded ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
