import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class ListModalBottomSheet extends StatefulWidget {
  // Make sure the number of the items fed to the modal
  // does not exceed the height of the device because the modal won't allow
  // user scroll input
  const ListModalBottomSheet({super.key});

  @override
  State<ListModalBottomSheet> createState() => _ListModalBottomSheetState();
}

class _ListModalBottomSheetState extends State<ListModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: mainBackgroundColor,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            alignment: Alignment.center,
            child: Container(
              width: 140,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black54),
            ),
          ),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 30,
              ),
              ModalButton(
                icon: Icon(
                  Icons.settings_sharp,
                  size: 24,
                  color: scrollsBackgroundColor,
                ),
                text: "settings",
                onPressed: () {},
              ),
              ModalButton(
                icon: Icon(
                  Icons.settings_sharp,
                  size: 24,
                  color: scrollsBackgroundColor,
                ),
                text: "settings",
                onPressed: () {},
              ),
              ModalButton(
                icon: Icon(
                  Icons.settings_sharp,
                  size: 24,
                  color: scrollsBackgroundColor,
                ),
                text: "settings",
                onPressed: () {},
              ),
              ModalButton(
                icon: Icon(
                  Icons.settings_sharp,
                  size: 24,
                  color: scrollsBackgroundColor,
                ),
                text: "settings",
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ModalButton extends StatefulWidget {
  final Icon icon;
  final String text;
  final void Function() onPressed;

  const ModalButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  State<ModalButton> createState() => _ModalButtonState();
}

class _ModalButtonState extends State<ModalButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.fromLTRB(25, 3, 15, 3),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 30,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: widget.icon,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text(
                widget.text,
                style: GoogleFonts.quicksand(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: scrollsBackgroundColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
