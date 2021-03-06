import 'package:flutter/material.dart';

abstract class AbstractTheme {
  MaterialColor get primarySwatch;
  Color get primaryColor;
  Color get backgroundColor;
  Color get accentColor;
  Color get textColor;
  Color get black => Color(0xff000000);
  Color get white => Color(0xffffffff);
  Color get awakeColor;
  Color get deepSleepColor;
  Color get wakeWarningColor => Colors.red[400];
  double get colorStopMargin => 0.15;
}
