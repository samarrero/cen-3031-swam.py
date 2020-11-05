import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/components/menus/side_menu.dart';
import 'package:swampy/components/general/row_builder.dart';

class OrderPageDesktop extends StatelessWidget {
  final List<ListElement> sample;

  OrderPageDesktop({this.sample});

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      elevation: 3.0,
                      child: Row(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Order #', style: Theme.of(context).textTheme.bodyText2),
                              Text('Date'),
                              Text('Status'),
                              Text('Total'),
                            ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Customer Info'),
                            ])
                      ]),
                    ),
                    ColumnBuilder(
                      itemCount: sample.length,
                      itemBuilder: (context, index) => sample[index],
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
