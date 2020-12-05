import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/pages/home_page/home_page_desktop.dart';
import 'package:swampy/pages/home_page/home_page_mobile.dart';
import 'package:provider/provider.dart';
import 'package:swampy/pages/home_page/home_page_tablet.dart';
import 'package:swampy/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(25, (index) => ListElement(items: ['$index', '${index + 1}', '${index + 2}', '${index + 3}'],));

  Future<List<dynamic>> getTopProductsAndRecentOrders() async {
    var top5 = await FirebaseFirestore.instance.collection('products').orderBy('amount_sold', descending: true).limit(5).get();
    var recentOrders = await FirebaseFirestore.instance.collection('orders').orderBy('date', descending: true).limit(3).get();
    var top5List = [];
    var recentOrdersList = [];
    for (var doc in top5.docs) {
      top5List.add(doc.data());
    }
    for (var doc in recentOrders.docs) {
      recentOrdersList.add(doc.data());
    }
    return [top5List, recentOrdersList];
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>
          Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                    return;
                  },
                  child: FutureBuilder(
                    future: getTopProductsAndRecentOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ScreenTypeLayout(
                          desktop: HomePageDesktop(topProducts: snapshot.data[0], recentOrders: snapshot.data[1]),
                          tablet: HomePageTablet(sample: sample),
                          mobile: HomePageMobile(sample: sample),
                        );
                      } else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                    },
                  )
              )
          ),
    );
  }
}