import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/components/general/row_builder.dart';
import 'package:swampy/router/route_names.dart';

class OrderPageDesktop extends StatelessWidget {
  final Column column;

  OrderPageDesktop({this.column});

  @override
  Widget build(BuildContext context) {
    //
    // Order orderInfo = order != null
    //     ? order :
    // Order(id: 'null', orderNumber: null, date: DateTime(0), productsAndAmount: Map<Product, int>(), total: -1, fulfilled: false);
    //
    // List<ListElement> productsList = [];
    // for(var product in orderInfo.productsAndAmount.keys) {
    //   productsList.add(
    //       ListElement(
    //         route: IndividualProductRoute + product.id,
    //         object: product,
    //         items: [
    //           product.name,
    //           orderInfo.productsAndAmount[product].toString(),
    //           product.type,
    //           product.price.toString(),
    //           product.vendor,
    //         ],
    //       )
    //   );
    // }

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
                child: this.column,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
