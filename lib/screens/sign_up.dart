import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/screens/homepage.dart';
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/sign_in.dart';

class SignUpUserScreen extends StatefulWidget {
  @override
  _SignUpUserScreenState createState() => _SignUpUserScreenState();
}

class _SignUpUserScreenState extends State<SignUpUserScreen> {
  final TextEditingController _nameController = TextEditingController();
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
                                          letterSpacing: 1,
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
                                    height, 'Name', _nameController, false),
                                getTextField(
                                    height, 'Email', _emailController, false),
                                getTextField(height, 'Password',
                                    _passwordController, true),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already registered ?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: height * (0.019),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.offAll(() => SignInUserScreen(),
                                              transition: Transition.topLevel,
                                              duration:
                                                  Duration(milliseconds: 300));
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: btnColor,
                                            fontSize: height * (0.019),
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
                                _signUpUser(context);
                              }
                            },
                            child: Container(
                              height: height * 0.062,
                              width: width * 0.7,
                              child: Center(
                                child: Text('Sign Up',
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
        controller: controller,
        validator: (s) {
          if (s.isEmpty) return 'required';
          return null;
        },
        style: TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black54,
        obscureText: obsecureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelStyle: TextStyle(
            color: Colors.black54,
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  _signUpUser(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) async {
        DocumentReference users = FirebaseFirestore.instance
            .collection('users')
            .doc(_emailController.text.trim());
        await users.set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim()
        }).then((value) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('name', _nameController.text.trim());
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
      }).catchError((e) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        snackBar('Failed to signup', e.toString());
      });
    } catch (FirebaseAuthException) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      snackBar('Failed to sign up', FirebaseAuthException.toString());
    }
  }
}
