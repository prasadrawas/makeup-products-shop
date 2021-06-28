import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/screens/about.dart';
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/my_orders.dart';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  String _email = '';
  String _name = '';
  Future _getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _email = pref.getString('email');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_email)
        .get()
        .then((value) {
      _name = value.get('name');
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: textColor, //change your color here
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      body: loading
          ? LoadingScreen()
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: btnColor,
                            child: Icon(
                              Icons.verified_user,
                              color: Colors.white,
                            ),
                          ),
                          getText(
                            _name,
                            textColor,
                            height * 0.035,
                            FontWeight.w600,
                          ),
                          getText(_email, textColor, height * 0.022,
                              FontWeight.w400)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => MyOrders(_email),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      },
                      child: _getListTiles(
                        height,
                        'Your Orders',
                        FaIcon(
                          FontAwesomeIcons.solidStickyNote,
                          color: textColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => MyCartScreen(),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      },
                      child: _getListTiles(
                          height,
                          'Your Cart',
                          FaIcon(
                            FontAwesomeIcons.shoppingCart,
                            color: textColor,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => AboutScreen(),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      },
                      child: _getListTiles(
                          height,
                          'About',
                          FaIcon(
                            FontAwesomeIcons.info,
                            color: textColor,
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        Get.offAll(() => SignInUserScreen(),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      },
                      child: _getListTiles(
                          height,
                          'Logout',
                          FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: textColor,
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _getListTiles(double height, String name, FaIcon faIcon) {
    return ListTile(
      leading: faIcon,
      title: getText(name, textColor, height * 0.025, FontWeight.w400),
    );
  }
}
