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
                        desktop: OrderPageDesktop(column: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 15.0)),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                          Text('Order #' + snapshot.data[0]['order_number'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 7.0, 0.0, 0.0)),
                                          Text('Date: ' + getDate(snapshot.data[0]['date']),
                                              // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Status: ' + (snapshot.data[0]['fulfilled'] ? 'Fulfilled' : 'Pending'),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Total: \$' + snapshot.data[0]['total'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                        ]),
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: ListWrapper(
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
                                  elements: snapshot.data[1].map((product) => ListElement(
                                    route: IndividualProductRoute + product.id,
                                    object: product,
                                    items: [
                                      product['name'],
                                      snapshot.data[0]['products_and_amounts'][product.id].toString(),
                                      product['type'],
                                      '\$' + product['price'].toString(),
                                      product['vendor'],
                                    ],
                                  )).toList().cast<ListElement>()
                              ),
                            ),
                          ],
                        )),
                        tablet:
                        OrderPageTablet(column: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 15.0)),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                          Text('Order #' + snapshot.data[0]['order_number'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 7.0, 0.0, 0.0)),
                                          Text('Date: ' + getDate(snapshot.data[0]['date']),
                                              // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Status: ' + (snapshot.data[0]['fulfilled'] ? 'Fulfilled' : 'Pending'),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Total: \$' + snapshot.data[0]['total'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                        ]),
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: ListWrapper(
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
                                  elements: snapshot.data[1].map((product) => ListElement(
                                    route: IndividualProductRoute + product.id,
                                    object: product,
                                    items: [
                                      product['name'],
                                      snapshot.data[0]['products_and_amounts'][product.id].toString(),
                                      product['type'],
                                      '\$' + product['price'].toString(),
                                      product['vendor'],
                                    ],
                                  )).toList().cast<ListElement>()
                              ),
                            ),
                          ],
                        )),
                        mobile: OrderPageMobile(column: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 15.0)),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                          Text('Order #' + snapshot.data[0]['order_number'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 7.0, 0.0, 0.0)),
                                          Text('Date: ' + getDate(snapshot.data[0]['date']),
                                              // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Status: ' + (snapshot.data[0]['fulfilled'] ? 'Fulfilled' : 'Pending'),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Text('Total: \$' + snapshot.data[0]['total'].toString(),
                                              style:
                                              Theme.of(context).textTheme.headline5,
                                              textAlign: TextAlign.justify),
                                          Padding(
                                              padding:
                                              EdgeInsets.symmetric(vertical: 7.0)),
                                        ]),
                                  ]),
                            ),
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
                                elements: snapshot.data[1].map((product) => ListElement(
                                  route: IndividualProductRoute + product.id,
                                  object: product,
                                  items: [
                                    product['name'],
                                    snapshot.data[0]['products_and_amounts'][product.id].toString(),
                                    product['type'],
                                    '\$' + product['price'].toString(),
                                    product['vendor'],
                                  ],
                                )).toList().cast<ListElement>()
                            ),
                          ],
                        )),
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}
