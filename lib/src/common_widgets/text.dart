import 'package:flutter/material.dart';

class TextPara extends StatelessWidget {
  const TextPara(this.text, {super.key, this.style, this.margin});

  final String text;
  final TextStyle? style;
  final double? margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style),
        SizedBox(height: margin ?? style!.fontSize),
      ],
    );
  }
}
