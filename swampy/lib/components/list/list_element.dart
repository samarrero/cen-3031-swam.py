import 'package:flutter/material.dart';
import 'package:swampy/components/general/row_builder.dart';
import 'package:swampy/router/route_names.dart';
import 'package:swampy/router/router.dart';
import 'package:fluro/fluro.dart' as fluro;

class ListElement extends StatelessWidget {
  final List<String> items;
  bool visible;
  String route;
  Object object;

  ListElement({this.items, this.visible = true, this.route, this.object});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
        elevation: 3.0,
        child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, route, arguments: object);
         FluroRouter.router.navigateTo(
            context,
            route,
            routeSettings: RouteSettings(
              arguments: object
            ),
            transition: fluro.TransitionType.fadeIn,
            transitionDuration: Duration(milliseconds: 150));
        },
          child: RowBuilder(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.11,
                child: Center(
                  child: Text(
                    items[index],
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            );
          },
        ),
        ),
    );
  }
}