import 'package:flutter/material.dart';
import 'package:swampy/components/list/list_element.dart';

class HomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListElement(items: ['T-Shirt', '45', 'T-Shirt', 'T-Shirt Co.', '5']);
  }
}