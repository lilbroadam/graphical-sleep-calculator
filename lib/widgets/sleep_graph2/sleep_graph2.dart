import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph_painter.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/sleep_graph_painter2.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';

class SleepGraph2 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    const FLEX_FACTOR = 3;

    Widget a = Container(color: Colors.blue);
    Widget b = Container(color: Colors.red);
    Widget c = Container(color: Colors.purple);
    Widget d = Container(color: Colors.orange);

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(flex: FLEX_FACTOR, child: RemLabels()),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: FLEX_FACTOR,
            child: Column(
              children: [
                // Expanded(flex: FLEX_FACTOR, child: c),
                Expanded(flex: FLEX_FACTOR, child: SleepGraphLeaf()),
                Expanded(flex: 1, child: TimeLabels()),
              ],
            ),
          ),
        ]
      )
    );
  }
}

class SleepGraphLeaf extends LeafRenderObjectWidget {
  @override
  RenderSleepGraph createRenderObject(BuildContext context) {
    return new RenderSleepGraph();
  }
}

class RenderSleepGraph extends RenderBox {
  SleepGraphPainter2 _painter;
  HorizontalDragGestureRecognizer _horizontalDragGesture; // TODO use 'late' keyword
  TapGestureRecognizer _tapGesture;

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
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green);
  }
}

class TimeLabels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.pink);
  }
}