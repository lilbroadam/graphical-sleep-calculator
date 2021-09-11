
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class WakeSentinel extends Sentinel {

  WakeSentinel () {
    // TODO set bodyPaint by calling super constructor
    super.bodyPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

    offset = Offset(300, 100); // TODO get init location from sleep graph
  }

  /// Have WakeSentinel paint itself at [offset].
  /// WakeSentinel will update it's internal location to [offset]
  void paint(Canvas canvas, Size size) {
    paintSentinelLine(canvas, size);
    canvas.drawCircle(offset, Sentinel.SENTINEL_RADIUS, bodyPaint);
  }
}
