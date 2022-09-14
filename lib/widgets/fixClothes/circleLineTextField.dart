import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class CircleLineTextField extends StatefulWidget {
  final int maxLines;
  final String hintText;
  final Color hintTextColor;
  final double borderRadius;
  final Color borderSideColor;
  final bool widthOpacity;
  final TextEditingController controller;

  const CircleLineTextField({
    Key? key,
    required this.maxLines,
    required this.hintText,
    required this.hintTextColor,
    required this.borderRadius,
    required this.borderSideColor,
    required this.widthOpacity,
    required this.controller,
  }) : super(key: key);

  @override
  State<CircleLineTextField> createState() => _CircleLineTextFieldState();
}

class _CircleLineTextFieldState extends State<CircleLineTextField> {
  // 글자수 제한
  int maxlength = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      child: TextField(
        onChanged: (value){
          setState((){});
        },
        controller: widget.controller,
        maxLength: 300,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
            counterStyle: widget.controller.text.length >= 300
                ? TextStyle(color: Colors.red)
                : TextStyle(color: HexColor("#767676")),
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: widget.widthOpacity == true
                    ? widget.hintTextColor.withOpacity(0.7)
                    : widget.hintTextColor,
                fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.borderSideColor,
                ))),
      ),
    );
  }
}
