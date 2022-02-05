import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphsleepcalc/widgets/sleep_graph/paintable/sentinel.dart';

class TimeDashboard extends StatefulWidget {
  final ValueNotifier _sleepTimeNotifier;
  final ValueNotifier _wakeTimeNotifier;

  TimeDashboard(this._sleepTimeNotifier, this._wakeTimeNotifier);

  @override
  _TimeDashboardState createState() 
      => _TimeDashboardState(_sleepTimeNotifier, _wakeTimeNotifier);
}

class _TimeDashboardState extends State<TimeDashboard> {
  final ValueNotifier _sleepTimeNotifier;
  final ValueNotifier _wakeTimeNotifier;
  final TextStyle _dashboardTextStyle 
      = TextStyle(color: Colors.white, fontSize: 16);

  Duration _sleepDuration;

  _TimeDashboardState(this._sleepTimeNotifier, this._wakeTimeNotifier);

  @override
  void initState() {
    super.initState();

    Function setDurationState = () {
      setState(() {
        _sleepDuration 
            = _wakeTimeNotifier.value.difference(_sleepTimeNotifier.value);
      });
    };

    _sleepTimeNotifier.addListener(setDurationState);
    _wakeTimeNotifier.addListener(setDurationState);
    setDurationState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DashboardGauge('Sleep at ', _SentinelGauge(_sleepTimeNotifier)),
            _DashboardGauge('Wake up at ', _SentinelGauge(_wakeTimeNotifier)),
            _DashboardGauge('Sleep for ', _DurationGauge(_sleepDuration)),
          ],
        ),
      ),
    );
  }

  Widget _DashboardGauge(String gaugeText, Widget gauge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(gaugeText, style: _dashboardTextStyle),
        gauge
      ],
    );
  }

  Widget _SentinelGauge(ValueNotifier<DateTime> notifier) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return Text(
          Sentinel.formatTimeString(value),
          style: _dashboardTextStyle
        );
      }
    );
  }

  Widget _DurationGauge(Duration sleepDuration) {
    String twoDigits(var n) => n.toString().padLeft(2, "0");
    var hours = sleepDuration.inHours;
    var minutes = twoDigits(sleepDuration.inMinutes % 60);
    // TODO get 90 (sleep cycle length) from graph context
    var numCycles = (_sleepDuration.inMinutes / 90).toStringAsFixed(1);
    // String duration = '${hours}h ${minutes}m';
    String duration = '${hours}h ${minutes}m (${numCycles}c)';

    return Text(duration, style: _dashboardTextStyle);
  }
}
