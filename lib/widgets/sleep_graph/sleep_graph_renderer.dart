import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/hit_event/hit_event.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph_painter.dart';

class SleepGraphLeaf extends LeafRenderObjectWidget {

  @override
  RenderSleepGraph createRenderObject(BuildContext context) {
    return new RenderSleepGraph();
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    /* TODO
    renderObject
      ..property1 = value1
      ..property2 = value2;
    */
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(ColorProperty('barColor', barColor));
    // ^ where barColor is an instance variable of this class
  }
}

class RenderSleepGraph extends RenderBox {
  SleepGraphPainter _painter;
  HorizontalDragGestureRecognizer _horizontalDragGesture; // TODO use 'late' keyword
  TapGestureRecognizer _tapGesture;

  RenderSleepGraph() {
    _painter = new SleepGraphPainter();

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

  @override
  bool hitTestSelf(Offset position) => true;

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
