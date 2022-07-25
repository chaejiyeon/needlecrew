import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class MypayInfo extends StatefulWidget {
  const MypayInfo({Key? key}) : super(key: key);

  @override
  State<MypayInfo> createState() => _MypayInfoState();
}

class _MypayInfoState extends State<MypayInfo> {
  int currentPage = 0;

  // 현재 년도 가져오기
  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy');
    String strToday = formatter.format(now);
    return strToday;
  }

  List<String> month = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MypageAppBar(
          title: "결제 내역", icon: "", widget: MainHome(), appbar: AppBar()),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (currentPage > 0) currentPage--;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      CupertinoIcons.chevron_back,
                      color: HexColor("#909090"),
                      size: 20,
                    ),
                  ),
                  Row(
                    children: [
                      FontStyle(
                          text: getToday() + "년 ",
                          fontsize: "md",
                          fontbold: "",
                          fontcolor: Colors.black,
                          textdirectionright: false),
                      FontStyle(
                          text: month[currentPage] + "월",
                          fontsize: "md",
                          fontbold: "",
                          fontcolor: Colors.black,
                          textdirectionright: false),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (currentPage < 12) currentPage++;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      CupertinoIcons.forward,
                      color: HexColor("#909090"),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 11,
            ),
            ListLine(
                height: 1,
                width: double.infinity,
                lineColor: HexColor("#d5d5d5"),
                opacity: 0.5),
            SizedBox(
              height: 29,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: ListView(
                  children:
                      List.generate(month.length, (index) => ListItem(index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListItem(int price) {
    return Container(
      padding: EdgeInsets.only(bottom: 29),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: EdgeInsets.all(10),
            child: SvgPicture.asset("assets/icons/myPage/pantsIcon.svg")),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: HexColor("#ededed"),
                ),
              ),
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              collapsedIconColor: HexColor("#909090"),
              title: Row(
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "2022.01.01",
                                fontsize: "",
                                fontbold: "",
                                fontcolor: HexColor("#909090"),
                                textdirectionright: false),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FontStyle(
                                      text: "하의-일반바지",
                                      fontsize: "",
                                      fontbold: "bold",
                                      fontcolor: Colors.black,
                                      textdirectionright: false),
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        FontStyle(
                                            text: price.toString(),
                                            fontsize: "",
                                            fontbold: "bold",
                                            fontcolor: Colors.black,
                                            textdirectionright: false),
                                        Text("원")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 29,)
                          ],
                        ),
                    ),
                  ],
                ),
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                              "assets/icons/myPage/pantsIcon.svg")),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: HexColor("#d5d5d5"),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FontStyle(
                                  text: "2022.01.01",
                                  fontsize: "",
                                  fontbold: "",
                                  fontcolor: HexColor("#909090"),
                                  textdirectionright: false),
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FontStyle(
                                        text: "하의-일반바지",
                                        fontsize: "",
                                        fontbold: "bold",
                                        fontcolor: Colors.black,
                                        textdirectionright: false),
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          FontStyle(
                                              text: price.toString(),
                                              fontsize: "",
                                              fontbold: "bold",
                                              fontcolor: Colors.black,
                                              textdirectionright: false),
                                          FontStyle(
                                              text: "원",
                                              fontsize: "",
                                              fontbold: "",
                                              fontcolor: Colors.black,
                                              textdirectionright: false),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );

    //   Container(
    //   padding: EdgeInsets.only(top: 20),
    //   child: Row(
    //     children: [
    //       Container(padding: EdgeInsets.all(10),child: SvgPicture.asset("assets/icons/myPage/pantsIcon.svg")),
    //       SizedBox(width: 10,),
    //       Expanded(
    //         child: Container(
    //           height: 70,
    //           decoration: BoxDecoration(
    //             border: Border(
    //               bottom: BorderSide(
    //                 color: HexColor("#d5d5d5"),
    //               ),
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               FontStyle(
    //                   text: "2022.01.01",
    //                   fontsize: "",
    //                   fontbold: "",
    //                   fontcolor: HexColor("#909090"),textdirectionright: false),
    //               Container(
    //                 padding: EdgeInsets.only(right: 20),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     FontStyle(
    //                         text: "하의-일반바지",
    //                         fontsize: "",
    //                         fontbold: "bold",
    //                         fontcolor: Colors.black,textdirectionright: false),
    //
    //                     GestureDetector(
    //                       child: Row(
    //                         children: [
    //                           FontStyle(
    //                               text: price.toString(),
    //                               fontsize: "",
    //                               fontbold: "bold",
    //                               fontcolor: Colors.black,textdirectionright: false),
    //                           FontStyle(
    //                               text: "원",
    //                               fontsize: "",
    //                               fontbold: "",
    //                               fontcolor: Colors.black,textdirectionright: false),
    //                           SizedBox(width: 10,),
    //                           Icon(CupertinoIcons.chevron_down, size: 20, color: HexColor("#909090"),),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
