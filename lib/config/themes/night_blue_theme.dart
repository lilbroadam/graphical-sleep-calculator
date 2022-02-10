import 'package:flutter/material.dart';
import 'package:graphsleepcalc/config/themes/abstract_theme.dart';

class NightBlueTheme extends AbstractTheme {
  /* swatches
  1: https://coolors.co/000B0F-052033-00345C-ffffff-0971A6-ffffff-ffffff-ffffff-64A2CC-BBD5F0
  2: https://coolors.co/040B0D-042843-0E5686-ffffff-0e75a5-ffffff-ffffff-ffffff-64A2CC-B6D1EF
  3: https://coolors.co/012a4a-013a63-01497c-014f86-2a6f97-2c7da0-468faf-61a5c2-89c2d9-a9d6e5
  4: https://coolors.co/013a63-044772-085b88-0b6896-0e75a5-3087b4-519ac3-73acd1-94bfe0-b6d1ef
    * https://coolors.co/012a4a-013a63-01497c-014f86-2a6f97-2c7da0-468faf-61a5c2-89c2d9-a9d6e5
    * https://coolors.co/gradient-maker/012a4a-0e75a5-b6d1ef?position=0,50,100&opacity=100,100,100&type=linear&rotation=90
    * https://coolors.co/gradient-palette/0e75a5-b6d1ef?number=6
    * https://coolors.co/gradient-palette/013a63-0e75a5?number=5
  5: https://coolors.co/013a63-044670-06527d-095d8b-0b6998-0e75a5-388cb8-62a3ca-8cbadd-b6d1ef
    * https://coolors.co/012a4a-013a63-01497c-014f86-2a6f97-2c7da0-468faf-61a5c2-89c2d9-a9d6e5
    * https://coolors.co/gradient-maker/012a4a-0e75a5-b6d1ef?position=0,50,100&opacity=100,100,100&type=linear&rotation=90
    * https://coolors.co/gradient-palette/0e75a5-b6d1ef?number=5
    * https://coolors.co/gradient-palette/013a63-0e75a5?number=6
  */

  static const int _nightBluePrimary5 = 0xFF0B6998;
  static const Map<int, Color> _swatch5 = <int, Color>{
    50: Color(0xFFb6d1ef),
    100: Color(0xFF8cbadd),
    200: Color(0xFF62a3ca),
    300: Color(0xFF388cb8),
    400: Color(0xFF0e75a5),
    500: Color(_nightBluePrimary5),
    600: Color(0xFF095d8b),
    700: Color(0xFF06527d),
    800: Color(0xFF044670),
    900: Color(0xFF013a63),
  };
  static const MaterialColor _nightBlue = MaterialColor(
    _nightBluePrimary5,
    _swatch5,
  );
  static final _backgroundColor = _nightBlue[800];
  static final _accentColor = _nightBlue[100];
  static final _textColor = _nightBlue[50];
  static final _black = _nightBlue[900];
  static final _white = _nightBlue[50];

  MaterialColor get nightBlue => _nightBlue;

  MaterialColor get primarySwatch => _nightBlue;
  Color get primaryColor => _nightBlue;
  Color get backgroundColor => _backgroundColor;
  Color get accentColor => _accentColor;
  Color get textColor => _textColor;
  Color get black => _black;
  Color get white => _white;
  Color get awakeColor => Colors.amber; // .deepPurple[100], .blue[100]
  Color get deepSleepColor => Colors.blue[600]; // _nightBlue[300]
}
