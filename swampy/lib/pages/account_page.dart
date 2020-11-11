import 'package:flutter/material.dart';
import 'package:swampy/models/user.dart';
import 'package:swampy/pages/logged_in_page.dart';
import 'package:swampy/pages/login_page.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (_, user, __) {
        if (user == null) {
          return LoginPage();
        } else {
          return LoggedInPage();
        }
      },
    );
  }
}