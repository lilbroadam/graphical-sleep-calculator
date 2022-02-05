import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_cycle_graph.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/sleep_graph.dart';
import 'package:graphsleepcalc/widgets/sleep_graph2/sleep_graph2.dart';
import 'package:graphsleepcalc/widgets/time_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SleepGraph2 sleepGraph;

  _HomeScreenState() : sleepGraph = SleepGraph2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('flutter'), centerTitle: true),
      body: Container(
        child: Column(
          children: <Widget>[
            Spacer(),
            TimeDashboard(
              sleepGraph.sleepTimeNotifier,
              sleepGraph.wakeTimeNotifier
            ),
            Expanded(
              flex: 3,
              // child: SleepCycleGraph(pxWidth: 800, pxHeight: 400),
              // child: SleepGraph(),
              child: sleepGraph,
            ),
            Spacer(),
          ],
        ),
        // decoration: BoxDecoration(color: Colors.greenAccent),
      ),
    );
  }
}
