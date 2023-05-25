import 'package:flutter/material.dart';
import 'package:mockingjae2_mobile/src/components/icons.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
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
          child: GlichuIcon(80, 80),
        ),
      ),
    );
  }
}
