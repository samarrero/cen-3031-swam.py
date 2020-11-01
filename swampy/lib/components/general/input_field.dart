import 'package:flutter/material.dart';

enum InputType {
  Email,
  Password,
  Text,
  Phone,
  Multiline
}

class InputField extends StatefulWidget {
  final String text;
  final InputType type;
  final TextEditingController controller;

  InputField({@required this.text, @required this.controller, @required this.type});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _valid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.grey[800]),
              borderRadius: BorderRadius.circular(32.0)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.grey[800]),
              borderRadius: BorderRadius.circular(32.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.grey[800]),
              borderRadius: BorderRadius.circular(32.0)
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(32.0)
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          labelText: widget.text,
          labelStyle: _valid ? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).errorColor),
        ),
        style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
        obscureText: widget.type == InputType.Password ? true : false,
        keyboardType: widget.type == InputType.Email ? TextInputType.emailAddress :
        widget.type == InputType.Phone ? TextInputType.phone : widget.type == InputType.Multiline ? TextInputType.multiline : TextInputType.text,
        cursorColor: Colors.black,
        cursorWidth: 2.0,
        minLines: widget.type == InputType.Multiline ? 10 : 1,
        maxLines: widget.type == InputType.Multiline ? null : 1,
        showCursor: true,
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _valid = false;
            });
            return 'Please enter a ${widget.text.toLowerCase()}.';
          }
          else if (widget.type == InputType.Email) {
            final RegExp _emailRegExp = RegExp(
              r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
            );
            if (!_emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email.';
            }
          }
          else if (widget.type == InputType.Password) {
            if (value.length < 6) {
              return 'Your password must be at least 6 characters.';
            }
          }
          setState(() {
            _valid = true;
          });
          return null;
        },
      ),
    );
  }
}