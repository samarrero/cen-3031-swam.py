import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';

class ProductPageDesktop extends StatelessWidget {
  final List<ListElement> sample;

  ProductPageDesktop({this.sample});

  @override
  Widget build(BuildContext context) {

    List<String> productInfo = ModalRoute.of(context).settings.arguments != null
        ? ModalRoute.of(context).settings.arguments as List<String> : [];

    return Scaffold(
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
              child: ListView.builder(
                itemCount: productInfo.length,
                itemBuilder: (context, index) => Text(productInfo[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
