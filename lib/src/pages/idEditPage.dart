import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/Providers/authenticationPageProvider.dart';
import 'package:mockingjae2_mobile/src/components/inputs.dart';

import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:provider/provider.dart';

class NameEditPage extends StatefulWidget {
  const NameEditPage({super.key});

  static const routeName = '/nameEdit';

  @override
  State<NameEditPage> createState() => _NameEditPageState();
}

class _NameEditPageState extends State<NameEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scrollsBackgroundColor,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        middle: Text(
          'Edit your id',
          style: TextStyle(
              color: mainBackgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.w400),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
                color: CupertinoColors.destructiveRed,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Submit',
            style: TextStyle(
                color: CupertinoColors.inactiveGray,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 90,
                child: AnimatedTextField(
                    placeholder: "Personal Id",
                    placeholderColor: CupertinoColors.inactiveGray,
                    placeholderColorFocused: Colors.white,
                    borderColor: Colors.transparent,
                    mainTextColor: mainSubThemeColor,
                    callBack: (string) {},
                    // context.read<AuthenticationCenterProvider>().setMJId,
                    width: 300,
                    hidden: true),
              ),
              BoxContainer(
                context: context,
                width: 330,
                height: 80,
                radius: 10,
                backgroundColor: Colors.transparent,
                child: FutureBuilder<Widget>(
                    future: UserIdCheckInfoBox(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return Container();
                      }
                    }),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

Future<Widget> UserIdCheckInfoBox(BuildContext context) async {
  AuthenticationCenterProvider provider =
      context.read<AuthenticationCenterProvider>();

  bool inUse = await provider.isIdAlreadyInUse();

  List<bool> conditions = [
    provider.isEmptyId(),
    provider.isNotValidStringId(),
    await provider.isIdAlreadyInUse()
  ];

  List<String> messages = [
    "Check you have entered your ID",
    "ID must not contain any white space, #, -, or @",
    "ID is already in use"
  ];

  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < conditions.length; i++)
          if (conditions[i])
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                messages[i],
                style: TextStyle(
                    color: Color.fromARGB(255, 229, 65, 53),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
              ),
            ),
      ],
    ),
  );
}
