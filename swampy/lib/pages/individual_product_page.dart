import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/pages/individual_product_page/individual_product_page_desktop.dart';
import 'package:swampy/pages/individual_product_page/individual_product_page_mobile.dart';
import 'package:swampy/pages/individual_product_page/individual_product_page_tablet.dart';

class IndividualProductPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(
      25,
      (index) => ListElement(
            items: ['$index', '${index + 4}', '${index + 8}', '${index + 12}'],
          ));

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: ScreenTypeLayout(
                desktop: IndividualProductPageDesktop(sample: sample),
                tablet: IndividualProductPageTablet(sample: sample),
                mobile: IndividualProductPageMobile(sample: sample),
              ))),
    );
  }
}
