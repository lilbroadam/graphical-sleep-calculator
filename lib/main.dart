import 'package:flutter/material.dart';
import 'package:graphsleepcalc/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.greenAccent[100],
    ),
    home: HomeScreen(),
  );
}
