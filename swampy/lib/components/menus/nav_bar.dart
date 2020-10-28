import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:swampy/router/route_names.dart';
import 'package:swampy/router/router.dart';

class NavBar extends StatelessWidget {
  final bool mobile;

  NavBar({this.mobile = false});

  NavBar.mobile({this.mobile = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: mobile ? 55 : 70,
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: mobile ? 0.0 : 10.0, bottom: mobile ? 2.0 : 0.0),
            child: mobile ?
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('IMPRINT GENIUS',
                  style: MediaQuery.of(context).size.width > 360 ?
                  Theme.of(context).textTheme.headline3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ) :
                  Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  )
                ),
              ),
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                FluroRouter.router.navigateTo(
                    context,
                    HomeRoute,
                    transition: fluro.TransitionType.fadeIn,
                    transitionDuration: Duration(milliseconds: 150));
              },
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('IMPRINT GENIUS',
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    FluroRouter.router.navigateTo(
                        context,
                        HomeRoute,
                        transition: fluro.TransitionType.fadeIn,
                        transitionDuration: Duration(milliseconds: 150));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  iconSize: 42.0,
                  color: Colors.white,
                  onPressed: () {
                    //TODO: GOTO LOGIN
                  },
                )
              ],
            ),
          ),
          automaticallyImplyLeading: mobile ? true : false,
          centerTitle: mobile ? true : false,
          elevation: 0.0,
        ),
      ),
    );
  }
}
