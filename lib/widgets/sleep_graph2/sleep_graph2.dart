import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui; // Resolves naming conflicts with intl
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/graph_context.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/sleep_graph_painter2.dart';
import 'package:intl/intl.dart';

class SleepGraph2 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    const FLEX_FACTOR = 3;

    SleepGraphLeaf sleepGraphLeaf = SleepGraphLeaf();
    GraphContext graphContext = sleepGraphLeaf.graphContext;
    Widget remLabels = RemLabels(graphContext);
    Widget timeLabels = TimeLabels(graphContext);

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(flex: FLEX_FACTOR, child: remLabels),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: FLEX_FACTOR,
            child: Column(
              children: [
                Expanded(flex: FLEX_FACTOR, child: sleepGraphLeaf),
                Expanded(flex: 1, child: timeLabels),
              ],
            ),
          ),
        ]
      )
    );
  }
}

class SleepGraphLeaf extends LeafRenderObjectWidget {
  final RenderSleepGraph renderSleepGraph = RenderSleepGraph();

  get graphContext => renderSleepGraph.graphContext;

  @override
  RenderSleepGraph createRenderObject(BuildContext context) {
    return renderSleepGraph;
  }
}

class RenderSleepGraph extends RenderBox {
  SleepGraphPainter2 _painter;
  HorizontalDragGestureRecognizer _horizontalDragGesture; // TODO use 'late' keyword
  TapGestureRecognizer _tapGesture;
  Offset viewPane = Offset(0, 0); // Coordinate of the view pane

  GraphContext get graphContext => _painter.graphContext;

  RenderSleepGraph() {
    _painter = new SleepGraphPainter2();

    _horizontalDragGesture = HorizontalDragGestureRecognizer();
    _horizontalDragGesture.onStart =
        (details) => _onGestureEvent(HorizontalDragStartEvent(details));
    _horizontalDragGesture.onUpdate =
        (details) => _onGestureEvent(HorizontalDragUpdateEvent(details));
    _horizontalDragGesture.onEnd =
        (details) => _onGestureEvent(HorizontalDragEndEvent(details));
    _horizontalDragGesture.onCancel = // TODO check this works as expected
        () => _onGestureEvent(HorizontalDragCancelEvent());

    _tapGesture = TapGestureRecognizer();
    _tapGesture.onTapUp = (details) => _onGestureEvent(TapUpEvent(details));
  }

  /* RENDERING */

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(
      Size(constraints.maxWidth, constraints.maxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    graphContext.resize(size);
    graphContext.applyViewPane(canvas, size);
    _painter.paint(canvas, size);
    canvas.restore();
  }

  /* TOUCH */

  @override bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _horizontalDragGesture.addPointer(event);
      _tapGesture.addPointer(event);
    }
  }

  void _onGestureEvent(GestureEvent event) {
    bool hit = _painter.onGestureEvent(event);
    if (event is HorizontalDragUpdateEvent && !hit) {
      // Use Math.max(0, __) to keep viewpane from going too far to the left
      var x = max(0.0, graphContext.viewPane.dx - event.details.delta.dx);
      graphContext.viewPane = Offset(x, 0);
    }

    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}

class RemLabels extends StatefulWidget {
  final GraphContext _graphContext;

  RemLabels(this._graphContext);

  @override
  _RemLabelsState createState() => _RemLabelsState(_graphContext);
}

class _RemLabelsState extends State<RemLabels> {
  final GraphContext _graphContext;

  _RemLabelsState(this._graphContext);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: RemLabelsPainter(_graphContext),
    );
  }
}

class RemLabelsPainter extends CustomPainter {
  final GraphContext _graphContext;

  RemLabelsPainter(this._graphContext);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double minY = _graphContext.sleepCycleMinY;
    final double maxY = _graphContext.sleepCycleMaxY;
    final Offset wakeOffset = Offset(centerX, minY);
    final Offset asleepOffset = Offset(centerX, (maxY + minY) / 2);
    final Offset deepSleepoffset = Offset(centerX, maxY);

    _paintText(canvas, size, 'Awake', wakeOffset);
    _paintText(canvas, size, 'Asleep', asleepOffset);
    _paintText(canvas, size, 'Deep sleep', deepSleepoffset);
  }

  void _paintText(Canvas canvas, Size size, String text, Offset offset) {
    final double textMargin = 5.0;
    final TextStyle textStyle = TextStyle(
      color: Colors.white, // TODO get from theme
      fontSize: 18.0 // TODO make font size sacle
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: ui.TextDirection.rtl,
    );

    textPainter.layout();
    Offset adjustedOffset = Offset(
      size.width - textPainter.width - textMargin,
      offset.dy - textPainter.height / 2
    );

    textPainter.paint(canvas, adjustedOffset);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false; // TODO not sure what to do here
}

class TimeLabels extends StatefulWidget {
  final GraphContext _graphContext;

  TimeLabels(this._graphContext);

  @override
  _TimeLabelsState createState() => _TimeLabelsState(_graphContext);
}

class _TimeLabelsState extends State<TimeLabels> {
  final GraphContext _graphContext;
  final ValueNotifier _dateTimeNotifier;

  _TimeLabelsState(this._graphContext) 
      : _dateTimeNotifier = ValueNotifier(DateTime.now()) {
    // Check every second to see if the minute has changed. If it has, repaint
    // so that the time labels match the current time.
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.minute != _dateTimeNotifier.value.minute) {
        _dateTimeNotifier.value = now;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: TimeLabelsPainter(_graphContext, _dateTimeNotifier),
    );
  }
}

class TimeLabelsPainter extends CustomPainter {
  GraphContext _graphContext;

  TimeLabelsPainter(this._graphContext, repaint) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _graphContext.applyViewPane(canvas, size);

    final double y = 0;
    final double minX = _graphContext.sleepCycleMinX;
    final double maxX = _graphContext.size.width;
    final double cycleWidth = _graphContext.sleepCycleWidth;
    final int halfCycleMinutes = _graphContext.sleepCycleMinutes ~/ 2;
    final double halfCycleWidth = cycleWidth / 2;
    final double numHalfCycles = ((maxX - minX) / cycleWidth) * 2;
    for (int i = 0; i < numHalfCycles; i++) {
      DateTime time = 
          DateTime.now().add(Duration(minutes: i * halfCycleMinutes));
      double x = minX + i * halfCycleWidth;

      _paintTimeStamp(canvas, size, _formatTimeString(time), Offset(x, y));
    }
  }

  String _formatTimeString(DateTime time) {
    String timeString = DateFormat('h:mma').format(time);
    return timeString.toLowerCase().substring(0, timeString.length - 1);
  }

  void _paintTimeStamp(Canvas canvas, Size size, String text, Offset offset) {
    final double textMargin = 5.0;
    final TextStyle  textStyle = TextStyle(
      color: Colors.white, // TODO get from theme
      fontSize: 13.0, // TODO make font size scale
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();
    Offset adjustedOffset = Offset(
      offset.dx - textPainter.width / 2,
      offset.dy + textMargin,
    );

    textPainter.paint(canvas, adjustedOffset);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
