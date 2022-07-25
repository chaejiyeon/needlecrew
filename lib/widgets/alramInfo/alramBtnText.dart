// alram appbar itemBtn
import 'package:needlecrew/modal/alramDeleteModal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class alramBtnText extends StatefulWidget {
  final String text;
  final Color textColor;

  const alramBtnText({Key? key, required this.text, required this.textColor})
      : super(key: key);

  @override
  State<alramBtnText> createState() => _alramBtnTextState();
}

class _alramBtnTextState extends State<alramBtnText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.text == "삭제") Get.dialog(AlramDeleteModal());
      },

      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          widget.text,
          style: TextStyle(color: widget.textColor, fontSize: 16),
        ),
      ),
    );
  }
}
