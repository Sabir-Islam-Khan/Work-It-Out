import '../Animations/FadeAnimation.dart';
import '../Services/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'CreateAccount.dart';
import '../Services/Auth.dart';

class SignIn extends StatefulWidget {
  // authbase instance
  final AuthBase auth;
  SignIn({@optionalTypeArgs this.auth});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // value controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // signin  with mail method

  Future<void> _signInWithEmail(String mail, String password) async {
    try {
      dynamic result = await widget.auth.signInWithEmail(mail, password);
      if (result == null) {
        setState(() {
          loading = false;
        });
        // alert if info is invalid
        Alert(
          context: context,
          type: AlertType.error,
          title: "Error !!",
          desc: "User not found. Check credentials",
          buttons: [
            DialogButton(
              color: Color.fromRGBO(159, 122, 81, 1),
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      } else {
        // goes to landing page after succesful
        Navigator.push(
          context,
          MaterialPageRoute(
            // here landing page takes user to homepage
            builder: (context) => LandingPage(
              auth: widget.auth,
            ),
          ),
        );
      }
    } catch (e) {
      // error if somethinf goes wrong
      // check log message for clarification
      setState(() {
        loading = false;
      });
      print(e);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error !!",
        desc: "User not found. Check credentials !",
        buttons: [
          DialogButton(
            color: Color.fromRGBO(159, 122, 81, 1),
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // total height and width constrains
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;

    // text controllers

    return MaterialApp(
      home: Scaffold(
        // main body
        resizeToAvoidBottomInset: false,

        // checking loading status
        body: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                // container for whole body
                child: Container(
                  height: totalHeight * 1,
                  width: totalWidth * 1,
                  decoration: BoxDecoration(
                    // gradient for main app
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(175, 120, 252, 1),
                        Color.fromRGBO(154, 175, 253, 1),
                        Color.fromRGBO(175, 120, 252, 1),
                      ],
                    ),
                  ),
                  // whole content secion
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: totalHeight * 0.18,
                      ),
                      // fade in class used for animation
                      FadeIn(
                        0.5,
                        Padding(
                          padding: EdgeInsets.only(
                            left: totalWidth * 0.05,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            // page title
                            child: Text(
                              "Welcome",
                              style: GoogleFonts.meriendaOne(
                                color: Colors.white,
                                fontSize: totalHeight * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeIn(
                        0.9,
                        Padding(
                          padding: EdgeInsets.only(
                            left: totalWidth * 0.08,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            // page subtitle
                            child: Text(
                              "Enter our hub to make your day easy !",
                              style: GoogleFonts.meriendaOne(
                                color: Colors.grey[200],
                                fontSize: totalHeight * 0.023,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: totalHeight * 0.035,
                      ),
                      // textfiled for email
                      FadeIn(
                        1.3,
                        Container(
                          width: totalWidth * 0.9,
                          child: TextField(
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                hintText: "Enter your email",
                                hintStyle: TextStyle(
                                  color: Colors.grey[200],
                                )),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: totalHeight * 0.01,
                      ),
                      // textfield for password
                      FadeIn(
                        1.7,
                        Container(
                          width: totalWidth * 0.9,
                          child: TextField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: "Enter your password",
                              hintStyle: TextStyle(
                                color: Colors.grey[200],
                              ),
                            ),
                            controller: passwordController,
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: totalHeight * 0.05,
                      ),
                      FadeIn(
                        2.1,
                        Center(
                          // sign in button
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                loading = true;
                              });
                              String mail = emailController.value.text;
                              String password = passwordController.value.text;

                              // sign in method from Auth class
                              _signInWithEmail(mail, password);

                              emailController.clear();
                              passwordController.clear();
                            },
                            child: Container(
                              // container for button
                              height: totalHeight * 0.07,
                              width: totalWidth * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  // button text
                                  "Sign in",
                                  style: GoogleFonts.meriendaOne(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: totalHeight * 0.06,
                      ),
                      // bottom section
                      Row(
                        children: [
                          SizedBox(
                            width: totalWidth * 0.2,
                          ),
                          FadeIn(
                            3.0,
                            Text(
                              "Don't have an account ?  ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: totalWidth * 0.04,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccount(
                                    auth: widget.auth,
                                  ),
                                ),
                              );
                            },
                            child: FadeIn(
                              3.3,
                              Text(
                                "Create One",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: totalWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
