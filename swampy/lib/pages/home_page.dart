import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/pages/home_page/home_page_desktop.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            body: ScreenTypeLayout(
              desktop: HomePageDesktop(),
              tablet: Container(),
              mobile: Container(),
            ),
          ),
    );
  }
}
