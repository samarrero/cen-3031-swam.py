import 'package:flutter/material.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/router/route.dart';
import 'package:fluro/fluro.dart' as fluro;

class ListCard extends StatelessWidget {
  final int primaryKey, secondaryKey;
  final ListElement attributes;
  final List<String> descriptors;

  ListCard({this.primaryKey, this.secondaryKey, this.attributes, this.descriptors});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)),
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          FluroRouter.router.navigateTo(
              context,
              attributes.route,
              transition: fluro.TransitionType.fadeIn,
              transitionDuration: Duration(milliseconds: 150));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left:  16.0, top: 16.0, bottom: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attributes.items[primaryKey],
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 6.0,),
                      ColumnBuilder(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        itemCount: attributes.items.length,
                        itemBuilder: (context, index) {
                          return index != primaryKey && index != secondaryKey ? RichText(
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.headline5.copyWith(height: 1.8),
                                children: [
                                  TextSpan(text: descriptors[index], style: Theme.of(context).textTheme.headline5,),
                                  TextSpan(text: '  ', style: Theme.of(context).textTheme.headline6),
                                  TextSpan(text: attributes.items[index], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold))
                                ]
                            ),
                          ) : SizedBox.shrink();
                        },
                      )
                    ]
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(attributes.items[secondaryKey], style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold),),
                  Text(descriptors[secondaryKey], style: Theme.of(context).textTheme.headline5,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
