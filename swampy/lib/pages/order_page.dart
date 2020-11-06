import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/pages/order_page/order_page_desktop.dart';
import 'package:swampy/pages/order_page/order_page_mobile.dart';
import 'package:swampy/pages/order_page/order_page_tablet.dart';
import 'package:swampy/models/product.dart';

class OrderPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String id;

  OrderPage({@required this.id});

  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 4}', '${index + 8}', '${index + 12}'],
          ));
  List<Product> products = [
    Product(
        name: 'A',
        vendor: 'A',
        amountInInventory: 5,
        type: 'A',
        amountSold: 1,
        id: 'no',
        price: 0),
    Product(
        name: 'B',
        vendor: 'B',
        amountInInventory: 2,
        type: 'B',
        amountSold: 21,
        id: 'no',
        price: 0),
    Product(
        name: 'C',
        vendor: 'E',
        amountInInventory: 3,
        type: 'C',
        amountSold: 30,
        id: 'no',
        price: 0),
    Product(
        name: 'D',
        vendor: 'G',
        amountInInventory: 76,
        type: 'G',
        amountSold: 1,
        id: 'no',
        price: 0),
    Product(
        name: 'E',
        vendor: 'F',
        amountInInventory: 1,
        type: 'BG',
        amountSold: 22,
        id: 'no',
        price: 0),
    Product(
        name: 'F',
        vendor: 'Z',
        amountInInventory: 67,
        type: 'C',
        amountSold: 3,
        id: 'no',
        price: 0),
    Product(
        name: 'ASDF',
        vendor: 'E',
        amountInInventory: 3,
        type: 'C',
        amountSold: 32,
        id: 'no',
        price: 0),
    Product(
        name: 'OE EFSD',
        vendor: 'G',
        amountInInventory: 76,
        type: 'G',
        amountSold: 1,
        id: 'no',
        price: 0),
    Product(
        name: 'AKEHEF',
        vendor: 'F',
        amountInInventory: 1,
        type: 'BG',
        amountSold: 2,
        id: 'no',
        price: 0),
    Product(
        name: 'FAEYGF',
        vendor: 'Z',
        amountInInventory: 67,
        type: 'C',
        amountSold: 56,
        id: 'no',
        price: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: ScreenTypeLayout(
                desktop: OrderPageDesktop(products: products),
                tablet: OrderPageTablet(sample: sample),
                mobile: OrderPageMobile(sample: sample),
              ))),
    );
  }
}
