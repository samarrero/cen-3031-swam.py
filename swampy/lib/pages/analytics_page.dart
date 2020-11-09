import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/pages/analytics_page/analytics_page_desktop.dart';
import 'package:swampy/pages/analytics_page/analytics_page_mobile.dart';
import 'package:swampy/pages/analytics_page/analytics_page_tablet.dart';


class AnalyticsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                desktop: AnalyticsPageDesktop(),
                tablet: AnalyticsPageTablet(),
                mobile: AnalyticsPageMobile(),
              ))),
    );
  }
}
