import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/main.dart';
import 'package:shoe/screens/sign_up.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/internet.jpeg',
                      height: height * 0.2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No Connection',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Oop's it seems you can't connect to our network, Please check your internet connection.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.020,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: height * 0.060,
                  width: width * 0.7,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: () {
                      Get.off(() => SplashScreenPage(),
                          transition: Transition.topLevel,
                          duration: Duration(milliseconds: 300));
                    },
                    child: Center(
                      child: Text(
                        'Reload Page',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: height * 0.018,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
