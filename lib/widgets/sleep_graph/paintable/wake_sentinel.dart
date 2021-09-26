
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class WakeSentinel extends Sentinel {

  final Paint _unlockedBodyPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  final Paint _lockedBodyPaint = Paint()
      ..color = Colors.yellow[800]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  WakeSentinel () {
    // TODO set bodyPaint by calling super constructor
    super.bodyPaint = _unlockedBodyPaint;

    offset = Offset(300, 100); // TODO get init location from sleep graph
  }

  /// Have WakeSentinel paint itself at [offset].
  /// WakeSentinel will update it's internal location to [offset]
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
  }

  void onGestureEvent(GestureEvent event) {
    // print('WakeSentinel.onGestureEvent(${event.runtimeType})');
    if (event is TapUpEvent) {
      isLocked = !isLocked;
      bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }
}
