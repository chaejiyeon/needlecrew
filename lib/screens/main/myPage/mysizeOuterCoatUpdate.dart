import 'package:get/get.dart';
import 'package:needlecrew/widgets/appbarItem.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mysizeBottom.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../mainHome.dart';

class MysizeOuterUpdate extends StatefulWidget {
  const MysizeOuterUpdate({Key? key}) : super(key: key);

  @override
  State<MysizeOuterUpdate> createState() => _MysizeOuterUpdateState();
}

class _MysizeOuterUpdateState extends State<MysizeOuterUpdate>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List tabs = ["점퍼", "재킷", "코트"];

  int currentPage = 0;

  bool isUpdate = false;

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      setState(() {
        currentPage = tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading:  IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                CupertinoIcons.chevron_back,
                color: Colors.black,
                size: 20,
              )),
          centerTitle: true,
          title: FontStyle(
              text: "아우터",
              fontsize: "md",
              fontbold: "bold",
              fontcolor: Colors.black,textdirectionright: false),
          actions: [
            isUpdate == false ? appbarIcon() : Container(height: 0,),
          ],
        ),
        body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 24, top: 40, bottom: 25),
              child: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide.none,
                ),
                tabs: List.generate(
                  tabs.length,
                      (index) => CategoryItem(tabs[index], index),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: isUpdate == true ? TabBarView(
                          controller: tabController,
                          children: List.generate(
                              tabs.length,
                                  (index) => tabs[index] == "점퍼"
                                  ? UpdateForm()
                                  : tabs[index] == "재킷"
                                  ? UpdateForm()
                                  : UpdateForm()),
                        ) : TabBarView(
                          controller: tabController,
                          children: List.generate(
                              tabs.length,
                                  (index) => tabs[index] == "점퍼"
                                  ? SizeInfo()
                                  : tabs[index] == "재킷"
                                  ? SizeInfo()
                                  : SizeInfo()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Container(
        //   padding: EdgeInsets.only(left: 24, right: 24),
        //   child: SingleChildScrollView(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //           margin: EdgeInsets.only(top: 40, bottom: 25),
        //           child: TabBar(
        //             isScrollable: true,
        //             labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
        //             controller: tabController,
        //             indicator: UnderlineTabIndicator(
        //               borderSide: BorderSide.none,
        //             ),
        //             tabs: List.generate(
        //               tabs.length,
        //               (index) => CategoryItem(tabs[index], index),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           height: MediaQuery.of(context).size.height,
        //           child: isUpdate == true ? TabBarView(
        //             controller: tabController,
        //             children: List.generate(
        //                 tabs.length,
        //                 (index) => tabs[index] == "점퍼"
        //                     ? UpdateForm()
        //                     : tabs[index] == "재킷"
        //                         ? UpdateForm()
        //                         : UpdateForm()),
        //           ) : TabBarView(
        //             controller: tabController,
        //             children: List.generate(
        //                 tabs.length,
        //                     (index) => tabs[index] == "점퍼"
        //                     ? SizeInfo()
        //                     : tabs[index] == "재킷"
        //                     ? SizeInfo()
        //                     : SizeInfo()),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        bottomNavigationBar: isUpdate == true ? MysizeBottom() : Container(height: 0,),
      ),
    );
  }

  // category 목록
  Widget CategoryItem(String category, int index) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 70,
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
    );
  }

  Widget UpdateForm() {
    return Container(
      child: Column(
        children: [
          SizeForm(title: "품", hintTxt: "", isTextfield: true),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "목둘레", hintTxt: "", isTextfield: true),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "소매길이", hintTxt: "", isTextfield: true),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "민소매 암홀 길이", hintTxt: "", isTextfield: true),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "어깨 길이", hintTxt: "", isTextfield: true),
        ],
      ),
    );
  }

  Widget SizeInfo(){
    return Container(
      child: Column(
        children: [
          SizeForm(title: "품", hintTxt: "101", isTextfield: false),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "목둘레", hintTxt: "32", isTextfield: false),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "소매길이", hintTxt: "24", isTextfield: false),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "민소매 암홀 길이", hintTxt: "15", isTextfield: false),
          SizedBox(
            height: 20,
          ),
          SizeForm(title: "어깨 길이", hintTxt: "15", isTextfield: false),
        ],
      ),
    );
  }


  Widget appbarIcon(){
    return GestureDetector(
      onTap: () {
        setState((){
          isUpdate = true;
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: 20),
        child: SvgPicture.asset(
          "assets/icons/updateIcon.svg",
          color: Colors.black,
        ),
      ),
    );
  }
}
