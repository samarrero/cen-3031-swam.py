import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:swampy/router/route.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(context) => ListView(
      children: [
        MediaQuery.of(context).size.width < 600 ?
        Column(
          children: [
            FlatButton(
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.black),
                title: Text('Account', style: Theme.of(context).textTheme.headline6),
              ),
              onPressed: () {
                //TODO
              },
            ),
            Divider(
              color: Colors.grey.shade700,
              thickness: 1.0,
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ) : const SizedBox.shrink(),
        FlatButton(
            child: ListTile(
              leading: Icon(Icons.home_rounded, color: Colors.black),
              title: Text('Home', style: Theme.of(context).textTheme.headline6),
              selected: ModalRoute.of(context).settings.name == HomeRoute ? true : false,
              selectedTileColor: Colors.grey.withOpacity(0.3),
            ),
            onPressed: () {
              FluroRouter.router.navigateTo(
                  context,
                  HomeRoute,
                  transition: fluro.TransitionType.fadeIn,
                  transitionDuration: Duration(milliseconds: 150));
            },
        ),
        FlatButton(
            child: ListTile(
              leading: Icon(Icons.widgets_rounded, color: Colors.black),
              title: Text('Products', style: Theme.of(context).textTheme.headline6,),
              selected: ModalRoute.of(context).settings.name == ProductsRoute ? true : false,
              selectedTileColor: Colors.grey.withOpacity(0.3),
            ),
            onPressed: () {
              FluroRouter.router.navigateTo(
                  context,
                  ProductsRoute,
                  transition: fluro.TransitionType.fadeIn,
                  transitionDuration: Duration(milliseconds: 150));
            },
        ),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.description_rounded, color: Colors.black),
            title: Text('Orders', style: Theme.of(context).textTheme.headline6,),
            selected: ModalRoute.of(context).settings.name == OrdersRoute ? true : false,
            selectedTileColor: Colors.grey.withOpacity(0.3),
          ),
          onPressed: () {
            FluroRouter.router.navigateTo(
                context,
                OrdersRoute,
                transition: fluro.TransitionType.fadeIn,
                transitionDuration: Duration(milliseconds: 150));
          },
        ),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.scatter_plot, color: Colors.black),
            title: Text('Analytics', style: Theme.of(context).textTheme.headline6,),
            selected: ModalRoute.of(context).settings.name == AnalyticsRoute ? true : false,
            selectedTileColor: Colors.grey.withOpacity(0.3),
          ),
          onPressed: () {
            FluroRouter.router.navigateTo(
                context,
                AnalyticsRoute,
                transition: fluro.TransitionType.fadeIn,
                transitionDuration: Duration(milliseconds: 150));
          },
        ),
      ]
  );
}