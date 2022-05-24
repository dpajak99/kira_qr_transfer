import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final double? fontSize;
  final GestureTapCallback? onTap;
  final Color? color;
  final Color? hoverColor;

  const TextLink(
    this.text, {
    this.fontSize,
    this.onTap,
    this.color,
    this.hoverColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          color: Colors.blue,
        ),
      ),
    );
  }
}
