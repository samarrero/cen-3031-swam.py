import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/models/user.dart';
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
                        desktop: ProductPageDesktop(child: ProductDescriptor(document: snapshot.data)),
                        tablet: ProductPageTablet(child: ProductDescriptor(document: snapshot.data)),
                        mobile: ProductPageMobile(child: ProductDescriptor(document: snapshot.data)),
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}

class ProductDescriptor extends StatefulWidget {
  final DocumentSnapshot document;

  ProductDescriptor({this.document});

  @override
  _ProductDescriptorState createState() => _ProductDescriptorState();
}

class _ProductDescriptorState extends State<ProductDescriptor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (_, user, __) {
          if (user == null) {
            return StaticProductDescriptor(document: widget.document);
          } else {
            return EditableProductDescriptor(document: widget.document);
          }
        }
    );
  }
}

class StaticProductDescriptor extends StatelessWidget {
  final DocumentSnapshot document;

  StaticProductDescriptor({this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(document['name'],
              style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),),
            SizedBox(height: 8.0),
            Text('Price: \$' + document['price'].toString(),
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 2.0),
            Text('Vendor: ' + document['vendor'],
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 2.0),
            Text('Type: ' + document['type'],
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 2.0),
            Text('Current Inventory: ' + document['inventory'].toString(),
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 2.0),
            Text('Inventory Ordered: ' + document['amount_sold'].toString(),
                style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 16.0),
            Text('Description:', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
            SizedBox(height: 2.0),
            Text(document['description'], style: Theme.of(context).textTheme.headline5,),
          ],
        ),
      ),
    );
  }
}

class EditableProductDescriptor extends StatefulWidget {
  final DocumentSnapshot document;

  EditableProductDescriptor({this.document});

  @override
  _EditableProductDescriptorState createState() => _EditableProductDescriptorState();
}

class _EditableProductDescriptorState extends State<EditableProductDescriptor> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)),
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.document['name'],
                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),),
                SizedBox(height: 8.0),
                Text('Price: \$' + widget.document['price'].toString(),
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 2.0),
                Text('Vendor: ' + widget.document['vendor'],
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 2.0),
                Text('Type: ' + widget.document['type'],
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 2.0),
                Text('Current Inventory: ' + widget.document['inventory'].toString(),
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 2.0),
                Text('Inventory Ordered: ' + widget.document['amount_sold'].toString(),
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(height: 16.0),
                Text('Description:', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
                SizedBox(height: 2.0),
                Text(widget.document['description'], style: Theme.of(context).textTheme.headline5,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Edit', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}


