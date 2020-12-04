import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/pages/products_page/products_page_desktop.dart';
import 'package:swampy/pages/products_page/products_page_mobile.dart';
import 'package:swampy/pages/products_page/products_page_tablet.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/router/route_names.dart';

class ProductsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              child : StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ScreenTypeLayout(
                        desktop: ProductsPageDesktop(listWrapper: ListWrapper(
                          searchType: ' product',
                          titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
                          filterSliders: [1, 4],
                          filterCategories: [2, 3],
                          // scrollController: scrollController,
                          elements: snapshot.data.documents.map((product) => ListElement(
                            route: IndividualProductRoute + product.id,
                            object: product,
                            id: product.id,
                            items: [
                              product['name'],
                              product['inventory'].toString(),
                              product['type'],
                              product['vendor'],
                              product['amount_sold'].toString()
                            ],
                          )).toList().cast<ListElement>(),
                        )),
                        tablet: ProductsPageTablet(listWrapper: ListWrapper(
                          searchType: ' product',
                          titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
                          filterSliders: [1, 4],
                          filterCategories: [2, 3],
                          primaryKey: 0,
                          secondaryKey: 4,
                          // scrollController: scrollController,
                          elements: snapshot.data.documents.map((product) => ListElement(
                            route: IndividualProductRoute + product.id,
                            object: product,
                            id: product.id,
                            items: [
                              product['name'],
                              product['inventory'].toString(),
                              product['type'],
                              product['vendor'],
                              product['amount_sold'].toString()
                            ],
                          )).toList().cast<ListElement>(),
                        )),
                        mobile: ProductsPageMobile(listWrapper: ListWrapper(
                          searchType: ' product',
                          titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
                          filterSliders: [1, 4],
                          filterCategories: [2, 3],
                          primaryKey: 0,
                          secondaryKey: 4,
                          // scrollController: scrollController,
                          elements: snapshot.data.documents.map((product) => ListElement(
                            route: IndividualProductRoute + product.id,
                            object: product,
                            id: product.id,
                            items: [
                              product['name'],
                              product['inventory'].toString(),
                              product['type'],
                              product['vendor'],
                              product['amount_sold'].toString()
                            ],
                          )).toList().cast<ListElement>(),
                        ))
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              )
              )),
    );
  }
}
