import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/address_model.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/screens/address.dart';
import 'package:shoe/screens/loading.dart';

class AddAddressScreen extends StatefulWidget {
  final List<Product> product;
  AddAddressScreen(this.product);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
          'Address Details',
          style: TextStyle(color: textColor),
        ),
      ),
      key: _scaffoldKey,
      body: loading
          ? LoadingScreen()
          : SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Enter address details !',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: height * 0.025,
                            ),
                          ),
                        ),
                        getTextField(height, 'Name', _nameController, false),
                        getTextField(height, 'Phone', _phoneController, false),
                        getTextField(
                            height, 'Pincode', _pincodeController, false),
                        getTextField(height, 'City', _cityController, false),
                        getTextField(height, 'House No., Building Name',
                            _houseController, false),
                        getTextField(height, 'Road name, Area, Colony',
                            _roadController, false),
                        _getFloatingActionButton(height, width)
                      ],
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
          return s.isEmpty ? "Required" : null;
        },
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

  _storeAddress(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }

      Address address = Address(
        cname: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        pincode: _pincodeController.text.trim(),
        city: _cityController.text.trim(),
        house: _houseController.text.trim(),
        road: _roadController.text.trim(),
      );
      SharedPreferences pref = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(pref.getString('email'))
          .collection('address')
          .add(address.toJson());
      Get.off(() => AddressScreen(widget.product, pref.getString('email')),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 300));
    } catch (FirebaseAuthException) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      snackBar("Failed", FirebaseAuthException.toString());
    }
  }

  _getFloatingActionButton(double height, double width) {
    return Container(
      height: height * 0.060,
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        style: buttonStyle(),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _storeAddress(context);
          }
        },
        child: Center(
          child: Text(
            'Save Address',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
