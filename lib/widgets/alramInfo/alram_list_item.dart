import 'package:needlecrew/models/alram_item.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class AlramListItem extends StatefulWidget {
  final AlramItem alram;

  const AlramListItem({Key? key, required this.alram}) : super(key: key);

  @override
  State<AlramListItem> createState() => _AlramListItemState();
}

class _AlramListItemState extends State<AlramListItem> {
  bool ischecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            height: 70,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.only(bottom: 27),
                  child: Checkbox(
                        shape: CircleBorder(),
                        activeColor: Colors.black,
                        side: BorderSide(
                          color: HexColor("#aaaaaa"),
                          width: 1.5
                        ),
                        value: ischecked,
                        onChanged: ((value) {
                          setState(() {
                            ischecked = value!;
                          });
                        })),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: HexColor("#d5d5d5"),
                              width: 0.5,
                            ))),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: 40,
                          height: 40,
                          child: SvgPicture.asset(
                              "assets/icons/alramInfo/" + widget.alram.alramNo),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FontStyle(
                                    text: widget.alram.title,
                                    fontsize: "",
                                    fontbold: "",
                                    fontcolor: Colors.black,
                                    textdirectionright: false),
                                FontStyle(
                                    text: widget.alram.time <= 10
                                        ? widget.alram.time.toString() + "분 전"
                                        : "한 시간 전",
                                    fontsize: "",
                                    fontbold: "",
                                    fontcolor: HexColor("#d5d5d5"),
                                    textdirectionright: false),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ),ListView(
//   scrollDirection: Axis.horizontal,
//   children: [
//     Container(
//       padding: EdgeInsets.only(right: 10, bottom: 10),
//         width: 50,
//         height: 50,
//         child: SvgPicture.asset(
//             "assets/icons/alramInfo/" + widget.alram.alramNo),),
//     SizedBox(width: 10,),
//     Container(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           FontStyle(
//               text: widget.alram.title,
//               fontsize: "md",
//               fontbold: "",
//               fontcolor: Colors.black,textdirectionright: false),
//           FontStyle(
//             text:widget.alram.time <=10 ?  widget.alram.time.toString() +  "분 전" : "한 시간 전",
//             fontsize: "",
//             fontbold: "",
//             fontcolor: HexColor("#d5d5d5"),textdirectionright: false
//           ),
//         ],
//       ),
//     ),
//
//     Container(
//       padding: EdgeInsets.all(23),
//       height: MediaQuery.of(context).size.height,
//       width: 80,
//       color: HexColor("#d5d5d5").withOpacity(0.5),
//       child: SvgPicture.asset("assets/icons/trashIcon.svg"),
//     ),
//   ],
// ),
