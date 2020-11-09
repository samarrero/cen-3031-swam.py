import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/router/route_names.dart';

class OrdersPageDesktop extends StatelessWidget {
  final List<Order> orders;

  OrdersPageDesktop({this.orders});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                  title: 'Orders',
                  child: ListWrapper(
                    searchType: 'n order',
                    titles: ['Order #', 'Date', 'Amount', 'Total', 'Status'],
                    filterSliders: [2],
                    filterCategories: {
                      'Type' : ['Hat', 'Shirt', 'Pants', 'Shoes', 'Jacket'],
                      'Other Thing' : ['Hello', 'From', 'The', 'Other', 'Side']
                    },
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
