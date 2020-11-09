import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/pages/product_page/product_page_desktop.dart';
import 'package:swampy/pages/product_page/product_page_mobile.dart';
import 'package:swampy/pages/product_page/product_page_tablet.dart';

//TODO: Product Page will have Product object passed in based on ID routing

class ProductPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String id;
  final Product product;

  ProductPage({@required this.id, @required this.product});

  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 4}', '${index + 8}', '${index + 12}'],
          ));


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
                desktop: ProductPageDesktop(product: product),
                tablet: ProductPageTablet(sample: sample),
                mobile: ProductPageMobile(sample: sample),
              ))),
    );
  }
}
