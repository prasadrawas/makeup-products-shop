import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/screens/homepage.dart';

class OrderSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      create: (context) => HomepageProvider(),
                      child: HomePageScreen(),
                    )),
            (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: btnColor,
        body: SafeArea(
          child: Container(
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: height * 0.1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Order Placed Successfully',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: height * 0.022,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your order has been placed successfully and will deliver soon.\n We will contact you once we reach your place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: height * 0.016,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => HomepageProvider(),
                                      child: HomePageScreen(),
                                    )),
                            (route) => false);
                      },
                      child: Text(
                        'Continue Shopping',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
