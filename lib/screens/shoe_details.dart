import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/address.dart';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoeDetailsScreen extends StatefulWidget {
  final Product product;
  ShoeDetailsScreen(this.product);
  @override
  _ShoeDetailsScreenState createState() => _ShoeDetailsScreenState();
}

class _ShoeDetailsScreenState extends State<ShoeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Order',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.shoppingBag,
                size: height * 0.030,
                color: textColor,
              ),
              onPressed: () {
                Get.to(() => MyCartScreen(),
                    transition: Transition.topLevel,
                    duration: Duration(milliseconds: 400));
              }),
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userCircle,
                color: textColor,
                size: height * 0.030,
              ),
              onPressed: () {
                Get.to(() => ProfileScreen(),
                    transition: Transition.topLevel,
                    duration: Duration(milliseconds: 400));
              }),
        ],
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: height * 0.35,
                  child: Center(
                    child: Image.network(
                      widget.product.imageLink,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.network(
                            'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.productHunt,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Name', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(widget.product.name, Color(0xff453f3f),
                      height * 0.018, FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.ad,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Brand', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(
                      (widget.product.brand == null)
                          ? 'NaN'
                          : widget.product.brand,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.moneyCheck,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Price', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText("₹ " + widget.product.price.toString(),
                      Color(0xff453f3f), height * 0.018, FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.typo3,
                    size: height * 0.020,
                  ),
                  title: getText('Category', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: getText(
                      (widget.product.category == null)
                          ? 'NaN'
                          : widget.product.category,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.info,
                    size: height * 0.020,
                  ),
                  title: getText(
                      'Type', Colors.black, height * 0.022, FontWeight.w600),
                  subtitle: getText(
                      (widget.product.productType == null)
                          ? 'NaN'
                          : widget.product.productType,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.link,
                    size: height * 0.020,
                  ),
                  title: getText('Official Link', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: InkWell(
                    onTap: () async {
                      var url = widget.product.productLink.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        snackBar('Failed', 'Cannot open URL');
                      }
                    },
                    child: getText(
                        (widget.product.productLink == null)
                            ? 'NaN'
                            : widget.product.productLink,
                        Colors.blue,
                        height * 0.018,
                        FontWeight.w400),
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.clipboard,
                    size: height * 0.020,
                  ),
                  title: getText('Description', Colors.black, height * 0.022,
                      FontWeight.w600),
                  subtitle: getText(
                      (widget.product.description == null)
                          ? 'NaN'
                          : widget.product.description,
                      Color(0xff453f3f),
                      height * 0.018,
                      FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          height: height * 0.070,
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {
                    _addToCart();
                  },
                  child: Center(
                      child: Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    Get.to(
                        () => AddressScreen(
                            <Product>[widget.product], pref.getString('email')),
                        transition: Transition.topLevel,
                        duration: Duration(milliseconds: 300));
                  },
                  child: Center(
                    child: Text(
                      'Buy now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addToCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pref.getString('email'))
          .collection('cart')
          .doc(widget.product.name)
          .set(widget.product.toJson());
      snackBar('Success', 'Product added to cart');
    } catch (e) {
      snackBar('Failed', 'Product not added to cart');
    }
  }
}
