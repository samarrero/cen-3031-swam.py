import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/menus/nav_bar.dart';
import 'package:swampy/pages/home_page/home_page_desktop.dart';
import 'package:swampy/pages/home_page/home_page_mobile.dart';
import 'package:provider/provider.dart';
import 'package:swampy/pages/home_page/home_page_tablet.dart';
import 'package:swampy/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ListElement> sample = List.generate(25, (index) => ListElement(items: ['$index', '${index + 1}', '${index + 2}', '${index + 3}'],));
  final GlobalKey<FormState> createAccountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'first' : TextEditingController(),
    'last' : TextEditingController(),
    'email' : TextEditingController(),
    'password' : TextEditingController()
  };

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: ScreenTypeLayout(
                  desktop: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 64.0,
                            left: MediaQuery.of(context).size.width >= 1270 ? 0.0 : 70.0,
                            right: MediaQuery.of(context).size.width >= 1270 ? 0.0 : 70.0,
                          ),
                          child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 64.0),
                                          child: Text('Looks like you’re not logged in. Please either log in or create an account to continue.',
                                              style: Theme.of(context).textTheme.headline2),
                                        ),
                                      ]
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Toggle(
                                            options: ['Create Account', 'Log In'],
                                            height: 100.0,
                                            leftToggleWidth: MediaQuery.of(context).size.width >= 1270 ? 320.0 : MediaQuery.of(context).size.width * 0.21,
                                            rightToggleWidth: MediaQuery.of(context).size.width >= 1270 ? 160.0 : MediaQuery.of(context).size.width * 0.13,
                                            children: [
                                              CreateAccountForm(formKey: createAccountKey, controllers: controllers),
                                              LoginForm(formKey: loginKey, controllers: controllers)
                                            ]
                                        ),
                                      ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(height: 80)
                      ],
                    ),
                  ),
                  tablet: HomePageTablet(sample: sample),
                  mobile: HomePageMobile(sample: sample),
                )
            )
          ),
    );
  }
}

class Toggle extends StatefulWidget {
  final List<String> options;
  final List<Widget> children;
  final double height, leftToggleWidth, rightToggleWidth;

  Toggle({
    @required this.children,
    @required this.options,
    @required this.height,
    @required this.leftToggleWidth,
    @required this.rightToggleWidth
  });

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool _toggleValue;
  int _speed;

  @override
  void initState() {
    _toggleValue = false;
    _speed = 300;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleButton,
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta > 0) { // to the right
              setState(() {
                _toggleValue = true;
              });
            } else {
              setState(() {
                _toggleValue = false;
              });
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: _speed),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.grey.withOpacity(0.35),
            ),
            child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.transparent,
                    border: Border.all(width: 3.0)
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      top: -3,
                      left: _toggleValue ? widget.leftToggleWidth : -3,
                      right: _toggleValue ? -3 : widget.rightToggleWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.white,
                                  border: Border.all(width: 3.0)
                              ),
                              height: widget.height,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: widget.leftToggleWidth,
                          height: widget.height,
                          child: Center(
                            child: Text(widget.options[0], style: Theme.of(context).textTheme.headline3),
                          ),
                        ),
                        Container(
                          width: widget.rightToggleWidth,
                          height: widget.height,
                          child: Center(
                            child: Text(widget.options[1], style: Theme.of(context).textTheme.headline3),
                          ),
                        )
                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            firstChild: widget.children[0],
            secondChild: widget.children[1],
            crossFadeState: _toggleValue ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
        )
      ],
    );
  }

  void _toggleButton() {
    setState(() {
      _toggleValue = !_toggleValue;
    });
  }
}

class CreateAccountForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;

  CreateAccountForm({@required this.formKey, @required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputField(
            text: 'First Name',
            controller: controllers['first'],
            type: InputType.Text,
          ),
          InputField(
            text: 'Last Name',
            controller: controllers['last'],
            type: InputType.Text,
          ),
          InputField(
            text: 'Email',
            controller: controllers['email'],
            type: InputType.Email,
          ),
          InputField(
            text: 'Password',
            controller: controllers['password'],
            type: InputType.Password,
          ),
          SizedBox(height: 52.0),
          PrimaryButton(
              title: 'CREATE ACCOUNT',
              onPress: () async {
                if (formKey.currentState.validate()) {
                  try {
                    await context.read<FirebaseAuthService>()
                        .createAccountWithEmailAndPassword(
                        controllers['email'].text, controllers['password'].text,
                        controllers['first'].text, controllers['last'].text);
                    print('created account for ${controllers['first'].text} ${controllers['last'].text} with email ${controllers['email'].text}');
                  } catch (e) {
                    print(e);
                    Scaffold
                        .of(context)
                        .showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.black,
                            content: Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                              child: Text('Sorry, an error has occurred.', style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                            )
                        )
                    );
                  }
                }
              }
          )
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget{

  final Function onPress;
  final String title;

  PrimaryButton({
    @required this.title,
    @required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
              width: constraints.maxWidth,
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: onPress,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                  child: Text(title,
                      style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                ),

                shape: RoundedRectangleBorder(
//                  side: BorderSide(
//                  color: Style.theme.primaryColor,
//                  width: 4,
//                  style: BorderStyle.solid
//              ),
                    borderRadius: BorderRadius.circular(50)),
              )
          );
        }
    );
  }
}

class InputField extends StatefulWidget {
  final String text;
  final InputType type;
  final TextEditingController controller;
  final bool round;

  InputField({@required this.text, @required this.controller, @required this.type, this.round});

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
          enabledBorder: widget.round != null ?
          OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.black),
              borderRadius: BorderRadius.circular(32.0)
          ) :
          UnderlineInputBorder(
            borderSide: BorderSide(width: 2.5, color: Colors.black),
          ),
          border: widget.round != null ?
          OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.black),
              borderRadius: BorderRadius.circular(32.0)
          ) :
          UnderlineInputBorder(
              borderSide: BorderSide(width: 2.5, color: Colors.black)
          ),
          focusedBorder: widget.round != null ?
          OutlineInputBorder(
              borderSide: BorderSide(width: 2.5, color: Colors.black),
              borderRadius: BorderRadius.circular(32.0)
          ) :
          UnderlineInputBorder(
              borderSide: BorderSide(width: 2.5, color: Colors.black)
          ),
          errorBorder: widget.round != null ?
          OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(32.0)
          ) :
          UnderlineInputBorder(
              borderSide: BorderSide(width: 2.5, color: Theme.of(context).errorColor)
          ),
          contentPadding: widget.round != null ? EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0) : EdgeInsets.zero,
          labelText: widget.text,
          labelStyle: _valid ? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).errorColor),
        ),
        style: Theme.of(context).textTheme.headline5.copyWith(height: 1.5),
        obscureText: widget.type == InputType.Password ? true : false,
        keyboardType: widget.type == InputType.Email ? TextInputType.emailAddress :
        widget.type == InputType.Phone ? TextInputType.phone : widget.type == InputType.Multiline ? TextInputType.multiline : TextInputType.text,
        cursorColor: Colors.black,
        cursorWidth: 2.5,
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

enum InputType {
  Email,
  Password,
  Text,
  Phone,
  Multiline
}

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;

  LoginForm({@required this.formKey, @required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputField(
            text: 'Email',
            controller: controllers['email'],
            type: InputType.Email,
          ),
          InputField(
            text: 'Password',
            controller: controllers['password'],
            type: InputType.Password,
          ),
          SizedBox(height: 52.0),
          PrimaryButton(
              title: 'LOG IN',
              onPress: () async {
                if (formKey.currentState.validate()) {
                  try {
                    await context.read<FirebaseAuthService>()
                        .signInWithEmailAndPassword(controllers['email'].text, controllers['password'].text);
                    print('logged in as ${context.read<FirebaseAuthService>().currentUser().firstName} ${context.read<FirebaseAuthService>().currentUser().lastName} with uid ${context.read<FirebaseAuthService>().currentUser().uid}');
                  } catch (e) {
                    print(e.toString());
                    String message = '';
                    if (e.toString() == '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                      message = "Sorry, we couldn't find that user.";
                    } else if (e.toString() == '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
                      message = "Sorry, that's not the right password.";
                    } else if (e.toString() == '[firebase_auth/too-many-requests] Too many unsuccessful login attempts. Please try again later.') {
                      message = 'Too many unsuccessful login attempts. Please try again later.';
                    } else if (e.toString() == '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                      message = "Oops! Looks like you're offline!";
                    } else {
                      message = 'Sorry, an error has occurred.';
                    }
                    Scaffold
                        .of(context)
                        .showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.black,
                            content: Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                              child: Text(message, style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white)),
                            )
                        )
                    );
                  }
                }
              }
          )
        ],
      ),
    );
  }
}
