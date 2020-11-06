import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/components/general/row_builder.dart';

class OrderPageDesktop extends StatelessWidget {
  final List<Product> products;
  OrderPageDesktop({this.products});

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
                                  Text('Order #',
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.justify),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 7.0, 0.0, 0.0)),
                                  Text('Date:',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Status:',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Total:',
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
                    Container(
                      width: MediaQuery.of(context).size.width - 200,
                      child: ListWrapper(
                        titles: [
                          'Product',
                          'Inventory',
                          'Type',
                          'Vendor',
                          '# Sold'
                        ],
                        elements: products
                            .map((product) => ListElement(
                                  items: [
                                    product.name,
                                    product.amountInInventory.toString(),
                                    product.type,
                                    product.vendor,
                                    product.amountSold.toString()
                                  ],
                                ))
                            .toList(),
                      ),
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
