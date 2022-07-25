import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/myPage/directQuetionHideItem.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DirectQuestion extends StatefulWidget {
  const DirectQuestion({Key? key}) : super(key: key);

  @override
  State<DirectQuestion> createState() => _DirectQuestionState();
}

class _DirectQuestionState extends State<DirectQuestion> {
  List tabs = ["TOP10", "공지", "수선안내", "환불", "요금 및 결제", "이용안내"];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MypageAppBar(
          title: "자주하는 질문", icon: "", widget: MainHome(), appbar: AppBar()),
      body: Container(
              margin: EdgeInsets.only(left: 24, top: 40, bottom: 25),
              child: Column(
                children: [
                  Row(children: [
                    for (int i = 0; i < 4; i++) CategoryItem(tabs[i], i)
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      for (int i = 4; i < 6; i++) CategoryItem(tabs[i], i),
                    ],
                  ),
                  SizedBox(height: 43,),
                  Expanded(
                      child: Container(
                          child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        2,
                        (index) => DirectQuestionHideItem(),
                      ),
                    ),
                  ),),),
                ],
              ),
            ),

        // DirectQuestionHideItem(),
    );
  }

  // category 목록
  Widget CategoryItem(String category, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        alignment: Alignment.center,
        height: 40,
        // width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 1,
              color: currentPage == index
                  ? HexColor("#fd9a03")
                  : HexColor("#d5d5d5"),
            ),
            color: currentPage == index ? HexColor("#fd9a03") : null),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 15,
            color: currentPage == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
