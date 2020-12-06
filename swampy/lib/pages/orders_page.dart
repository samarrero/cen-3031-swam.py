import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/pages/orders_page/orders_page_desktop.dart';
import 'package:swampy/pages/orders_page/orders_page_mobile.dart';
import 'package:swampy/pages/orders_page/orders_page_tablet.dart';
import 'package:swampy/router/route.dart';

class OrdersPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 7}', '${index + 8}', '${index + 9}'],
          ));

  List<Order> orders = ordersList;

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
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('orders').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ScreenTypeLayout(
                          desktop: OrdersPageDesktop(listWrapper: ListWrapper(
                            searchType: 'n order',
                            titles: ['Order #', 'Date', 'Amount', 'Total', 'Status'],
                            filterSliders: [2, 3],
                            filterCategories: [4],
                            elements: snapshot.data.documents.map((order) => ListElement(
                              route: OrderRoute + order.id,
                              object: order,
                              items: [
                                order['order_number'].toString(),
                                //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                                getDate(order['date']),
                                getAmounts(order['products_and_amounts']),
                                "\$" + order['total'].toString(),
                                order['fulfilled'] ? 'Fulfilled' : 'Pending'
                              ],
                            )).toList().cast<ListElement>(),
                          )),
                          tablet: OrdersPageTablet(listWrapper: ListWrapper(
                            searchType: 'n order',
                            titles: ['Order #', 'Date', 'Amount', 'Total', 'Status'],
                            filterSliders: [2, 3],
                            filterCategories: [4],
                            primaryKey: 0,
                            secondaryKey: 3,
                            elements: snapshot.data.documents.map((order) => ListElement(
                              route: OrderRoute + order.id,
                              object: order,
                              items: [
                                order['order_number'].toString(),
                                //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                                getDate(order['date']),
                                getAmounts(order['products_and_amounts']),
                                "\$" + order['total'].toString(),
                                order['fulfilled'] ? 'Fulfilled' : 'Pending'
                              ],
                            )).toList().cast<ListElement>(),
                          )),
                          mobile: OrdersPageMobile(listWrapper: ListWrapper(
                            searchType: 'n order',
                            titles: ['Order #', 'Date', 'Amount', 'Total', 'Status'],
                            filterSliders: [2, 3],
                            filterCategories: [4],
                            primaryKey: 0,
                            secondaryKey: 3,
                            elements: snapshot.data.documents.map((order) => ListElement(
                              route: OrderRoute + order.id,
                              object: order,
                              items: [
                                order['order_number'].toString(),
                                //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                                getDate(order['date']),
                                getAmounts(order['products_and_amounts']),
                                "\$" + order['total'].toString(),
                                order['fulfilled'] ? 'Fulfilled' : 'Pending'
                              ],
                            )).toList().cast<ListElement>(),
                          ))
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}
