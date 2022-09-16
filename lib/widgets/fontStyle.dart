import 'package:flutter/material.dart';

class FontStyle extends StatelessWidget {
  final String text;
  final String fontsize; // lg(26) = title , md(16) = subtitle, sm(10)
  final String fontbold;
  final Color fontcolor;
  final bool textdirectionright;
  final bool isEllipsis;

  const FontStyle(
      {Key? key,
      required this.text,
      required this.fontsize,
      required this.fontbold,
      required this.fontcolor,
        required this.textdirectionright,
        this.isEllipsis = true,
      fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: isEllipsis == false ? null : TextOverflow.ellipsis,
      textDirection: textdirectionright == true ? TextDirection.rtl : TextDirection.ltr,
      style: TextStyle(
        fontSize: fontsize == "lg"
            ? 24
            : fontsize == "md"
                ? 16
                : fontsize == "sm"
                    ? 10
                    : 14,
        fontWeight: fontbold == "bold" ? FontWeight.bold : null,
        color: fontcolor,
      ),
      // maxLines: 5,
    );
  }
}
