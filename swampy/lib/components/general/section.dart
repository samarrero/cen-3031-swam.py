import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;

  Section({@required this.title, @required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: sizingInformation.deviceScreenType == DeviceScreenType.mobile ?
                      MediaQuery.of(context).size.height - (55 + 24 + 28.42 + 21.6) : MediaQuery.of(context).size.height - (70 + 24 + 28.42 + 21.6)
                  ),
                  child: child
              )
            ],
          ),
        )
    );
  }
}
