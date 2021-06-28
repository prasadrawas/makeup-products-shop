import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/address_model.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/add_address.dart';
import 'package:shoe/screens/product_checkout.dart';

class AddressScreen extends StatefulWidget {
  final String email;
  final List<Product> product;
  AddressScreen(this.product, this.email);
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int _groupVal = -1;
  Address address;
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
          'Select Address',
          style: TextStyle(color: textColor),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getAddAddressButton(height, width),
            _getAllResults(height, width),
          ],
        ),
      ),
      bottomNavigationBar: _getFloatingActionButton(height, width),
    );
  }

  _getAllResults(double height, double width) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .collection('address')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.6,
                backgroundColor: btnColor,
              ),
            );
          } else {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No address found'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  child: Row(
                    children: [
                      Radio(
                          value: (_groupVal == index) ? 1 : 0,
                          groupValue: 1,
                          onChanged: (val) {
                            if (mounted) {
                              setState(() {
                                _groupVal = index;
                                address = Address.fromJson(
                                    snapshot.data.docs[index].data());
                              });
                            }
                          }),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.docs[index].get('cname'),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.025,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data.docs[index].get('house') +
                                  ", " +
                                  snapshot.data.docs[index].get('road') +
                                  ", " +
                                  snapshot.data.docs[index].get('city') +
                                  ", " +
                                  snapshot.data.docs[index].get('pincode'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.020,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data.docs[index].get('phone'),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: height * 0.020,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  _getFloatingActionButton(double height, double width) {
    return Container(
      height: height * 0.060,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: buttonStyle(),
        onPressed: () {
          if (_groupVal == -1) {
            snackBar('Failed', 'Please select address first');
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CheckoutScreen(address, widget.product)));
          }
        },
        child: Center(
          child: Text(
            'Deliver Here',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  _getAddAddressButton(double height, double width) {
    return InkWell(
        onTap: () {
          Get.off(() => AddAddressScreen(widget.product),
              transition: Transition.topLevel,
              duration: Duration(milliseconds: 300));
        },
        child: ListTile(
          leading: Icon(
            Icons.add,
            color: textColor,
          ),
          title: Text(
            "Add new address",
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
