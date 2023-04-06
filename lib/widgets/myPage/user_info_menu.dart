import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class UserInfoMenu extends StatefulWidget {
  final String appTitle;
  final String title;
  final String info;
  final bool line;

  const UserInfoMenu(
      {Key? key,
        required this.appTitle,
      required this.title,
      required this.info,
      required this.line})
      : super(key: key);

  @override
  State<UserInfoMenu> createState() => _UserInfoMenuState();
}

class _UserInfoMenuState extends State<UserInfoMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.appTitle == "결제 수단" || widget.appTitle == "결제 수단 등록" ? FontStyle(
                  text: widget.title,
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,textdirectionright: false) : FontStyle(
                 text: widget.title,
                 fontsize: "",
                 fontbold: "bold",
                 fontcolor: Colors.black,textdirectionright: false),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.appTitle == "결제 수단 등록" ? FontStyle(
                      text: widget.info,
                      fontsize: "",
                      fontbold: "",
                      fontcolor: HexColor("#909090"),textdirectionright: false) : FontStyle(
                      text: widget.info,
                      fontsize: "",
                      fontbold: "",
                      fontcolor: Colors.black,textdirectionright: false),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          widget.line == true
              ? ListLine(
                  height: 1,
                  width: double.infinity,
                  lineColor: HexColor("#ededed"),
                  opacity: 1.0)
              : Container(),
        ],
      ),
    );
  }
}
