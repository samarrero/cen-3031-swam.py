import 'package:flutter/material.dart';
import 'dart:math';

enum Sort {
  none,
  ascending,
  descending
}

class ListCategory extends StatelessWidget {
  final String name;
  final Sort sort;

  const ListCategory({@required this.name, this.sort = Sort.none});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(this.name, style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 4.0),
          sort == Sort.ascending ? Transform.rotate(
            angle: 270 * pi / 180,
            child: Icon(Icons.arrow_right_alt_rounded, size: 16.0,)
          ) :
          sort == Sort.descending ? Transform.rotate(
              angle: 90 * pi / 180,
              child: Icon(Icons.arrow_right_alt_rounded, size: 16.0,)
          ) : Icon(
            Icons.height_rounded,
            size: 16.0,
          )
        ],
      ),
    );
  }
}