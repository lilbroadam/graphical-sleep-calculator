import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/theme_manager.dart';
import 'package:graphsleepcalc/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: ThemeManager.theme.primaryColor,
      primarySwatch: ThemeManager.theme.primarySwatch,
      scaffoldBackgroundColor: ThemeManager.theme.backgroundColor,
    ),
    home: HomeScreen(),
  );
}
