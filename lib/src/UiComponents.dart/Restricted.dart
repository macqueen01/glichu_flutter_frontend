import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalButtons.dart';
import 'package:mockingjae2_mobile/src/components/modals/modalForm.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestrictedView extends StatelessWidget {
  const RestrictedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: scrollsBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 103),
        child: Center(
          child: CupertinoButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  barrierColor: Colors.black54,
                  topRadius: const Radius.circular(20),
                  backgroundColor: mainBackgroundColor,
                  builder: (context) =>
                      ListModalBottomSheet(children: [AgeAuthentication]));
            },
            child: Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 87, 75)),
              child: Text(
                "19",
                style: GoogleFonts.quicksand(
                    color: scrollsBackgroundColor,
                    fontSize: 50,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
