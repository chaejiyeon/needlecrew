import 'package:needlecrew/getxController/fixClothes/fixselectController.dart';
import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/screens/main/fixClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/chooseClothes.dart';
import 'package:needlecrew/screens/main/fixClothes/takeFixInfo.dart';
import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FixClothesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;
  final String prev;

  const FixClothesAppBar({Key? key, required this.appbar, this.prev = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FixSelectController controller = Get.put(FixSelectController());

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          CupertinoIcons.chevron_back,
          color: Colors.black,
        ),
        onPressed: () {
          print("this get back pressed!!!!!!!");
          Get.back();

          if (prev == "의류 선택") {
            print("this crumbs info    " + controller.crumbs.toString());

            if (controller.crumbs.length == 0)
              Get.to(FixClothes());
            else {

              controller.backClick.value = true;

              // back버튼 클릭시 crumbs 마지막 카테고리 Id remove
              if(controller.crumbs.length > 0) controller.crumbs.removeLast();


              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseClothes(
                            parentNum: controller.crumbs.length > 0
                                ? controller.crumbs.last
                                : 0,
                          )));
            }
          } else if (prev == "옷바구니" || prev == "출발지") {
            Get.toNamed("/mainHome");
          } else if(prev == "수거 알림"){
            Get.off(() => TakeFixInfo());
          }
        },
      ),
      actions: [
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Get.back();
                Get.to(MainPage(pageNum: 0));
              },
              child: SvgPicture.asset(
                "assets/icons/main/homeIcon.svg",
                color: Colors.black,
              ),
            )),
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(CartInfo());
              },
              child: SvgPicture.asset(
                "assets/icons/main/cartIcon.svg",
                color: Colors.black,
              ),
            )),
        Container(
            width: 23,
            height: 23,
            margin: EdgeInsets.only(right: 26),
            // padding: EdgeInsets.only(left: 10, right: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(AlramInfo());
              },
              child: SvgPicture.asset(
                "assets/icons/main/alramIcon.svg",
                color: Colors.black,
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}
