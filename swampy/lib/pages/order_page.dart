import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/pages/order_page/order_page_desktop.dart';
import 'package:swampy/pages/order_page/order_page_mobile.dart';
import 'package:swampy/pages/order_page/order_page_tablet.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/router/route.dart';

//TODO: Order Page will have Order object passed in based on ID routing

class OrderPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String id;
  final Order order;

  OrderPage({@required this.id, @required this.order});

  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 4}', '${index + 8}', '${index + 12}'],
          ));

  String getAmounts(prodsNAmts) {
    int count = 0;
    for (var k in prodsNAmts.keys) {
      count += prodsNAmts[k];
    }
    return count.toString();
  }

  String getDate(date) {
    var d = DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000, isUtc: true);
    return d.month.toString() + "/" + d.day.toString() + "/" + d.year.toString();
  }

  Future<List<dynamic>> getData(context) async {
    var order = await FirebaseFirestore.instance.collection('orders').doc(ModalRoute.of(context).settings.name.substring(7)).get();
    var orderProducts = [];
    for (var product in order['products_and_amounts'].keys) {
      var p = await FirebaseFirestore.instance.collection('products').doc(product).get();
      orderProducts.add(p);
    }
    return [order, orderProducts];
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: FutureBuilder(
                  future: getData(context),
                  builder: (context, snapshot) {
                    print(ModalRoute.of(context).settings.name.substring(9));
                    if (snapshot.hasData) {
                      return ScreenTypeLayout(
                        desktop: OrderPageDesktop(child: OrderBody(data: snapshot.data)),
                        tablet: OrderPageTablet(child: OrderBody(data: snapshot.data)),
                        mobile: OrderPageMobile(child: OrderBody(data: snapshot.data)),
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}

class OrderBody extends StatelessWidget {
  final List<dynamic> data;

  OrderBody({this.data});

  String getDate(date) {
    var d = DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000, isUtc: true);
    return d.month.toString() + "/" + d.day.toString() + "/" + d.year.toString();
  }

  Future<List<dynamic>> getData(context) async {
    var order = await FirebaseFirestore.instance.collection('orders').doc(ModalRoute.of(context).settings.name.substring(7)).get();
    var orderProducts = [];
    for (var product in order['products_and_amounts'].keys) {
      var p = await FirebaseFirestore.instance.collection('products').doc(product).get();
      orderProducts.add(p);
    }
    return [order, orderProducts];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #' + data[0]['order_number'].toString(),
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)),
                    Text('Date: ' + getDate(data[0]['date']),
                        style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5)),
                    Text('Status: ' + (data[0]['fulfilled'] ? 'Fulfilled' : 'Pending'),
                        style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5)),
                    Text('Total: \$' + data[0]['total'].toString(),
                        style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5)),
                  ]),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        ListWrapper(
            searchType: ' product',
            titles: [
              'Product',
              'Amount',
              'Type',
              'Price',
              'Vendor'
            ],
            filterSliders: [1, 3],
            filterCategories: [2, 4],
            primaryKey: 0,
            secondaryKey: 1,
            elements: data[1].map((product) => ListElement(
              route: IndividualProductRoute + product.id,
              object: product,
              items: [
                product['name'],
                data[0]['products_and_amounts'][product.id].toString(),
                product['type'],
                '\$' + product['price'].toString(),
                product['vendor'],
              ],
            )).toList().cast<ListElement>()
        ),
      ],
    );
  }
}

