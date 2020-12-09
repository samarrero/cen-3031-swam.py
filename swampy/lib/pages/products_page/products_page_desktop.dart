import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/router/route.dart';

class ProductsPageDesktop extends StatefulWidget {
  final ListWrapper listWrapper;

  ProductsPageDesktop({this.listWrapper});

  @override
  _ProductsPageDesktopState createState() => _ProductsPageDesktopState();
}

class _ProductsPageDesktopState extends State<ProductsPageDesktop> {
  // List<Product> products = List<Product>();
  // QuerySnapshot collectionState;
  // ScrollController scrollController = ScrollController();
  //
  // Future<void> getDocuments() async {
  //   var collection = FirebaseFirestore.instance
  //       .collection('products')
  //       .limit(15);
  //   print('getDocuments');
  //   fetchDocuments(collection);
  // }
  //
  // fetchDocuments(Query collection){
  //   collection.get().then((value) {
  //     collectionState = value; // store collection state to set where to start next
  //     value.docs.forEach((element) {
  //       print('getDocuments ${element.data()}');
  //       setState(() {
  //         final data = element.data();
  //         products.add(Product(id: data['id'], name: data['name'], vendor: data['vendor'], price: data['price'], amountInInventory: data['inventory'], type: data['type'], amountSold: data['amount_sold']));
  //       });
  //     });
  //   });
  // }
  //
  // // Fetch next 5 documents starting from the last document fetched earlier
  // Future<void> getDocumentsNext() async {
  //   // Get the last visible document
  //   var lastVisible = collectionState.docs[collectionState.docs.length - 1];
  //   print('listDocument legnth: ${collectionState.size} last: $lastVisible');
  //
  //   var collection = FirebaseFirestore.instance
  //       .collection('products').startAfterDocument(lastVisible).limit(5);
  //
  //   fetchDocuments(collection);
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getDocuments();
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels == 0)
  //         print('ListView scroll at top');
  //       else {
  //         print('ListView scroll at bottom');
  //         getDocumentsNext(); // Load next documents
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                child: Section(
                  title: 'Products',
                  child: widget.listWrapper
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
