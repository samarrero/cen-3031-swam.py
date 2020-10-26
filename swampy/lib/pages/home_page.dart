import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/pages/home_page/home_page_desktop.dart';
import 'package:swampy/pages/home_page/home_page_mobile.dart';
import 'package:swampy/pages/home_page/home_page_tablet.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(25, (index) => ListElement(items: ['$index'],));

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>
          Scaffold(
            resizeToAvoidBottomInset: false,
            // drawer:
            // sizingInformation.deviceScreenType == DeviceScreenType.mobile ||
            //     sizingInformation.deviceScreenType == DeviceScreenType.tablet
            //     ? NavigationDrawer()
            //     : null,
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: ScreenTypeLayout(
                  desktop: HomePageDesktop(sample: sample),
                  tablet: HomePageTablet(sample: sample),
                  mobile: HomePageMobile(sample: sample),
                )
            )
          ),
    );
  }
}