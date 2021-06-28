import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/screens/homepage.dart';
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/sign_up.dart';

class SignInUserScreen extends StatefulWidget {
  @override
  _SignInUserScreenState createState() => _SignInUserScreenState();
}

class _SignInUserScreenState extends State<SignInUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? LoadingScreen()
          : SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/logo.jpeg',
                                        height: height * (0.180),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Polish your Appearance.',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * (0.080),
                                ),
                                getTextField(
                                    height, 'Email', _emailController, false),
                                getTextField(height, 'Passowrd',
                                    _passwordController, true),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Not yet registered ? ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: height * (0.019),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.offAll(() => SignUpUserScreen());
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: btnColor,
                                              fontSize: height * (0.019),
                                            ),
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: buttonStyle(),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _signInUser(context);
                              }
                            },
                            child: Container(
                              height: height * 0.062,
                              width: width * 0.7,
                              child: Center(
                                child: Text('Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: height * 0.018,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget getTextField(double height, String labelText,
      TextEditingController controller, bool obsecureText) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.015, bottom: height * 0.015),
      child: TextFormField(
        validator: (s) {
          if (s.isEmpty) return 'required';
          return null;
        },
        controller: controller,
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black54,
        obscureText: obsecureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(
            color: Colors.black54,
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  _signInUser(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('email', _emailController.text.trim());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      create: (context) => HomepageProvider(),
                      child: HomePageScreen(),
                    )),
            (route) => false);
      });
    } catch (FirebaseAuthException) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      snackBar('Failed to sign in', FirebaseAuthException.toString());
    }
  }

  void addIndex() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('products');
    try {
      await ref.get().then((value) async {
        for (var d in value.docs) {
          await d.reference.update({
            'index': d.get('type')[0].toLowerCase(),
          });
        }
      });
      print('updation success');
    } catch (e) {
      print("Error caught :: $e");
    }
  }
}
