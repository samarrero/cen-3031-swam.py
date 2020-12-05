import 'package:flutter/material.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';

class ProductPageMobile extends StatelessWidget {
  final Column column;

  ProductPageMobile({this.column});

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
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: this.column,
            )
        ),
      ),
    );
  }
}
