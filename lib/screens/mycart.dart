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
import 'package:shoe/screens/loading.dart';
import 'package:shoe/screens/shoe_details.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  String _email;
  bool loading = true;
  List<Product> productList = [];
  int _totalCartItems = 0;

  Future<void> _getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _email = pref.getString('email');
    await _getTotalItems(_email);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  _getTotalItems(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('cart')
          .get()
          .then((value) {
        _totalCartItems = value.docs.length;
      });
    } catch (e) {
      _totalCartItems = 0;
    }
  }

  @override
  void initState() {
    _getEmail();
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
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Cart',
          style: TextStyle(color: textColor),
        ),
      ),
      body: loading
          ? LoadingScreen()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_email)
                  .collection('cart')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        backgroundColor: btnColor,
                      ),
                    ),
                  );
                } else if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('Cart is empty'),
                  );
                } else {
                  return _getCartProductsList(height, width, snapshot);
                }
              },
            ),
      floatingActionButton:
          _totalCartItems > 0 ? _getFloatingActionButton(height, width) : null,
    );
  }

  _getFloatingActionButton(double height, double width) {
    return Container(
      height: height * 0.060,
      width: width * 0.9,
      child: ElevatedButton(
        style: buttonStyle(),
        onPressed: () async {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_email)
                .collection('cart')
                .get()
                .then((QuerySnapshot snapshot) {
              for (int index = 0; index < snapshot.docs.length; index++) {
                productList.add(Product.fromJson(snapshot.docs[index].data()));
              }
            });

            Get.to(() => AddressScreen(productList, _email),
                transition: Transition.topLevel,
                duration: Duration(milliseconds: 300));
          } catch (e) {
            print('failed');
          }
        },
        child: Center(
          child: Text(
            'Checkout All',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _getCartProductsList(
      double height, double width, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        Product product = Product.fromJson(snapshot.data.docs[index].data());
        return InkWell(
          onTap: () {
            Get.to(() => ShoeDetailsScreen(product),
                transition: Transition.topLevel,
                duration: Duration(milliseconds: 300));
          },
          child: Container(
              padding: EdgeInsets.only(
                left: 20,
                top: 40,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.025,
                                  letterSpacing: 1,
                                ),
                              ),
                              getNoPaddingText(
                                  product.brand ?? "",
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(
                                  product.type ?? "",
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(
                                  product.category ?? "",
                                  Colors.black,
                                  height * 0.018,
                                  FontWeight.w400),
                              Text(
                                "\$" + product.price ?? "0",
                                style: TextStyle(
                                  color: btnColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: height * 0.030,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                product.imageLink,
                                height: height * 0.150,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.network(
                                      'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                                },
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color: Colors.black,
                                  size: height * 0.025,
                                ),
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(_email)
                                        .collection('cart')
                                        .doc(snapshot.data.docs[index].id)
                                        .delete();
                                    snackBar('Success',
                                        'Item deleted successfully.');
                                  } catch (e) {
                                    snackBar('Failed', 'Item deletion failed.');
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
