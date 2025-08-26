import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class AppleGiris extends StatelessWidget {
  final void Function()?onTap;
  const AppleGiris({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset('lib/assets/apple.svg', width: 100, height: 50),
      ),
    );
  }
}
