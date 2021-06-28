import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/searching_provider.dart';
import 'package:shoe/models/shoe.dart';
import 'package:shoe/screens/shoe_details.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool searching = true;
  String _query = '';
  List<Product> searchResults = [];
  List<Product> indexSearch = [];
  Searching searchProvider;
  CollectionReference ref = FirebaseFirestore.instance.collection('products');
  @override
  void initState() {
    searchProvider = Provider.of<Searching>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: _getAppBar(),
        body: _getShoeCardContainer(height, width, _query, searchResults));
  }

  Future<List<Product>> indexSearching() async {
    String i = _controller.text[0].toLowerCase();
    List<Product> list = [];
    try {
      await ref.where('index', isEqualTo: i).get().then((value) async {
        for (var d in value.docs) {
          list.add(Product.fromJson(d.data()));
        }
      });
    } catch (e) {
      print("Error caught :: $e");
    }
    return list;
  }

  Future<List<Product>> searchQuery() async {
    indexSearch = await indexSearching();
    searchResults.clear();
    for (int i = 0; i < indexSearch.length; i++) {
      if (indexSearch[i]
          .type
          .toLowerCase()
          .contains(_controller.text.trim().toLowerCase()))
        searchResults.add(indexSearch[i]);
    }
    return searchResults;
  }

  _getFutureBuilder(
      double height, double width, String query, List<Product> list) {
    return Consumer<Searching>(builder: (context, value, child) {
      return FutureBuilder(
        future: searchQuery(),
        builder: (context, snapshot) {
          if (value.querySubmitted == true && snapshot.hasData == false) {
            return Container(
              height: 400,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 1.6,
                    backgroundColor: btnColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Searching')
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text('No results found'),
              );
            }

            return GridView.count(
              crossAxisCount: 1,
              physics: BouncingScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              scrollDirection: Axis.vertical,
              childAspectRatio: 1,
              children: List.generate(snapshot.data.length, (index) {
                return _getShoeCard(height, width, snapshot.data[index]);
              }),
            );
          }
          return Center();
        },
      );
    });
  }

  _getShoeCardContainer(
      double height, double width, String brand, List<Product> list) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: _getFutureBuilder(height, width, brand, list),
          ),
        ],
      ),
    );
  }

  _getShoeCard(double height, double width, Product product) {
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Get.to(() => ShoeDetailsScreen(product),
              transition: Transition.topLevel,
              duration: Duration(milliseconds: 300));
        },
        child: Container(
          height: height * 0.35,
          width: width * 0.5,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.network(
                    product.imageLink,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.network(
                          'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: height * 0.020,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      getText(product.brand ?? "", Colors.black87,
                          height * 0.017, FontWeight.w500),
                      getText("\$ " + (product.price ?? "16.89"), btnColor,
                          height * 0.030, FontWeight.w500),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: searching
          ? Consumer<Searching>(builder: (context, value, child) {
              return TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onTap: () {
                  value.updateVarFalse();
                },
                onFieldSubmitted: (String s) {
                  _query = s;
                  FocusScope.of(context).unfocus();
                  value.updateVarTrue();
                },
                autofocus: true,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                ),
              );
            })
          : Text(
              'Search',
              style: TextStyle(letterSpacing: 1, color: Colors.black),
            ),
      actions: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.times,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            _controller.clear();
          },
        ),
      ],
    );
  }
}
