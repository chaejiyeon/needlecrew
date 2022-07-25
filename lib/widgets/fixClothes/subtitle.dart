import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
