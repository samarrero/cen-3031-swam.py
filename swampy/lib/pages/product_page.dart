import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/input_field.dart';
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
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('products').doc(ModalRoute.of(context).settings.name.substring(9)).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ScreenTypeLayout(
                        desktop: ProductPageDesktop(child: ProductBody(document: snapshot.data, scaffoldKey: _scaffoldKey)),
                        tablet: ProductPageTablet(child: ProductBody(document: snapshot.data, scaffoldKey: _scaffoldKey)),
                        mobile: ProductPageMobile(child: ProductBody(document: snapshot.data, scaffoldKey: _scaffoldKey)),
                      );
                    }
                    else return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)));
                  }
              ))),
    );
  }
}

class ProductBody extends StatelessWidget {
  final DocumentSnapshot document;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductBody({this.document, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductDescriptor(document: document, scaffoldKey: scaffoldKey),
          SizedBox(height: 12.0),
          MediaQuery.of(context).size.width >= 950 ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                elevation: 3.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Text('Current Inventory: ' + document['inventory'].toString(), style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold))
                ),
              ),
              SizedBox(width: 8.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                elevation: 3.0,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Text('Amount Sold: ' + document['amount_sold'].toString(), style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold))
                ),
              )
            ],
          ) : SizedBox.shrink(),
            // Column(
            //       children: [
            //         Card(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16.0)),
            //           elevation: 3.0,
            //           child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            //               child: ConstrainedBox(
            //                   constraints: BoxConstraints(
            //                     minWidth: MediaQuery.of(context).size.width
            //                   ),
            //                   child: Center(child: Text('Current Inventory: ' + document['inventory'].toString(), style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)))
            //               )
            //           ),
            //         ),
            //         Card(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16.0)),
            //           elevation: 3.0,
            //           child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            //               child: ConstrainedBox(
            //                   constraints: BoxConstraints(
            //                       minWidth: MediaQuery.of(context).size.width
            //                   ),
            //                 child: Center(child: Text('Amount Sold: ' + document['amount_sold'].toString(), style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold)))
            //             )
            //           ),
            //         )
            //       ],
            //     )
        ],
      ),
    );
  }
}


class ProductDescriptor extends StatefulWidget {
  final DocumentSnapshot document;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductDescriptor({this.document, this.scaffoldKey});

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
            return EditableProductDescriptor(document: widget.document, scaffoldKey: widget.scaffoldKey);
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
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Card(
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
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                      children: [
                        TextSpan(text: 'Price'),
                        TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                        TextSpan(text: '\$' + document['price'].toString(), style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                      ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                      children: [
                        TextSpan(text: 'Type'),
                        TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                        TextSpan(text: document['type'], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                      ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                      children: [
                        TextSpan(text: 'Vendor'),
                        TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                        TextSpan(text: document['vendor'], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                      ]
                  ),
                ),
                MediaQuery.of(context).size.width < 950 ? RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                      children: [
                        TextSpan(text: 'Current Inventory'),
                        TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                        TextSpan(text: document['inventory'].toString(), style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                      ]
                  ),
                ) : SizedBox.shrink(),
                MediaQuery.of(context).size.width < 950 ? RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                      children: [
                        TextSpan(text: 'Amount Sold'),
                        TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                        TextSpan(text: document['amount_sold'].toString(), style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                      ]
                  ),
                ) : SizedBox.shrink(),
                SizedBox(height: 16.0),
                Text('Description:', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold, height: 1.5)),
                SizedBox(height: 2.0),
                Text(document['description'], style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditableProductDescriptor extends StatefulWidget {
  final DocumentSnapshot document;
  final GlobalKey<ScaffoldState> scaffoldKey;

  EditableProductDescriptor({this.document, this.scaffoldKey});

  @override
  _EditableProductDescriptorState createState() => _EditableProductDescriptorState();
}

class _EditableProductDescriptorState extends State<EditableProductDescriptor> {
  bool _isEditing = false;
  bool _isLoading = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.document['name'],
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                            children: [
                              TextSpan(text: 'Price'),
                              TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                              TextSpan(text: '\$' + widget.document['price'].toString(), style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                            children: [
                              TextSpan(text: 'Type'),
                              TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                              TextSpan(text: widget.document['type'], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
                            children: [
                              TextSpan(text: 'Vendor'),
                              TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                              TextSpan(text: widget.document['vendor'], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                            ]
                        ),
                      ),
                      SizedBox(height: 16.0),
                      AnimatedCrossFade(
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description:', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold, height: 1.5),),
                            SizedBox(height: 2.0),
                            Text(widget.document['description'], style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),),
                          ],
                        ),
                        secondChild: _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor))) : InputField(text: 'Description', type: InputType.Multiline, controller: _textEditingController),
                        crossFadeState: _isEditing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 150),
                        firstCurve: Curves.easeIn,
                        secondCurve: Curves.easeOut
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0, right: 32.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(_isEditing ? 'Done' : 'Edit', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                      if (_isEditing == false) {
                        _isLoading = true;
                        try {
                          FirebaseFirestore.instance.collection('products').doc(
                              ModalRoute.of(context).settings.name.substring(9)).update({
                            'description': _textEditingController.value.text
                          }).then((val) {

                            widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Colors.grey[800],
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                                  child: Text('Successfully updated the description.', style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                                )
                            ));
                          });
                        } catch (e) {
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: Colors.grey[800],
                              content: Padding(
                                padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                                child: Text('Sorry, an error occurred: $e', style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                              )
                          ));
                        }
                        _isLoading = false;
                      } else {
                        _textEditingController.text = widget.document['description'];
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


