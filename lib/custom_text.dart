import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final bool isFitted;
  final Alignment? formAlign;
  final EdgeInsets? formMargin;
  final EdgeInsets? formPadding;
  final double? formWidth;
  final Decoration? formDecoration;

  //

  final String text;
  final double fontSize;
  final dynamic fontColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDirection? textDirection;
  final int? textMaxLines;

  const CustomText(
      {Key? key,
      this.isFitted = false,
      this.formAlign,
      this.formMargin,
      this.formPadding,
      this.formWidth,
      this.formDecoration,
      //
      required this.text,
      required this.fontSize,
      this.fontColor,
      this.fontWeight,
      this.textAlign = TextAlign.center,
      this.textOverflow = TextOverflow.ellipsis,
      this.textDirection = TextDirection.ltr,
      this.textMaxLines = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: formWidth,
      alignment: formAlign,
      padding: formPadding,
      margin: formMargin,
      decoration: formDecoration,
      child: isFitted
          ? FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                textAlign: textAlign,
                overflow: textOverflow,
                textDirection: textDirection,
                maxLines: textMaxLines,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: fontColor == null ? Colors.black : fontColor,
                ),
                // maxLines: 5,
              ),
            )
          : Text(
              text,
              textAlign: textAlign,
              overflow: textOverflow,
              textDirection: textDirection,
              maxLines: textMaxLines,
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
