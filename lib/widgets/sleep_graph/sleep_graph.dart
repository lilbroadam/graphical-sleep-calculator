import 'package:flutter/cupertino.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph_renderer.dart';

/**
 * References:
 * - https://github.com/imaNNeoFighT/fl_chart/tree/master/lib/src/chart/line_chart
 * - https://medium.com/flutter-community/creating-a-flutter-widget-from-scratch-a9c01c47c630
 */

class SleepGraph extends ImplicitlyAnimatedWidget {

  SleepGraph({
    Duration animationDuration = const Duration(milliseconds: 50),
    Curve animationCurve = Curves.linear
  }) : super(duration: animationDuration, curve: animationCurve);

  @override
  _SleepGraphState createState() => new _SleepGraphState();
}

class _SleepGraphState extends ImplicitlyAnimatedWidgetState<SleepGraph> {

  @override
  Widget build(BuildContext context) {
    return SleepGraphLeaf();
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    // TODO
  }
}
