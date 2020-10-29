import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/buttons.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class LoggedInPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(sizingInformation.deviceScreenType == DeviceScreenType.mobile ? 55 : 70),
                  child: sizingInformation.deviceScreenType == DeviceScreenType.mobile ? NavBar.mobile() : NavBar(),
                ),
                body: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return;
                    },
                    child: Center(
                      child: Card(
                        elevation: 3.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PrimaryButton(
                                    title: 'SIGN OUT',
                                    onPressed: () async {
                                      try {
                                        await context.read<FirebaseAuthService>().signOut();
                                      } catch (e) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                backgroundColor: Colors.grey[800],
                                                content: Padding(
                                                  padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                                                  child: Text('Sorry, an error has occurred.', style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                                                )
                                            )
                                        );
                                      }
                                    }
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                )
            ),
          ),
    );
  }
}