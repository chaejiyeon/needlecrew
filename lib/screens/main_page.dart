import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/modal/main_home_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

import '../db/wp-api.dart';
import 'main/fix_clothes.dart';
import 'main/main_home.dart';
import 'main/my_page.dart';
import 'main/use_info.dart';


class MainPage extends StatefulWidget {
  final int pageNum;
  final int selectTab;

  const MainPage({Key? key, required this.pageNum, this.selectTab = 0})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final HomeController controller = Get.put(HomeController());
  int _currentIndex = 0;
  final List<Widget> pages = [MainHome(), UseInfo(pageNum: 0), MyPage()];

  @override
  void initState() {

    // controller.getUser();
    super.initState();



    if(homeInitService.mainModalcheck.value == false) {
      // controller.getUser();
      // 메인 홈 진입 시 dialog
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MainHomeModal();
            });
      });
    }

    _currentIndex = widget.pageNum;

    print("tabNum " + widget.selectTab.toString());
    pages[1] = UseInfo(pageNum: widget.selectTab);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: Container(
        width: 80,
        height: 80,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                Get.to(FixClothes());
              });
            },
            backgroundColor: HexColor("#fd9a03"),
            child: Container(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(0),
                      child:SvgPicture.asset(
                          "assets/icons/main/fixclothesIcon.svg",
                          width: 20,
                          height: 20,
                      ),
                  ),
                  Text(
                    "수선하기",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: HexColor("#202427"),
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bottomIcon(0, "홈", "homeIcon.svg"),
              bottomIcon(1, "이용내역", "useinfoIcon.svg"),
              Padding(
                  padding: EdgeInsets.only(
                    right: 100,
                  ),
                  child: bottomIcon(2, "MY", "userIcon.svg")),
            ],
          ),
        ),
      ),
    );
  }

  // bottomNavigation Icon
  Widget bottomIcon(int page, String title, String icon) {
    Color iconColor = Colors.white;
    Color titleColor = Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = page;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10),
        width: 80,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: title == "홈"? 23 : null,
              height: title == "홈"? 23 : null,
              child: SvgPicture.asset(
                'assets/icons/main/' + icon,
                color: _currentIndex == page ? HexColor("#fd9a03") : iconColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: _currentIndex == page ? HexColor("#fd9a03") : titleColor),
            ),
          ],
        ),
      ),
    );
  }
}
