import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_cycle_graph.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/sleep_graph2.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('flutter'), centerTitle: true),
    body: Container(
      child: Column(
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 3,
            // child: SleepCycleGraph(pxWidth: 800, pxHeight: 400),
            // child: SleepGraph(),
            child: SleepGraph2(),
          ),
          Spacer(),
        ],
      ),
      // decoration: BoxDecoration(color: Colors.greenAccent),
    ),
  );
}
