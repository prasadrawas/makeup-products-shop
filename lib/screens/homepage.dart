import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/homepage_provider.dart';
import 'package:shoe/models/product.dart';
import 'package:shoe/models/searching_provider.dart';
import 'package:shoe/screens/mycart.dart';
import 'package:shoe/screens/profile.dart';
import 'package:shoe/screens/search.dart';
import 'package:shoe/screens/shoe_details.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('products');

  List<String> productTypes = [
    "Blush",
    "Bronzer",
    "Eyebrow",
    "Eyeliner",
    "Eyeshadow",
    "Foundation",
    "Lip liner",
    "Lipstick",
    "Mascara",
    "Nail polish",
  ];
  HomepageProvider homepageProvider;
  @override
  void initState() {
    homepageProvider = Provider.of<HomepageProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getHeader(height, width),
                _getBrandContainer(height),
                Consumer<HomepageProvider>(builder: (context, value, child) {
                  return _getShoeCardContainer(height, width,
                      productTypes[value.selectedIndex].toLowerCase());
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getBrandContainer(double height) {
    return Container(
      height: height * 0.05,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: productTypes.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Consumer<HomepageProvider>(builder: (context, value, child) {
            return Ink(
              child: InkWell(
                onTap: () {
                  value.updateIndex(index);
                },
                child: AnimatedOpacity(
                  opacity: value.selectedIndex == index ? 1 : 0.3,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Consumer<HomepageProvider>(
                          builder: (context, value, child) {
                        return Text(
                          productTypes[index],
                          style: TextStyle(
                            color: value.selectedIndex == index
                                ? btnColor
                                : textColor,
                            fontSize: value.selectedIndex == index
                                ? height * 0.032
                                : height * 0.022,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  _getFutureBuilder(double height, double width, String brand) {
    return StreamBuilder(
      stream: ref.where('type', isEqualTo: brand).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Container(
            height: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 1.6,
                    backgroundColor: btnColor,
                  ),
                  SizedBox(height: 10),
                  Text('Loading')
                ],
              ),
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                'No results found',
              ),
            );
          }
          return GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            scrollDirection: Axis.vertical,
            childAspectRatio: 1,
            children: List.generate(snapshot.data.docs.length, (index) {
              return _getShoeCard(height, width,
                  Product.fromJson(snapshot.data.docs[index].data()));
            }),
          );
        }
      },
    );
  }

  _getShoeCardContainer(double height, double width, String brand) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getFutureBuilder(height, width, brand),
        ],
      ),
    );
  }

  _getShoeCard(double height, double width, Product product) {
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.to(() => ShoeDetailsScreen(product),
              transition: Transition.topLevel,
              duration: Duration(milliseconds: 400));
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
                      getText(
                          (product.brand == null) ? 'Product' : product.brand,
                          Colors.black87,
                          height * 0.017,
                          FontWeight.w500),
                      getText("\$" + ((product.price ?? 19.89).toString()),
                          btnColor, height * 0.030, FontWeight.w500),
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

  _getHeader(double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(top: height * 0.013, bottom: height * 0.050),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our',
                style: TextStyle(
                  fontSize: height * 0.035,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.shoppingBag,
                        size: height * 0.030,
                      ),
                      onPressed: () {
                        Get.to(() => MyCartScreen(),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      }),
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.userCircle,
                        size: height * 0.030,
                      ),
                      onPressed: () {
                        Get.to(() => ProfileScreen(),
                            transition: Transition.topLevel,
                            duration: Duration(milliseconds: 300));
                      }),
                ],
              )
            ],
          ),
          Text(
            'Products',
            style: TextStyle(
              fontSize: height * 0.035,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: height * 0.016,
          ),
          Center(
            child: Container(
              height: height * 0.090,
              width: width * 0.95,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => Searching(),
                          child: SearchScreen(),
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search product e.g. Eyeliner',
                        style: TextStyle(
                          fontSize: height * 0.019,
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.search,
                        size: height * 0.019,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
