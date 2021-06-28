import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoe/models/order_model.dart';
import '../custom_widgets.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  OrderDetails(this.order);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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
          'Order Details',
          style: TextStyle(color: Colors.black, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getorderDetails(height, width),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              _getAddressContainer(height, width),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              _getBillingDetails(height, width),
            ],
          ),
        ),
      ),
    );
  }

  _getBillingDetails(double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: height * 0.020,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                  ),
                ),
                Text(
                  "\$ " + (widget.order.price).toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Charges',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                  ),
                ),
                Text(
                  "Free",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount Payable',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹ " + (widget.order.price).toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment mode',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.020,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getAddressContainer(double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.cname,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.028,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: textColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        widget.order.house +
                            ", " +
                            widget.order.road +
                            ", " +
                            widget.order.city +
                            " " +
                            widget.order.pincode,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.022,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.call,
                      color: textColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.order.phone,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: height * 0.022,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getorderDetails(double height, double width) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.bookmark_border_rounded,
              size: height * 0.020,
            ),
            // trailing: Image.network(
            //  // widget.order.image,
            //   errorBuilder: (BuildContext context, Object exception,
            //       StackTrace stackTrace) {
            //     return Image.network(
            //         'https://stockx-assets.imgix.net/media/New-order-Placeholder-Default.jpg?fit=fill&bg=FFFFFF&w=140&h=100&auto=format,compress&trim=color&q=90&dpr=2&updated_at=0');
            //   },
            // ),
            title:
                getText('Name', Colors.black, height * 0.022, FontWeight.w600),
            subtitle: getText(widget.order.name, Color(0xff453f3f),
                height * 0.018, FontWeight.w400),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.ad,
              size: height * 0.020,
            ),
            title:
                getText('Brand', Colors.black, height * 0.022, FontWeight.w600),
            subtitle: getText(widget.order.brand ?? "", Color(0xff453f3f),
                height * 0.018, FontWeight.w400),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.moneyCheck,
              size: height * 0.020,
            ),
            title:
                getText('Price', Colors.black, height * 0.022, FontWeight.w600),
            subtitle: getText("\$ " + widget.order.price ?? 16.89,
                Color(0xff453f3f), height * 0.018, FontWeight.w400),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.typo3,
              size: height * 0.020,
            ),
            title: getText(
                'Category', Colors.black, height * 0.022, FontWeight.w600),
            subtitle: getText(widget.order.category ?? "", Color(0xff453f3f),
                height * 0.018, FontWeight.w400),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.info,
              size: height * 0.020,
            ),
            title:
                getText('Type', Colors.black, height * 0.022, FontWeight.w600),
            subtitle: getText(widget.order.name, Color(0xff453f3f),
                height * 0.018, FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
