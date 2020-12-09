import 'package:cloud_firestore/cloud_firestore.dart';
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
              child: FutureBuilder(
                  future: FirebaseFirestore.instance.collection('products').doc(ModalRoute.of(context).settings.name.substring(9)).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ScreenTypeLayout(
                        desktop: ProductPageDesktop(column: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              Text(snapshot.data['name'],
                                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0)),
                              Text('Price: \$' + snapshot.data['price'].toString(),
                                  // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Vendor: ' + snapshot.data['vendor'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Type: ' + snapshot.data['type'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Current Inventory: ' + snapshot.data['inventory'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Inventory Ordered: ' + snapshot.data['amount_sold'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            ])),
                        tablet: ProductPageTablet(column: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              Text(snapshot.data['name'],
                                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0)),
                              Text('Price: \$' + snapshot.data['price'].toString(),
                                  // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Vendor: ' + snapshot.data['vendor'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Type: ' + snapshot.data['type'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Current Inventory: ' + snapshot.data['inventory'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Inventory Ordered: ' + snapshot.data['amount_sold'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            ])),
                        mobile: ProductPageMobile(column: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                              Text(snapshot.data['name'],
                                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0)),
                              Text('Price: \$' + snapshot.data['price'].toString(),
                                  // order.date.month.toString() + "/" + order.date.day.toString() + "/" + order.date.year.toString()
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Vendor: ' + snapshot.data['vendor'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Type: ' + snapshot.data['type'],
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Current Inventory: ' + snapshot.data['inventory'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Text('Inventory Ordered: ' + snapshot.data['amount_sold'].toString(),
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.justify),
                              Padding(padding: EdgeInsets.symmetric(vertical: 7.0)),
                            ])),
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}
