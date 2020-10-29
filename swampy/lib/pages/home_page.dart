import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/pages/home_page/home_page_desktop.dart';
import 'package:swampy/pages/home_page/home_page_mobile.dart';
import 'package:provider/provider.dart';
import 'package:swampy/pages/home_page/home_page_tablet.dart';
import 'package:swampy/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(25, (index) => ListElement(items: ['$index', '${index + 1}', '${index + 2}', '${index + 3}'],));
  final GlobalKey<FormState> createAccountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'first' : TextEditingController(),
    'last' : TextEditingController(),
    'email' : TextEditingController(),
    'password' : TextEditingController()
  };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>
          Scaffold(
              resizeToAvoidBottomInset: false,
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