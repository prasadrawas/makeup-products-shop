import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe/custom_widgets.dart';
import 'package:shoe/models/order_model.dart';
import 'package:shoe/screens/order_details.dart';

class MyOrders extends StatefulWidget {
  final String email;
  MyOrders(this.email);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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
          'My Orders',
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.6,
                backgroundColor: btnColor,
              ),
            );
          } else {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('No orders yet'),
              );
            }
            return _getOrderedProductsList(height, width, snapshot);
          }
        },
      ),
    );
  }

  _getOrderedProductsList(
      double height, double width, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        Order order = Order.fromJson(snapshot.data.docs[index].data());
        return InkWell(
          onTap: () {
            Get.to(() => OrderDetails(order),
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
                                order.name,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.025,
                                  letterSpacing: 1,
                                ),
                              ),
                              getNoPaddingText(
                                  order.brand ?? "",
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(
                                  order.type ?? "",
                                  Color(0xff453f3f),
                                  height * 0.018,
                                  FontWeight.w400),
                              getNoPaddingText(order.category ?? "", textColor,
                                  height * 0.018, FontWeight.w400),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$ " + order.price ?? "16.89",
                                    style: TextStyle(
                                      color: btnColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: height * 0.030,
                                    ),
                                  ),
                                  getText('Order Details', textColor,
                                      height * 0.020, FontWeight.w400)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                order.imageLink,
                                height: height * 0.080,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.network(
                                      'https://stockx-assets.imgix.net/media/New-Product-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
                                },
                              ),
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
