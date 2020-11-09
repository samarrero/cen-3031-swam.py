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
  final List<Product> products;

  ProductsPageDesktop({this.products});

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
                  child: ListWrapper(
                    titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
                    elements: products.map((product) => ListElement(
                      route: IndividualProductRoute + product.id,
                      object: product,
                      items: [
                        product.name,
                        product.amountInInventory.toString(),
                        product.type,
                        product.vendor,
                        product.amountSold.toString()
                      ],
                    )).toList(),
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
