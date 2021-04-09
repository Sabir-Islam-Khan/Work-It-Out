import 'package:work_it_out/Screens/ProfilePage.dart';
import 'package:work_it_out/Screens/SignIn.dart';
import 'package:work_it_out/Widgets/PedometerWidget.dart';
import 'package:work_it_out/Widgets/WeatherCard.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../Services/Auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String formatDate(DateTime d) {
    return d.toString().substring(0, 19);
  }

  final AuthBase auth;
  HomePage({@optionalTypeArgs this.auth});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // pedometer initialization
  //  Stream<StepCount> _stepCountStream;

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

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
      bottomNavigationBar: ConvexAppBar(
        color: Colors.white,
        backgroundColor: Color(0xff4CAF50),
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.history, title: "History"),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.logout, title: 'Logout'),
        ],
        initialActiveIndex: 0, //optional, default as 0
        onTap: (int i) {
          if (i == 0) {
            print("tapped home");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(auth: widget.auth),
              ),
            );
          } else if (i == 1) {
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
                builder: (context) => SignIn(auth: widget.auth),
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
            height: totalHeight * 0.06,
          ),
          ActivityCard(),
          SizedBox(
            height: totalHeight * 0.04,
          ),
          WeatherCard(),
        ],
      ),
    );
  }
}
