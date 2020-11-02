import 'package:flutter/material.dart';
import 'package:swampy/components/general/row_builder.dart';

class ListElement extends StatelessWidget {
  final List<String> items;

  ListElement({this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0)
      ),
      elevation: 3.0,
      child: RowBuilder(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
                items[index],
                style: Theme.of(context).textTheme.headline6,
            ),
          );
        },
      ),
    );
  }
}