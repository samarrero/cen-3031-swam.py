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
  final Order order;

  OrderPageDesktop({this.order});

  @override
  Widget build(BuildContext context) {

    Order orderInfo = order != null
        ? order :
    Order(id: 'null', orderNumber: 'null', date: DateTime(0), productsAndAmount: Map<Product, int>(), total: -1, fulfilled: false);

    List<ListElement> productsList = [];
    for(var product in orderInfo.productsAndAmount.keys) {
      productsList.add(
          ListElement(
            route: IndividualProductRoute + product.id,
            object: product,
            items: [
              product.name,
              orderInfo.productsAndAmount[product].toString(),
              product.type,
              product.price.toString(),
              product.vendor,
            ],
          )
      );
    }

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
                                  Text('Order #' + orderInfo.orderNumber,
                                      style:
                                        Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.justify),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 7.0, 0.0, 0.0)),
                                  Text('Date: ' + orderInfo.date.toString(),
                                      // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Status: ' + (orderInfo.fulfilled ? 'Fulfilled' : 'Pending'),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.justify),
                                  Text('Total: \$' + orderInfo.total.toString(),
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
                        searchType: ' product',
                        titles: [
                          'Product',
                          'Amount',
                          'Type',
                          'Price',
                          'Vendor'
                        ],
                          filterSliders: [1, 3],
                          filterCategories: {
                            'Type' : ['Hat', 'Shirt', 'Pants', 'Shoes', 'Jacket'],
                            'Other Thing' : ['Hello', 'From', 'The', 'Other', 'Side']
                          },
                        elements: productsList
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
