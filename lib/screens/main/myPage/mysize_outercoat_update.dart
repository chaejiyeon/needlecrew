import 'package:get/get.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/myPage/mysize_bottom.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../main_home.dart';

class MysizeOutercoatUpdate extends StatefulWidget {
  const MysizeOutercoatUpdate({Key? key}) : super(key: key);

  @override
  State<MysizeOutercoatUpdate> createState() => _MysizeOutercoatUpdateState();
}

class _MysizeOutercoatUpdateState extends State<MysizeOutercoatUpdate>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.find();
  late TabController tabController;
  List tabs = ["점퍼", "재킷", "코트"];
  List sizeInfo = ["총 길이", "품", "소매 길이", "소매 통", "어깨 길이", "민소매 암홀 길이"];

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
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
              fontcolor: Colors.black,
              textdirectionright: false),
          actions: [
            isUpdate == false
                ? appbarIcon()
                : Container(
                    height: 0,
                  ),
          ],
        ),
        body: Column(
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
              child: StreamBuilder(
                stream: Stream.periodic(
                  Duration(seconds: 1),
                ).asyncMap(
                    (event) => homeController.getSize(tabs[currentPage])),
                builder: (context, snapshot) {
                  return Container(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: isUpdate == true
                                ? TabBarView(
                                    controller: tabController,
                                    children: List.generate(
                                        tabs.length,
                                        (index) => tabs[index] == "점퍼"
                                            ? UpdateForm()
                                            : tabs[index] == "재킷"
                                                ? UpdateForm()
                                                : UpdateForm()),
                                  )
                                : TabBarView(
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
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: isUpdate == true
            ? MysizeBottom()
            : Container(
                height: 0,
              ),
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
        children: List.generate(
          sizeInfo.length,
          (index) =>
              SizeForm(title: sizeInfo[index], hintTxt: "", isTextfield: true),
        ),
      ),
    );
  }

  Widget SizeInfo() {
    return Container(
        child: Column(
      children: List.generate(
        sizeInfo.length,
        (index) => SizeForm(
            title: sizeInfo[index],
            hintTxt: homeController.getsizeInfo.length == 0
                ? "0"
                : homeController.getsizeInfo[index],
            isTextfield: false),
      ),
    ));
  }

  Widget appbarIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
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
