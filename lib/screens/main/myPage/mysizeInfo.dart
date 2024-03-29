import 'dart:async';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirt.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mypageMenu.dart';
import 'package:flutter/material.dart';

import 'mysizeOuterCoatUpdate.dart';

class MySizeInfo extends StatefulWidget {
  const MySizeInfo({Key? key}) : super(key: key);

  @override
  State<MySizeInfo> createState() => _MySizeInfoState();
}

class _MySizeInfoState extends State<MySizeInfo> with SingleTickerProviderStateMixin{
  late double animateOpacity = 0;


  @override
  void initState(){
    super.initState();

    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        animateOpacity = 1;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "내 치수", icon: "", widget: MainHome(), appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  MypageMenu(listTitle: "상의", widget: MysizeShirt(sizeType: "상의",)),
                  MypageMenu(listTitle: "바지", widget: MysizeShirt(sizeType: "바지",)),
                  MypageMenu(listTitle: "스커트", widget: MysizeShirt(sizeType: "스커트",)),
                  MypageMenu(listTitle: "원피스", widget: MysizeShirt(sizeType: "원피스",)),
                  MypageMenu(listTitle: "아우터", widget: MysizeOuterUpdate()),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 71),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: animateOpacity,
                    duration: Duration(seconds: 1),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 66,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(33),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor("#d5d5d5"),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(1,1)
                            )
                          ]
                      ),
                      child: Container(
                        width: (MediaQuery.of(context).size.width)-150,
                        padding: EdgeInsets.only(left: 24),
                        child: EasyRichText(
                          "치수 입력을 해놓으면 '내 치수 불러오기'를 통해 수선을 더욱 편리하게 이용할 수 있어요!",
                          defaultStyle: TextStyle(fontSize: 13),
                          patternList: [
                            EasyRichTextPattern(
                                targetString: '내 치수 불러오기',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (animateOpacity == 0) {
                            animateOpacity = 1;
                          } else {
                            animateOpacity = 0;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            boxShadow: [
                              BoxShadow(
                                  color: HexColor("#d5d5d5"),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(1,1)
                              )
                            ]
                        ),
                        // height: 66,
                        child: Image.asset(
                          "assets/images/floatingInfoIcon.png",
                          height: 66,
                          // fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
