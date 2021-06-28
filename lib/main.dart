import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';

import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/screens/homepage.dart';
import 'package:shoe/screens/no_internet.dart';
import 'package:shoe/screens/sign_up.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(GetMaterialApp(
    title: 'BeautyApp',
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.topLevel,
    theme: ThemeData(
      fontFamily: 'Poppins',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Color(0xFFffffff),
      primaryColor: btnColor,
    ),
    home: SplashScreenPage(),
  ));
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  var navigator;
  bool _checkPref = false;
  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

  Future checkInternetConnection() async {
    await checkPreferences();
    try {
      var res = await InternetAddress.lookup('google.com');
      if (res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        navigator = null;
      }
    } catch (e) {
      navigator = NoInternet();
    }
  }

  Future checkPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _checkPref = pref.getString('email') == null ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: navigator == null
          ? (_checkPref
              ? ChangeNotifierProvider(
                  create: (context) => HomepageProvider(),
                  child: HomePageScreen(),
                )
              : SignUpUserScreen())
          : NoInternet(),
      photoSize: 100,
      useLoader: false,
      image: Image.asset(
        'assets/images/logo.jpeg',
        height: 140,
      ),
      title: Text(
        'BeautyShop',
        style: TextStyle(color: Colors.black, letterSpacing: 1),
      ),
      loadingText: Text(
        'Designed and developed by\nprasad',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, letterSpacing: 1),
      ),
    );
  }
}
