import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class AnalyticsPageMobile extends StatelessWidget {
  final Map<String, Color> donutColors;
  final donutData;
  final ordersData;

  AnalyticsPageMobile({this.donutColors, this.donutData, this.ordersData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: NavBar.mobile(),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SideMenu(),
        ),
      ),
      body: SafeArea(
        child: Section(
          title: 'Analytics',
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Best Performing Products', style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 24.0),
                SfCircularChart(
                    tooltipBehavior: TooltipBehavior(
                        enable: true,
                        color: Colors.grey[800],
                        textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white)
                    ),
                    // title: ChartTitle(text: 'Best Performing Products', textStyle: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold)),
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
                          itemCount: donutData.length,
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
                                          color: donutColors[donutData[index].x]
                                      ),
                                      width: 16,
                                      height: 16,
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(donutData[index].x,
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
                      DoughnutSeries(
                        dataSource: donutData,
                        // startAngle: 30,
                        // endAngle: 30,
                        innerRadius: '115',
                        radius: '155',
                        pointColorMapper:(data,  _) => data.color,
                        xValueMapper: (data, _) => data.x,
                        yValueMapper: (data, _) => data.y,
                      )
                    ]
                ),
                SizedBox(height: 48.0),
                Text('Total Sales Over Time', style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 2.0),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: 500
                  ),
                  child: SfCartesianChart(
                      primaryYAxis: NumericAxis(
                        //Formatting the labels in locale’s currency pattern with symbol.
                        numberFormat: NumberFormat.currency(
                            locale: 'en_US',
                            symbol: "\$"
                        ),
                      ),
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      // title: ChartTitle(text: 'Total Sales over Time', textStyle: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold)),
                      // Enable legend
                      legend: Legend(isVisible: true, position: LegendPosition.bottom),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          color: Colors.grey[800],
                          textStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal, color: Colors.white)
                      ),
                      series: [
                        AreaSeries(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Theme.of(context).primaryColor, Color.fromRGBO(212, 225, 255, 1)],//donutColors.values.toList().sublist(2, 5),
                              stops: [0, 1],
                            ),
                            // trendlines: [
                            //   Trendline(type: TrendlineType.linear, color: Colors.redAccent, name: "Trendline")
                            // ],
                            // borderWidth: 1,
                            // borderColor: donutColors.values.toList()[2],
                            name: 'Revenue',
                            color: Theme.of(context).primaryColor,
                            dataSource: ordersData,
                            xValueMapper: (sales, _) => sales.x,
                            yValueMapper: (sales, _) => sales.y,
                            // Enable data label
                            dataLabelSettings: DataLabelSettings(isVisible: false))
                      ]),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}