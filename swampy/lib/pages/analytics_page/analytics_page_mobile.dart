import 'package:flutter/material.dart';
import 'package:swampy/components/general/section.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';

class AnalyticsPageMobile extends StatelessWidget {

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
          title: 'Analytics',
          child: Container(),
        ),
      ),
    );
  }
}