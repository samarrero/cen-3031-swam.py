import 'package:flutter/material.dart';
import 'package:swampy/components/general/row_builder.dart';

class ListElement extends StatelessWidget {
  final List<String> items;

  ListElement({this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: RowBuilder(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index]);
        },
      ),
    );
  }
}