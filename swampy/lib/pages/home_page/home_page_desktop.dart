import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/row_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/router/route.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fluro/fluro.dart' as fluro;

class ChartData {
  ChartData({this.x, this.y, this.color});
  final String x;
  final double y;
  final Color color;
}

class HomePageDesktop extends StatelessWidget {
  final List<dynamic> topProducts;
  final List<dynamic> recentOrders;

  HomePageDesktop({this.topProducts, this.recentOrders});

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
    List<String> ordersTitles = ['Order #', 'Date', 'Amount', 'Total', 'Status'];

    Map<String, Color> coloredData = {
      topProducts[0]['name'] : Theme.of(context).primaryColor,
      topProducts[1]['name'] : Color.fromRGBO(87, 131, 229, 1),
      topProducts[2]['name'] : Color.fromRGBO(138, 174, 255, 1),
      topProducts[3]['name'] : Color.fromRGBO(187, 208, 255, 1),
      topProducts[4]['name'] : Color.fromRGBO(212, 225, 255, 1)
    };

    final List<ChartData> chartData = <ChartData>[
      ChartData(x: topProducts[0]['name'], y: topProducts[0]['amount_sold'], color: Theme.of(context).primaryColor),
      ChartData(x: topProducts[1]['name'], y: topProducts[1]['amount_sold'], color: Color.fromRGBO(87, 131, 229, 1)),
      ChartData(x: topProducts[2]['name'], y: topProducts[2]['amount_sold'], color: Color.fromRGBO(138, 174, 255, 1)),
      ChartData(x: topProducts[3]['name'], y: topProducts[3]['amount_sold'], color: Color.fromRGBO(187, 208, 255, 1)),
      ChartData(x: topProducts[4]['name'], y: topProducts[4]['amount_sold'], color: Color.fromRGBO(212, 225, 255, 1)),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: NavBar(),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SideMenu(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Section(
                        capHeight: 380,
                        title: 'Top Performing Products',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              elevation: 3.0,
                              child: InkWell(
                                onTap: () {
                                  FluroRouter.router.navigateTo(
                                      context,
                                      IndividualProductRoute + this.topProducts[0]['id'],
                                      transition: fluro.TransitionType.fadeIn,
                                      transitionDuration: Duration(milliseconds: 150));
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 300,
                                    maxWidth: 300
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(this.topProducts[0]['name'], style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text('Price: \$${this.topProducts[0]['price']}', style: Theme.of(context).textTheme.headline5),
                                        Text('Vendor: ${this.topProducts[0]['vendor']}', style: Theme.of(context).textTheme.headline5),
                                        Text('Orders: ${this.topProducts[0]['amount_sold']}', style: Theme.of(context).textTheme.headline5),
                                        Text('Revenue: \$${this.topProducts[0]['price'] * this.topProducts[0]['amount_sold']}', style: Theme.of(context).textTheme.headline5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 310,
                              height: 310,
                              child: SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      color: Colors.grey[800],
                                      textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white)
                                  ),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Container(
                                        child: PhysicalModel(
                                          child: Container(),
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      )
                                    ),
                                    CircularChartAnnotation(
                                        widget: ColumnBuilder(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          itemCount: topProducts.length,
                                          itemBuilder: (context, index) {
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: 160
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: coloredData[topProducts[index]['name']]
                                                      ),
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    SizedBox(width: 8.0),
                                                    Flexible(
                                                        fit: FlexFit.loose,
                                                        child: Text(topProducts[index]['name'],
                                                            style: Theme.of(context).textTheme.headline5,
                                                            overflow: TextOverflow.ellipsis)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    )
                                  ],
                                  series: <CircularSeries>[
                                    // Renders doughnut chart
                                    DoughnutSeries<ChartData, String>(
                                        dataSource: chartData,
                                        // startAngle: 30,
                                        // endAngle: 30,
                                        innerRadius: '115',
                                        radius: '155',
                                        pointColorMapper:(ChartData data,  _) => data.color,
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                    )
                                  ]
                              ),
                            )
                          ],
                        )
                    ),
                    Section(
                        capHeight: 180,
                        title: 'Recent Orders',
                        child: Column(
                          children: [
                            RowBuilder(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                itemCount: ordersTitles.length,
                                itemBuilder: (context, index) {
                                  return Container(width: (MediaQuery.of(context).size.width - 200) * 0.11, child: Center(child: Text(ordersTitles[index], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)));
                                },
                            ),
                            SizedBox(height: 8.0),
                            ColumnBuilder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return ListElement(
                                  route: OrderRoute + this.recentOrders[index]['id'],
                                  object: this.recentOrders[index],
                                  items: [
                                    this.recentOrders[index]['order_number'].toString(),
                                    //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                                    getDate(this.recentOrders[index]['date']),
                                    getAmounts(this.recentOrders[index]['products_and_amounts']),
                                    "\$" + this.recentOrders[index]['total'].toString(),
                                    this.recentOrders[index]['fulfilled'] ? 'Fulfilled' : 'Pending'
                                  ],
                                );
                              },
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
