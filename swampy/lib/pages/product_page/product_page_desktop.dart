import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/product.dart';

class ProductPageDesktop extends StatelessWidget {
  final List<ListElement> sample;
  final Product product;

  ProductPageDesktop({this.sample, this.product});

  @override
  Widget build(BuildContext context) {

    Product productInfo = product != null
        ? product :
    Product(id: 'null', name: 'null', vendor: 'null', price: -1, amountInInventory: -1, type: 'null', amountSold: -1);

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
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      elevation: 3.0,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 15.0)),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 7.0)),
                                  Text(productInfo.name,
                                      style:
                                      Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.justify),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 7.0, 0.0, 0.0)),
                                  Text('Price: \$' + productInfo.price.toString(),
                                      // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Vendor: ' + productInfo.vendor,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Type: ' + productInfo.type,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Current Inventory: ' + productInfo.amountInInventory.toString(),
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Inventory Ordered: ' + productInfo.amountInInventory.toString(),
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 7.0)),
                                ]),
                            // Padding(
                            //     padding:
                            //         EdgeInsets.symmetric(horizontal: 100.0)),
                            // Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 7.0, horizontal: 15.0)),
                            //       Text('Customer Information',
                            //           style:
                            //               Theme.of(context).textTheme.headline5,
                            //           textAlign: TextAlign.start),
                            //       Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 7.0, horizontal: 15.0)),
                            //     ]),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
