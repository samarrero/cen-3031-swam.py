import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/pages/orders_page/orders_page_desktop.dart';
import 'package:swampy/pages/orders_page/orders_page_mobile.dart';
import 'package:swampy/pages/orders_page/orders_page_tablet.dart';

class OrdersPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 7}', '${index + 8}', '${index + 9}'],
          ));

  List<Order> orders = ordersList;

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
              child: ScreenTypeLayout(
                desktop: Container(),
                tablet: Container(),
                mobile: Container(),
              ))),
    );
  }
}
