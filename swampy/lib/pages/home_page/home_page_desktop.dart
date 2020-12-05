import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/router/route.dart';

class HomePageDesktop extends StatelessWidget {
  final List<dynamic> topProducts;
  final List<dynamic> recentOrders;

  HomePageDesktop({this.topProducts, this.recentOrders});

  @override
  Widget build(BuildContext context) {
    List<Order> sortedOrders = List.from(ordersList);
    sortedOrders.sort((a, b) => a.date.isBefore(b.date) ? 1 : -1);

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Section(
                        title: 'Top Performing Products',
                        child: Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              elevation: 3.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(this.topProducts[0]['name'], style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)),
                                    Text('Price: \$${this.topProducts[0]['price']}', style: Theme.of(context).textTheme.headline5),
                                    Text('Vendor: ${this.topProducts[0]['vendor']}', style: Theme.of(context).textTheme.headline5),
                                    Text('Orders: ${this.topProducts[0]['amount_sold']}', style: Theme.of(context).textTheme.headline5),
                                    Text('Revenue: \$${this.topProducts[0]['price'] * this.topProducts[0]['amount_sold']}', style: Theme.of(context).textTheme.headline5),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: Container(
                                color: Colors.red,
                                width: 300,
                                height: 300,
                              ),
                            )
                          ],
                        )
                    ),
                    Section(
                        title: 'Recent Orders',
                        child: ColumnBuilder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ListElement(
                              route: OrderRoute + sortedOrders[index].id,
                              object: sortedOrders[index],
                              items: [
                                sortedOrders[index].orderNumber.toString(),
                                //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                                sortedOrders[index].date.month.toString() + "/" + sortedOrders[index].date.day.toString() + "/" + sortedOrders[index].date.year.toString(),
                                sortedOrders[index].getAmount().toString(),
                                "\$" + sortedOrders[index].total.toString(),
                                sortedOrders[index].fulfilled ? 'Fulfilled' : 'Pending'
                              ],
                            );
                          },
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
