import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as document;
import 'package:intl/date_symbol_data_custom.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TooltipCustom extends StatefulWidget {
  final String tooltipText;
  final String titleText;
  final List boldText;
  final String tailPosition;
  final double fontsize;
  final Color iconColor;

  const TooltipCustom(
      {Key? key,
      required this.tooltipText,
      required this.titleText,
      required this.boldText,
      this.tailPosition = "down",
      this.fontsize = 0,
      this.iconColor = Colors.black})
      : super(key: key);

  @override
  State<TooltipCustom> createState() => _TooltipCustomState();
}

class _TooltipCustomState extends State<TooltipCustom> {
  final tooltipController = JustTheController();
  final GlobalKey tooltipKey = GlobalKey();

  // html tag remove
  String parseHtmlTagRemove() {
    try {
      var document = parse(widget.tooltipText);
      // html 태그 제거
      String parsedText = parse(document.body!.text).documentElement!.text;

      return parsedText;
    } catch (e) {
      print("Tooltip Error   " + e.toString());

      return "";
    }
  }

  @override
  void init() {
    super.initState();
  }

  @override
  void dispose() {
    tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tooltipController.showTooltip();
      },
      child: RichText(
        text: TextSpan(children: [
          widget.titleText == ""
              ? WidgetSpan(
                  child: Container(
                  height: 0,
                  width: 0,
                ))
              : TextSpan(
                  text: widget.titleText,
                  style: TextStyle(
                      fontSize: widget.fontsize != 0 ? widget.fontsize : 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansCJKkrRegular',
                      color: Colors.black),
                ),
          widget.tooltipText == ""
              ? WidgetSpan(child: Container())
              : WidgetSpan(
                  child: JustTheTooltip(
                    controller: tooltipController,
                    preferredDirection: widget.tailPosition == "up"
                        ? AxisDirection.up
                        : widget.tailPosition == "right"
                            ? AxisDirection.right
                            : widget.tailPosition == "left"
                                ? AxisDirection.left
                                : AxisDirection.down,
                    isModal: true,
                    borderRadius: BorderRadius.circular(26),
                    offset: 7,
                    tailBaseWidth: 12,
                    tailLength: 11,
                    shadow: BoxShadow(
                        color: HexColor("#d5d5d5").withOpacity(0.7),
                        spreadRadius: 200,
                        offset: Offset(-1, -3.2)),
                    child: Material(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          CupertinoIcons.question_circle,
                          size: 15,
                          color: widget.iconColor,
                        ),
                      ),
                    ),
                    content: Container(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: widget.tailPosition == "up" ? 13 : 0),
                      width: 218,
                      child: widget.boldText.length != 0
                          ? EasyRichText(
                              widget.tooltipText,
                              defaultStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: 'NotoSansCJKkrRegular'),
                              patternList: List.generate(
                                widget.boldText.length,
                                (index) => EasyRichTextPattern(
                                  targetString: widget.boldText[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              parseHtmlTagRemove(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: 'NotoSansCJKkrRegular'),
                            ),
                    ),
                  ),
                ),
        ]),
      ),
    );
  }
}
