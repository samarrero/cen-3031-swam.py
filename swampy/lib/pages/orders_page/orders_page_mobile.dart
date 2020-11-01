import 'package:flutter/material.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';

class OrdersPageMobile extends StatelessWidget {
  final List<ListElement> sample;

  OrdersPageMobile({this.sample});

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
        child: ListView.builder(
          itemCount: sample.length,
          itemBuilder: (context, index) => sample[index],
        ),
      ),
    );
  }
}
