import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:work_it_out/Screens/History.dart';
import 'package:work_it_out/Screens/HomePage.dart';
import 'package:work_it_out/Screens/SignIn.dart';
import '../services/Auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  final Auth auth;

  ProfilePage({@optionalTypeArgs this.auth});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut() async {
    try {
      await Auth().signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUid();
    getPpUrl();
  }

  String _uid = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Future<String> getUid() async {
    User user = await Auth().currentUser();
    setState(() {
      _uid = user.uid;
    });
    print("UID IS +++++++++++ $_uid");

    print(user.uid);
    return user.uid.toString();
  }

  String _ppURL = '';
  void getPpUrl() async {
    String uid = await getUid();
    DocumentSnapshot ds =
        await Firestore.instance.collection('Users').document('$uid').get();

    setState(() {
      _ppURL = ds.data['profilePic'];
    });

    print("pp url is ++++++++++ $_ppURL");
  }

  String ppUrl = '';
  File _image;
  final picker = ImagePicker();

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://work-it-out-43d58.appspot.com");

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(
      () {
        _image = File(pickedFile.path);
      },
    );
  }

  bool _isLoading = false;

  void uploadImage() async {
    print("$_uid");
    setState(() {
      _isLoading = true;
    });
    StorageTaskSnapshot snapshot = await _storage
        .ref()
        .child("$_uid/${DateTime.now()}")
        .putFile(_image)
        .onComplete;
    final String profileImage = await snapshot.ref.getDownloadURL();
    await Firestore.instance.collection("Users").document('$_uid').updateData({
      "profilePic": profileImage,
    });
    nameController.clear();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(135, 145, 253, .8),
        bottomNavigationBar: ConvexAppBar(
          color: Colors.white,
          backgroundColor: Color(0xff4CAF50),
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.history, title: "History"),
            TabItem(icon: Icons.person, title: 'Profile'),
            TabItem(icon: Icons.logout, title: 'Logout'),
          ],
          initialActiveIndex: 2, //optional, default as 0
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
              print("tapped history");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarChartSample1(),
                ),
              );
            } else if (i == 2) {
              print("tapped profile");
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
        body: _isLoading == true
            ? Container(
                height: totalHeight * 1,
                width: totalWidth * 1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  height: totalHeight * 1,
                  width: totalWidth * 1,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: totalHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: ClipOval(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  color: Colors.teal[100],
                                  child: _image == null && _ppURL == ''
                                      ? Image(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            "assets/images/avatar_placeholder.png",
                                          ),
                                        )
                                      : _ppURL != ''
                                          ? Container(
                                              child: Image.network(
                                                _ppURL,
                                              ),
                                            )
                                          : Container(
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Image.file(
                                                  _image,
                                                ),
                                              ),
                                            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: totalHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print("Uid in profile is $_uid");
                                uploadImage();
                              },
                              child: Text(
                                "Upload ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         getImage();
                        //       },
                        //       child: Text(
                        //         "Pick Image",
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 18.0,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        SizedBox(
                          height: totalHeight * 0.03,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection('Users')
                              .document(_uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        elevation: 7.0,
                                        child: Container(
                                          height: totalHeight * 0.07,
                                          width: totalWidth * 0.9,
                                          color: Colors.grey[200],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // SizedBox(
                                              //   width: totalWidth * 0.1,
                                              // ),
                                              Text(
                                                "Name : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: totalWidth * 0.05,
                                              // ),
                                              Text(
                                                snapshot.data['name'],
                                                style: TextStyle(
                                                  color: Colors.cyan[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        Container(
                                                      height: 500.0,
                                                      color: Color.fromRGBO(
                                                          135, 145, 253, .8),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      labelText:
                                                                          "Edit Name :",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      hintText:
                                                                          "Change your name !",
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              controller:
                                                                  nameController,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print("$_uid");

                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .document(
                                                                        _uid)
                                                                    .updateData({
                                                                  'name':
                                                                      nameController
                                                                          .value
                                                                          .text,
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                  Icons.done,
                                                                  size: 45.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 26.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: totalHeight * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        elevation: 7.0,
                                        child: Container(
                                          height: totalHeight * 0.07,
                                          width: totalWidth * 0.9,
                                          color: Colors.grey[200],
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: totalWidth * 0.1,
                                              ),
                                              Text(
                                                "Email : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              SizedBox(
                                                width: totalWidth * 0.05,
                                              ),
                                              Text(
                                                snapshot.data['email'],
                                                style: TextStyle(
                                                  color: Colors.cyan[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: totalHeight * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        elevation: 7.0,
                                        child: Container(
                                          height: totalHeight * 0.07,
                                          width: totalWidth * 0.9,
                                          color: Colors.grey[200],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Age : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                snapshot.data['age'],
                                                style: TextStyle(
                                                  color: Colors.cyan[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        Container(
                                                      height: 500.0,
                                                      color: Color.fromRGBO(
                                                          135, 145, 253, .8),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      labelText:
                                                                          "Edit Age :",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      hintText:
                                                                          "Change your age !",
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  ageController,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print("$_uid");

                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .document(
                                                                        _uid)
                                                                    .updateData({
                                                                  'age':
                                                                      ageController
                                                                          .value
                                                                          .text,
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                  Icons.done,
                                                                  size: 45.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 26.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: totalHeight * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        elevation: 7.0,
                                        child: Container(
                                          height: totalHeight * 0.07,
                                          width: totalWidth * 0.9,
                                          color: Colors.grey[200],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Weight : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                snapshot.data['weight'],
                                                style: TextStyle(
                                                  color: Colors.cyan[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        Container(
                                                      height: 500.0,
                                                      color: Color.fromRGBO(
                                                          135, 145, 253, .8),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                      labelText:
                                                                          "Edit weight :",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      hintText:
                                                                          "Change your weight !",
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  weightController,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                totalHeight *
                                                                    0.05,
                                                          ),
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                print("$_uid");

                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Users')
                                                                    .document(
                                                                        _uid)
                                                                    .updateData({
                                                                  'weight':
                                                                      weightController
                                                                          .value
                                                                          .text,
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                  Icons.done,
                                                                  size: 45.0,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 26.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: totalHeight * 0.03,
                                  ),
                                  Center(
                                      child: GestureDetector(
                                    onTap: () {
                                      _signOut();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignIn(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.exit_to_app,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  )),
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
