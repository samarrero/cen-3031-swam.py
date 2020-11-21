import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/components/general/section.dart';

class HomePageDesktop extends StatelessWidget {
  final List<ListElement> sample;

  HomePageDesktop({this.sample});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: NavBar(),
      ),
      body: SafeArea(
        child: Row(
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
              child: Section(
                  title: 'Top Performing Products',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            elevation: 3.0,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0)),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.0)),
                                        Text('insert product name',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.justify),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 7.0, 0.0, 0.0)),
                                        Text('Price: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Vendor: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Number of Orders: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Total Revenue: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.0)),
                                      ]),
                                ]),
                          ),
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: Text('Pie chart thing'))
                        ],
                      )
                      // Container(
                      //   title:'Recent Orders',
                      //   width: MediaQuery.of(context).size.width - 200,
                      //   child: ListWrapper(
                      //     searchType: 'n order',
                      //     titles: [
                      //       'Order #',
                      //       'Date',
                      //       'Amount',
                      //       'Total',
                      //       'Status'
                      //     ],
                      //       filterSliders: [2, 3],
                      //       filterCategories: [4],
                      //    elements: orders.map((order) => ListElement(
                      //   route: OrderRoute + order.id,
                      //   object: order,
                      //   items: [
                      //     order.orderNumber,
                      //     TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                      //     order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString(),
                      //     order.getAmount().toString(),
                      //     "\$" + order.total.toString(),
                      //     order.fulfilled ? 'Fulfilled' : 'Pending'
                      //   ],
                      //    )).toList(),
                      //   ),
                      // ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
