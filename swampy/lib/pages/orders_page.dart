import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/pages/orders_page/orders_page_desktop.dart';
import 'package:swampy/pages/orders_page/orders_page_mobile.dart';
import 'package:swampy/pages/orders_page/orders_page_tablet.dart';
import 'package:swampy/data/sample_data.dart';

class OrdersPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                desktop: OrdersPageDesktop(orders: sampleOrders),
                tablet: OrdersPageTablet(orders: sampleOrders),
                mobile: OrdersPageMobile(orders: sampleOrders),
              ))),
    );
  }
}
