import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class SleepSentinel extends Sentinel {

  final _bigCraterRadius = Sentinel.SENTINEL_RADIUS * 0.3;
  final _mediumCraterRadius = Sentinel.SENTINEL_RADIUS * 0.2;
  final _smallCraterRadius = Sentinel.SENTINEL_RADIUS * 0.15;

  final Paint _unlockedBodyPaint = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
  
  final Paint _lockedBodyPaint = Paint()
      ..color = Colors.grey[500]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

  final Paint _craterPaint = Paint()
      ..color = Colors.grey[600]
      ..style = PaintingStyle.fill;

  SleepSentinel () {
    // TODO set bodyPaint by calling super constructor
    bodyPaint = _unlockedBodyPaint;

     // TODO get init location from sleep graph
    offset = Offset(100, 100);
  }

  /// Have SleepSentinel paint itself at [offset].
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    final Offset bigCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * -1/10, Sentinel.SENTINEL_DIAMETER * -1/6);
    final Offset mediumCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * 1/8, Sentinel.SENTINEL_DIAMETER * 1/8);
    final Offset smallCraterOffset
        = offset.translate(Sentinel.SENTINEL_DIAMETER * 1/3.5, Sentinel.SENTINEL_DIAMETER * -1/9);
    
    canvas.drawCircle(bigCraterOffset, _bigCraterRadius, _craterPaint);
    canvas.drawCircle(mediumCraterOffset, _mediumCraterRadius, _craterPaint);
    canvas.drawCircle(smallCraterOffset, _smallCraterRadius, _craterPaint);
  }

  void onGestureEvent(GestureEvent event) {
    // print('SleepSentinel.onGestureEvent(${event.runtimeType})');
    if (event is TapUpEvent) {
      isLocked = !isLocked;
      bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }
}
