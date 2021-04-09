//Weather update card calling from pages.Home.dart
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_it_out/services/Auth.dart';
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
    getUid();
    readData();
  }

  String _uid = '';
  CollectionReference users = Firestore.instance.collection('Users');

//get count step
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  String test = " ";

  Future<String> getUid() async {
    User user = await Auth().currentUser();
    setState(() {
      _uid = user.uid;
    });

    print(user.uid);
    return user.uid.toString();
  }

  // database data
  Future<void> readData() async {
    String uid = await getUid();
    DocumentSnapshot data =
        await Firestore.instance.collection('Users').document(uid).get();

    print(data['name']);
  }

  Future<void> createData(String steps, String date) async {
    String uid = await getUid();

    DocumentSnapshot data =
        await Firestore.instance.collection('Users').document(uid).get();

    String today =
        DateTime.now().day.toString() + "-" + DateTime.now().month.toString();
    if (data['day1'] == 0 || data['day1'] == today) {
      Firestore.instance.collection('Users').document(uid).updateData({
        'day1': date,
        'day1Steps': steps,
      });
    } else if (data['day2'] == 0 || data['day2'] == today) {
      int todaySteps = int.parse(steps) - int.parse(data['day1Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day2': date,
        'day2Steps': todaySteps,
      });
    } else if (data['day3'] == 0 || data['day3'] == today) {
      int todaySteps = int.parse(steps) -
          int.parse(data['day1Steps']) -
          int.parse(data['day2Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day3': date,
        'day3Steps': todaySteps,
      });
    } else if (data['day4'] == 0 || data['day4'] == today) {
      int todaySteps = int.parse(steps) -
          int.parse(data['day1Steps']) -
          int.parse(data['day2Steps']) -
          int.parse(data['day3Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day4': date,
        'day4Steps': todaySteps,
      });
    } else if (data['day5'] == 0 || data['day5'] == today) {
      int todaySteps = int.parse(steps) -
          int.parse(data['day1Steps']) -
          int.parse(data['day2Steps']) -
          int.parse(data['day3Steps']) -
          int.parse(data['day4Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day5': date,
        'day5Steps': todaySteps,
      });
    } else if (data['day6'] == 0 || data['day6'] == today) {
      int todaySteps = int.parse(steps) -
          int.parse(data['day1Steps']) -
          int.parse(data['day2Steps']) -
          int.parse(data['day3Steps']) -
          int.parse(data['day4Steps']) -
          int.parse(data['day5Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day6': date,
        'day6Steps': todaySteps,
      });
    } else if (data['day7'] == 0 || data['day7'] == today) {
      int todaySteps = int.parse(steps) -
          int.parse(data['day1Steps']) -
          int.parse(data['day2Steps']) -
          int.parse(data['day3Steps']) -
          int.parse(data['day4Steps']) -
          int.parse(data['day5Steps']) -
          int.parse(data['day6Steps']);
      Firestore.instance.collection('Users').document(uid).updateData({
        'day6': date,
        'day6Steps': todaySteps,
      });
    }
  }

// get activity status change
  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });

    String date =
        DateTime.now().day.toString() + "-" + DateTime.now().month.toString();
    createData(_steps, date);
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

  int dayStatus = 1;
  int removable = 0;
  void setStatus() async {
    String uid = await getUid();

    DocumentSnapshot data =
        await Firestore.instance.collection('Users').document(uid).get();

    if (data['day1'] == 0) {
      setState(() {
        dayStatus = 1;
        removable = 0;
      });
    } else if (data['day2'] == 0) {
      setState(() {
        dayStatus = 2;
        removable = int.parse(data['day1Steps']);
      });
    } else if (data['day3'] == 0) {
      setState(() {
        dayStatus = 3;
        removable = int.parse(data['day1Steps']) + int.parse(data['day2Steps']);
      });
    } else if (data['day4'] == 0) {
      setState(() {
        dayStatus = 4;
        removable = int.parse(data['day1Steps']) +
            int.parse(data['day2Steps']) +
            int.parse(data['day3Steps']);
      });
    } else if (data['day5'] == 0) {
      setState(() {
        dayStatus = 5;
        removable = int.parse(data['day1Steps']) +
            int.parse(data['day2Steps']) +
            int.parse(data['day3Steps']) +
            int.parse(data['day4Steps']);
      });
    } else if (data['day6'] == 0) {
      setState(() {
        dayStatus = 6;
        removable = int.parse(data['day1Steps']) +
            int.parse(data['day2Steps']) +
            int.parse(data['day3Steps']) +
            int.parse(data['day4Steps']) +
            int.parse(data['day5Steps']);
      });
    } else if (data['day7'] == 0) {
      setState(() {
        dayStatus = 7;
        removable = int.parse(data['day1Steps']) +
            int.parse(data['day2Steps']) +
            int.parse(data['day3Steps']) +
            int.parse(data['day4Steps']) +
            int.parse(data['day5Steps']) +
            int.parse(data['day6Steps']);
      });
    }
  }

  var personalStepChoice = 6000;

  @override
  Widget build(BuildContext context) {
    // total height and weight
    double totalHeight = MediaQuery.of(context).size.height;

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
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
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
              SizedBox(
                height: totalHeight * 0.02,
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
