import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/product.dart';

class ProductPageDesktop extends StatelessWidget {
  final List<ListElement> sample;

  ProductPageDesktop({this.sample});

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
                            FutureBuilder(
                              future: FirebaseFirestore.instance.collection('products').doc(ModalRoute.of(context).settings.name.substring(9)).get(),
                              builder: (context, snapshot) {
                                print(ModalRoute.of(context).settings.name.substring(9));

                                if (snapshot.hasData) {
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                vertical: 7.0)),
                                        Text(snapshot.data['name'],
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify),

                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 7.0, 0.0, 0.0)),
                                        Text('Price: \$' +
                                            snapshot.data['price'],
                                            // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Vendor: ' +
                                            snapshot.data['vendor'],
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Type: ' + snapshot.data['type'],
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Current Inventory: ' +
                                            snapshot.data['inventory'],
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Text('Inventory Ordered: ' +
                                            snapshot.data['amount_sold'],
                                            style:
                                            Theme
                                                .of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.justify),
                                        Padding(
                                            padding:
                                            EdgeInsets.symmetric(
                                                vertical: 7.0)),
                                      ]);
                                }

                                else return Container();
                              }
                            ),
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
