import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';

class OrdersPageDesktop extends StatelessWidget {
  final List<ListElement> sample;

  OrdersPageDesktop({this.sample});

  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.of(context).size.height - 200,
              child: ListView.builder(
                itemCount: sample.length,
                itemBuilder: (context, index) => sample[index],
              ),
            )
          ],
        ),
      ),
    );
  }
}
