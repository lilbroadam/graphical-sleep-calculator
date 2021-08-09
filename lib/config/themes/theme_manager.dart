import 'package:graphsleepcalc/config/themes/abstract_theme.dart';
import 'package:graphsleepcalc/config/themes/night_blue_theme.dart';

class ThemeManager {
  static AbstractTheme _theme = NightBlueTheme();

  static AbstractTheme get theme => _theme;
}