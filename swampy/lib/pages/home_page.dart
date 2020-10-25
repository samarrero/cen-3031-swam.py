import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
              desktop: HomePageDesktop(key: _scaffoldKey),
              tablet: Container(),
              mobile: Container(),
            ),
          ),
    );
  }
}

class HomePageDesktop extends StatelessWidget {
  final GlobalKey<ScaffoldState> key;

  HomePageDesktop({this.key});

  @override
  Widget build(BuildContext context) {
    return ListElement(items: ['T-Shirt', '45', 'T-Shirt', 'T-Shirt Co.', '5'],);
  }
}

class ListElement extends StatelessWidget {
  List<String> items;

  ListElement({this.items});

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(items[0]),
          Text(items[1]),
          Text(items[2]),
          Text(items[3]),
          Text(items[4]),
        ],
      ),
    );
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(this.itemCount,
              (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}

class RowBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const RowBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      //TODO: ALIGNMENT
      children: new List.generate(this.itemCount,
              (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}
