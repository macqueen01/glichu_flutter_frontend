import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/UiComponents.dart/Buttons.dart';
import 'package:mockingjae2_mobile/src/api/scrolls.dart';

import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';

class LoginBodyView extends StatefulWidget {
  const LoginBodyView({Key? key}) : super(key: key);

  State<LoginBodyView> createState() => _LoginState();
}

class _LoginState extends State<LoginBodyView> {
  int _counter = 0;
  String _username = '';
  String _password = '';

  void _emailChange(text) {
    setState(() {
      _username = text;
    });
  }

  void _passwordChange(text) {
    setState(() {
      _password = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: BoxContainer(
                context: context,
                backgroundColor: Colors.white,
                height: 540,
                width: 310,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 300,
                        alignment: Alignment.center,
                        child: LogoNavIcon(100, 55, mainThemeColor),
                        margin: EdgeInsets.only(bottom: 40),
                      ),
                      Container(
                        height: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimatedTextField(
                              placeholder: 'username',
                              callBack: _emailChange,
                              width: 230,
                              hidden: true,
                            ),
                            AnimatedTextField(
                              placeholder: 'password',
                              callBack: _passwordChange,
                              width: 230,
                              hidden: false,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 70,
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: FlatButtonLarge(
                          backgroundColor: mainSubThemeColor,
                          onPressed: () {},
                          fontColor: mainThemeColor,
                          text: 'Login',
                          decoration: BoxDecoration(
                              color: mainSubThemeColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: mainThemeColor, width: 1.5)),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          'or',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 60,
                        alignment: Alignment.center,
                        child: FlatButtonLarge(
                          backgroundColor: mainThemeColor,
                          onPressed: () {},
                          fontColor: Colors.white,
                          text: 'Sign in',
                          decoration: BoxDecoration(
                              color: mainThemeColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: mainThemeColor, width: 1.5)),
                        ),
                      )
                    ]))));
  }
}
