import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget child;

  Section({@required this.title, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            child
          ],
        ),
      ),
    );
  }
}
