import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
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
  HorizontalDragGestureRecognizer _horizontalDragGesture; // TODO use 'late' keyword
  SleepGraphPainter _painter;

  RenderSleepGraph() {
    _painter = new SleepGraphPainter();

    _horizontalDragGesture = HorizontalDragGestureRecognizer()
      ..onStart = (details) { _handleHorizontalTouch(details.localPosition); }
      ..onUpdate = (details) { _handleHorizontalTouch(details.localPosition); };
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
    }
  }

  void _handleHorizontalTouch(Offset localPosition) {
    _painter.handleHorizontalTouch(localPosition);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}
