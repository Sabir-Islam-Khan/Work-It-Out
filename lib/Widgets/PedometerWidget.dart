//Weather update card calling from pages.Home.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import '../Widgets/BaseWidget.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/percent_indicator.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class ActivityCard extends StatefulWidget {
  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '', _steps = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

//get count step
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

// get activity status change
  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

//if activity status get any error or not available
  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

//if  step count  get any error or not available
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = '0';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  var personalStepChoice = 6000;

  @override
  Widget build(BuildContext context) {
    // total height and weight
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    int steps = int.parse(_steps);
    var percentCalc = (steps / personalStepChoice);
    double caloriBurnt = (.032 * steps);

    print(caloriBurnt);
    // BaseWidget help to get screen size and resize every component of it according to device sreen size
    return BaseWidget(
      builder: (context, sizingInfo) => Container(
        child: InkWell(
          child: Column(
            children: [
              Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: totalHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_walk,
                            size: 25,
                            color: Color(0xff4CAF50),
                          ),
                          Text(
                            'Steps',
                            style: TextStyle(
                              color: Color(0xff4CAF50),
                              fontSize: 16.0,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: CircularPercentIndicator(
                                radius: 150.0,
                                lineWidth: 15.0,
                                animation: true,
                                percent: percentCalc,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$_steps",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "/$personalStepChoice",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Steps taken',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: totalHeight * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: EdgeInsets.all(10),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Column(children: [
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            'Excercise',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Icon(
                            _status == 'walking'
                                ? Icons.directions_walk
                                : _status == 'stopped'
                                    ? Icons.accessibility_new
                                    : Icons.self_improvement,
                            color: Colors.green,
                            size: 35,
                          ),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                        child: Column(
                          children: [
                            Text('Total Calory Burnt'),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${caloriBurnt.toStringAsFixed(2)} cal.",
                                  style: TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
