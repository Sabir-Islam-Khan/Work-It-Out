import 'package:work_it_out/Widgets/PedometerWidget.dart';

import '../Services/Auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }

  final Auth auth;
  HomePage({@required this.auth});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // pedometer initialization
  //  Stream<StepCount> _stepCountStream;

  void initSetup() async {
    setState(() {
      loading = true;
    });
    User user = await widget.auth.currentUser();

    setState(() {
      _user = user;
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  User _user;
  bool loading;
  @override
  Widget build(BuildContext context) {
    // total height and width constrains
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(145, 155, 253, 1),
      body: Column(
        children: [
          SizedBox(
            height: totalHeight * 0.05,
          ),
          ActivityCard(),
        ],
      ),
    );
  }
}
