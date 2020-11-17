import 'package:flutter/material.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/router/route.dart';

class ProductsPageMobile extends StatelessWidget {
  final List<Product> products;

  ProductsPageMobile({this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: NavBar.mobile(),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SideMenu(),
        ),
      ),
      body: SafeArea(
        child: Section(
          title: 'Products',
          child: ListWrapper(
            searchType: ' product',
            titles: ['Product', 'Inventory', 'Type', 'Vendor', '# Sold'],
            filterSliders: [1, 4],
            filterCategories: [2, 3],
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
      ),
    );
  }
}
