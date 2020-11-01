import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final bool border;
  final bool small;

  const PrimaryButton({@required this.title, @required this.onPressed, this.color, this.border, this.small});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Text(
          this.title,
          textAlign: TextAlign.center,
          style: this.color == null ? Theme.of(context).textTheme.button.copyWith(color: Colors.white) : this.small != null ? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline4,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: border != null ? BorderSide(color: Colors.black, width: 2.0) : BorderSide(width: 0.0, color: Colors.transparent)
      ),
      color: this.color == null ? Theme.of(context).primaryColor : this.color,
      onPressed: this.onPressed,
    );
  }
}