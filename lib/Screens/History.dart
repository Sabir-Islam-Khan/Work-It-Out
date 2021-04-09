import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:work_it_out/Screens/HomePage.dart';
import 'package:work_it_out/Screens/ProfilePage.dart';
import 'package:work_it_out/Screens/SignIn.dart';
import 'package:work_it_out/services/Auth.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  DocumentSnapshot _data;
  double day1 = 0;
  double day2 = 0;
  double day3 = 0;
  double day4 = 0;
  double day5 = 0;
  double day6 = 0;
  double day7 = 0;
  getData() async {
    User user = await Auth().currentUser();

    String uid = user.uid;

    print("UID IS ########### $uid");

    DocumentSnapshot data =
        await Firestore.instance.collection('Users').document(uid).get();
    print("day 1 steps is ++++++++ ${data['day1Steps']}");

    day1 = data['day1Steps'] + 0.00;
    day2 = data['day2Steps'] + 0.00;
    day3 = data['day3Steps'] + 0.00;
    day4 = data['day4Steps'] + 0.00;
    day5 = data['day5Steps'] + 0.00;
    day6 = data['day6Steps'] + 0.00;
    day7 = data['day7Steps'] + 0.00;
    print("TEST +++++++++++ $day1");
  }

  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 350);

  int touchedIndex;

  bool isPlaying = false;
  Future<void> _signOut() async {
    try {
      await Auth().signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, day1, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, day2, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, day3, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, day4, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, day5, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, day6, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, day7, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(145, 155, 253, 1),
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        backgroundColor: Color(0xff4CAF50),
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.history, title: "History"),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.logout, title: 'Logout'),
        ],
        initialActiveIndex: 1, //optional, default as 0
        onTap: (int i) {
          if (i == 0) {
            print("tapped home");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarChartSample1(),
              ),
            );
            print("tapped history");
          } else if (i == 2) {
            print("tapped profile");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          } else if (i == 3) {
            setState(() {
              print("ready to perform logout");
            });
            _signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
            setState(() {
              print("logged out");
            });
          }
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: totalHeight * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: totalWidth * 1,
                height: totalHeight * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: const Color(0xff81e5cd),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Weekly History',
                                style: TextStyle(
                                    color: const Color(0xff0f4a3c),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Tap here to relax and load !',
                                style: TextStyle(
                                    color: const Color(0xff379982),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 38,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: BarChart(
                                    isPlaying ? randomData() : mainBarData(),
                                    swapAnimationDuration: animDuration,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: const Color(0xff0f4a3c),
                              ),
                              onPressed: () {
                                setState(() {
                                  isPlaying = !isPlaying;
                                  if (isPlaying) {
                                    refreshState();
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Day 1';
                  break;
                case 1:
                  weekDay = 'Day 2';
                  break;
                case 2:
                  weekDay = 'Day 3';
                  break;
                case 3:
                  weekDay = 'Day 4';
                  break;
                case 4:
                  weekDay = 'Day 5';
                  break;
                case 5:
                  weekDay = 'Day 6';
                  break;
                case 6:
                  weekDay = 'Day 7';
                  break;
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 1:
                return '2';
              case 2:
                return '3';
              case 3:
                return '4';
              case 4:
                return '5';
              case 5:
                return '6';
              case 6:
                return '7';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 1:
                return '2';
              case 2:
                return '3';
              case 3:
                return '4';
              case 4:
                return '5';
              case 5:
                return '6';
              case 6:
                return '7';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
