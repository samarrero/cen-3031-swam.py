import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/pages/analytics_page/analytics_page_desktop.dart';
import 'package:swampy/pages/analytics_page/analytics_page_mobile.dart';
import 'package:swampy/pages/analytics_page/analytics_page_tablet.dart';

class ChartData {
  ChartData({this.x, this.y, this.color});
  final String x;
  final double y;
  final Color color;
}

class AnalyticsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<dynamic>> getTopProductsAndRecentOrders() async {
    var top5 = await FirebaseFirestore.instance.collection('products').orderBy('amount_sold', descending: true).limit(5).get();
    var orders = await FirebaseFirestore.instance.collection('orders').orderBy('date').get();
    var top5List = [];
    var ordersList = [];
    for (var doc in top5.docs) {
      top5List.add(doc.data());
    }
    for (var doc in orders.docs) {
      ordersList.add(doc.data());
    }
    return [top5List, ordersList];
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
              child: FutureBuilder(
                future: getTopProductsAndRecentOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var parsedData = {};

                    for (var d in snapshot.data[1]) {
                      var date = getDate(d['date']);
                      if (parsedData.containsKey(date)) {
                        parsedData[date] += d['total'];
                      } else {
                        parsedData[date] = d['total'];
                      }
                    }

                    var sums = [];
                    for (var d in parsedData.keys) {
                      sums.add(parsedData[d]);
                    }

                    for (int i = 1; i < sums.length; i++) {
                      sums[i] += sums[i - 1];
                    }
                    int i = 0;
                    for (var d in parsedData.keys) {
                      parsedData[d] = sums[i];
                      i++;
                    }

                    return ScreenTypeLayout(
                      desktop: AnalyticsPageDesktop(
                          donutColors: {
                            snapshot.data[0][0]['name'] : Theme.of(context).primaryColor,
                            snapshot.data[0][1]['name'] : Color.fromRGBO(87, 131, 229, 1),
                            snapshot.data[0][2]['name'] : Color.fromRGBO(138, 174, 255, 1),
                            snapshot.data[0][3]['name'] : Color.fromRGBO(187, 208, 255, 1),
                            snapshot.data[0][4]['name'] : Color.fromRGBO(212, 225, 255, 1)
                          },
                          donutData: [
                            ChartData(x: snapshot.data[0][0]['name'], y: snapshot.data[0][0]['amount_sold'], color: Theme.of(context).primaryColor),
                            ChartData(x: snapshot.data[0][1]['name'], y: snapshot.data[0][1]['amount_sold'], color: Color.fromRGBO(87, 131, 229, 1)),
                            ChartData(x: snapshot.data[0][2]['name'], y: snapshot.data[0][2]['amount_sold'], color: Color.fromRGBO(138, 174, 255, 1)),
                            ChartData(x: snapshot.data[0][3]['name'], y: snapshot.data[0][3]['amount_sold'], color: Color.fromRGBO(187, 208, 255, 1)),
                            ChartData(x: snapshot.data[0][4]['name'], y: snapshot.data[0][4]['amount_sold'], color: Color.fromRGBO(212, 225, 255, 1)),
                          ],
                          ordersData: parsedData.keys.map((time) => ChartData(
                            x: time,
                            y: parsedData[time],
                            color: Theme.of(context).primaryColor
                          )).toList()
                      ),
                      tablet: AnalyticsPageTablet(),
                      mobile: AnalyticsPageMobile(),
                    );
                  } else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                },
              ))),
    );
  }
}
