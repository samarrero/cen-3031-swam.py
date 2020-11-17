import 'package:flutter/material.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/router/route.dart';

class OrdersPageMobile extends StatelessWidget {
  final List<Order> orders;

  OrdersPageMobile({this.orders});

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
          title: 'Orders',
          child: ListWrapper(
            searchType: 'n order',
            titles: ['Order #', 'Date', 'Amount', 'Total', 'Status'],
            filterSliders: [2, 3],
            filterCategories: [4],
            primaryKey: 0,
            secondaryKey: 3,
            elements: orders.map((order) => ListElement(
              route: OrderRoute + order.id,
              object: order,
              items: [
                order.orderNumber,
                //TODO: SORTING NUMERICAL VALUES ARE INCORRECT, SORTING BY STRING INSTEAD
                order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString(),
                order.getAmount().toString(),
                "\$" + order.total.toString(),
                order.fulfilled ? 'Fulfilled' : 'Pending'
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }
}
