import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph_painter.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/sleep_graph_painter2.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/graph_context.dart';

class SleepGraph2 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    const FLEX_FACTOR = 3;

    SleepGraphLeaf sleepGraphLeaf = SleepGraphLeaf();
    GraphContext graphContext = sleepGraphLeaf.graphContext;
    Widget remLabels = RemLabels(graphContext);
    Widget timeLabels = TimeLabels();

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
                // Expanded(flex: FLEX_FACTOR, child: c),
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
  RenderSleepGraph renderSleepGraph = RenderSleepGraph();

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

  get graphContext => _painter.graphContext;

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
    _painter.onGestureEvent(event);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}

class RemLabels extends StatelessWidget {
  final GraphContext _graphContext;

  RemLabels(this._graphContext);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: RemLabelsPainter(_graphContext),
    );
  }
}

class RemLabelsPainter extends CustomPainter {
  GraphContext _graphContext;

  RemLabelsPainter(this._graphContext);

  @override
  void paint(Canvas canvas, Size size) {
    // final Paint p = Paint()
    //     ..color = Colors.amber[200]
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 2.5;
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), p);
    
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
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    Offset adjustedOffset = Offset(
      size.width - textPainter.width - textMargin,
      offset.dy - textPainter.height / 2);

    textPainter.paint(canvas, adjustedOffset);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false; // TODO not sure what to do here
}

class TimeLabels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.pink);
  }
}