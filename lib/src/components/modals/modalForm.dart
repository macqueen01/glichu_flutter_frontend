import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class ListModalBottomSheet extends StatefulWidget {
  // Make sure the number of the items fed to the modal
  // does not exceed the height of the device because the modal won't allow
  // user scroll input
  final List<ModalButton> children;

  const ListModalBottomSheet({super.key, required this.children});

  @override
  State<ListModalBottomSheet> createState() => _ListModalBottomSheetState();
}

class _ListModalBottomSheetState extends State<ListModalBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // this sets up modal button list with padding
    List<Widget> children = <Widget>[
      SizedBox(
        width: 0,
        height: 30,
      )
    ].followedBy(widget.children).toList();

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
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black54),
            ),
          ),
          ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: children),
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
