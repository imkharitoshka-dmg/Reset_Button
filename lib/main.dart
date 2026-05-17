import 'package:flutter/material.dart';

import 'reset_home_page.dart';

export 'history_page.dart';
export 'reset_home_page.dart';
export 'scenario_progress_page.dart';
export 'scenario_selection_page.dart';

void main() {
  runApp(const ResetButtonApp());
}

class ResetButtonApp extends StatelessWidget {
  const ResetButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reset Button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6F62)),
        scaffoldBackgroundColor: const Color(0xFFF7F9F6),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        ),
        useMaterial3: true,
      ),
      home: const ResetHomePage(),
    );
  }
}
