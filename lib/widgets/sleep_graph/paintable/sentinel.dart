import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/graph_context.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/paintable.dart';
import 'package:intl/intl.dart';

abstract class Sentinel extends Paintable {
  static const double SENTINEL_DIAMETER = 35.0;
  static const double SENTINEL_RADIUS = SENTINEL_DIAMETER / 2;
  static const double HIT_BOX_BODY_MARGIN = 25.0;
  static const double HIT_BOX_LINE_MARGIN = 10.0;
  static const double SENTINEL_BODY_LINE_MARGIN = 25.0;

  // What sentinel is current being dragged. Null if no sentinel being dragged.
  // Necessary to account for delays between calls to hitTest() so it doesn't
  // return false when a dragged point moves outside of the hitbox between 
  // frames. Also necessary so when a sentinel overlaps with another sentinel,
  // only the position of the one being dragged is updated.
  Sentinel _draggingSentinel;

  // If this sentinel is currently toggled to locked.
  bool isLocked;

  // TODO have a way that ensures bodyPaint is initialized by children
  Paint _bodyPaint;
  get bodyPaint => _bodyPaint;
  set bodyPaint (paint) => _bodyPaint = paint;

  ValueNotifier<DateTime> notifier = ValueNotifier(null);

  GraphContext _graphContext;

  Sentinel(this._graphContext) : isLocked = false;

  static String formatTimeString(DateTime time) {
    String timeString = DateFormat('h:mma').format(time);
    return timeString.toLowerCase().substring(0, timeString.length - 1);
  }

  /// Paint the body of this sentinel
  @override
  void paint(Canvas canvas, Size size) {
    _paintSentinelLine(canvas, size);
    canvas.drawCircle(offset, Sentinel.SENTINEL_RADIUS, bodyPaint);
  }

  void _paintSentinelLine(Canvas canvas, Size size) {    
    Offset o1 = Offset(offset.dx, _graphContext.sleepCycleMinY);
    Offset o2 = Offset(offset.dx, _graphContext.sleepCycleMaxY); // TODO calc y of sleep cycle
    canvas.drawLine(o1, o2, _bodyPaint);
  }

  /// Returns true if [event] is within this Sentinel's hitbox.
  /// If hit, update location to [event.localPosition].
  @override
  bool hitTest(GestureEvent event) {
    if (!isInteractable) {
      return false;
    }

    // Check that [event] is within the chart area
    if (event.localPosition != null
        && event.localPosition.dx < _graphContext.sleepCycleMinX) {
      return false;
    }

    if (_draggingSentinel != null ||
        event is HorizontalDragEndEvent ||
        event is HorizontalDragCancelEvent) {
      return true;
    }

    Offset hitOffset = event.localPosition + _graphContext.viewPane;
    double lineMinY = _graphContext.sleepCycleMinY - HIT_BOX_LINE_MARGIN;
    double lineMaxY = _graphContext.sleepCycleMaxY + HIT_BOX_LINE_MARGIN;
    bool hitBody = (offset.dx - hitOffset.dx).abs() < HIT_BOX_BODY_MARGIN
                && (offset.dy - hitOffset.dy).abs() < HIT_BOX_BODY_MARGIN;
    bool hitLine = (offset.dx - hitOffset.dx).abs() < HIT_BOX_LINE_MARGIN
                && hitOffset.dy > lineMinY
                && hitOffset.dy < lineMaxY;

    return hitBody || hitLine;
  }

  // TODO change to private method that children can call
  @override
  void onHorizontalDragEvent(HorizontalDragEvent event) {
    Offset eventOffset = event.localPosition;
    if (event is HorizontalDragDownEvent) {
      _draggingSentinel = this;
    } else if (event is HorizontalDragUpdateEvent 
        && this == _draggingSentinel && !isLocked) {
      setOffset(Offset(eventOffset.dx + _graphContext.viewPane.dx, offset.dy));
    } else if (event is HorizontalDragEndEvent ||
        event is HorizontalDragCancelEvent) {
      _draggingSentinel = null;
    }
  }

  void setOffset(Offset offset) {
    this.offset = offset;
    var minutesPerX 
        = _graphContext.sleepCycleMinutes / _graphContext.sleepCycleWidth;
    var xDiff = this.offset.dx - _graphContext.sleepCycleMinX;
    var minutesOffset = Duration(minutes: (minutesPerX * xDiff).toInt());
    var time = DateTime.now().add(minutesOffset);
    notifier.value = time;
  }

  double bodyY(GraphContext graphContext) {
    return graphContext.sleepCycleMinY - SENTINEL_BODY_LINE_MARGIN;
  }

  Offset _initialOffset(double numCycles) {
    Offset sleepCycleStart = _graphContext.sleepCycleToOffset(numCycles);
    return Offset(sleepCycleStart.dx, bodyY(_graphContext));
  }
}

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
  
  SleepSentinel(_graphContext) : super(_graphContext) {
    // TODO set bodyPaint by calling super constructor
    bodyPaint = _unlockedBodyPaint;

    _graphContext.sleepTimeNotifier = notifier;

    setOffset(_initialOffset(0.0));
  }

  /// Have SleepSentinel paint itself at [offset]
  @override
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

  @override
  void onGestureEvent(GestureEvent event) {
    if (event is TapUpEvent) {
      onTapEvent(event);
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }

  @override
  void onTapEvent(TapEvent event) {
    isLocked = !isLocked;
    bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
  }

  @override
  void setOffset(Offset offset) {
    if (_graphContext.wakeSentinelX != null 
        && _graphContext.wakeSentinelX <= offset.dx) {
      return;
    }

    super.setOffset(offset);
    _graphContext.sleepSentinelX = offset.dx;
  }
}

class WakeSentinel extends Sentinel {
  final Paint _unlockedBodyPaint = Paint()
      ..color = Colors.yellow[600]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
  final Paint _lockedBodyPaint = Paint()
      ..color = Colors.yellow[800]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
  
  WakeSentinel(_graphContext) : super(_graphContext) {
    // TODO set bodyPaint by calling super constructor
    super.bodyPaint = _unlockedBodyPaint;

    _graphContext.wakeTimeNotifier = notifier;

    setOffset(_initialOffset(3.0));
  }

  /// Have WakeSentinel paint itself at [offset].
  /// WakeSentinel will update it's internal location to [offset]
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
  }

  @override
  void onGestureEvent(GestureEvent event) {
    if (event is TapUpEvent) {
      onTapEvent(event);
    } else if (event is HorizontalDragEvent) {
      onHorizontalDragEvent(event);
    }
  }

  @override
  void onTapEvent(TapEvent event) {
    isLocked = !isLocked;
    bodyPaint = isLocked ? _lockedBodyPaint : _unlockedBodyPaint;
  }

  @override
  void setOffset(Offset offset) {
    if (_graphContext.sleepSentinelX != null 
        && _graphContext.sleepSentinelX >= offset.dx) {
      return;
    }

    super.setOffset(offset);
    _graphContext.wakeSentinelX = offset.dx;
  }
}
