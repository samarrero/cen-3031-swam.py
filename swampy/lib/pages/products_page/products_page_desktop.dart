import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/router/route.dart';

class ProductsPageDesktop extends StatelessWidget {
  List<Product> products = List<Product>();

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
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('products').get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Something went wrong.', style: Theme.of(context).textTheme.headline4,
                        ));
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        for (var data in snapshot.data.docs) {
                          products.add(Product(id: data.id, name: data.data()['name'], vendor: data.data()['vendor'], price: double.parse(data.data()['price']), amountInInventory: int.parse(data.data()['inventory']), type: data.data()['type'], amountSold: int.parse(data.data()['amount_sold'])));
                        }
                        return ListWrapper(
                          searchType: ' product',
                          titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
                          filterSliders: [1, 4],
                          filterCategories: [2, 3],
                          elements: products.map((product) => ListElement(
                            route: IndividualProductRoute + product.id,
                            object: product,
                            id: product.id,
                            items: [
                              product.name,
                              product.amountInInventory.toString(),
                              product.type,
                              product.vendor,
                              product.amountSold.toString()
                            ],
                          )).toList(),
                        );
                      }
                      return Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                              strokeWidth: 8.0,
                            ),
                          )
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
