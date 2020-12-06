import 'package:flutter/material.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_wrapper.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/data/data.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/router/route.dart';

class OrdersPageMobile extends StatelessWidget {
  final ListWrapper listWrapper;

  OrdersPageMobile({this.listWrapper});

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
          title: 'Orders',
          child: this.listWrapper,
        ),
      ),
    );
  }
}
