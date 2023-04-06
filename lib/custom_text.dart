import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final Alignment? formAlign;
  final EdgeInsets? formMargin;
  final EdgeInsets? formPadding;
  final double? formWidth;

  final String text;
  final double fontSize;
  final dynamic fontColor;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;

  const CustomText(
      {Key? key,
      this.formAlign,
      this.formMargin,
      this.formPadding,
      this.formWidth,
      //
      required this.text,
      required this.fontSize,
      this.fontColor,
      this.fontWeight,
      this.textOverflow,
      this.textDirection = TextDirection.ltr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: formWidth,
      alignment: formAlign,
      padding: formPadding,
      margin: formMargin,
      child: Text(
        text,
        overflow: textOverflow,
        textDirection: textDirection,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: fontColor == null ? Colors.black : fontColor,
        ),
        // maxLines: 5,
      ),
    );
  }
}
