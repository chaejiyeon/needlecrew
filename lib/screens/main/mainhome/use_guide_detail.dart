import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:needlecrew/controller/page_controller/use_guide_detail_controller.dart';
import 'package:needlecrew/models/use_guide_shopping.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/mainhome/useguide/use_guide_tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class UseGuideDetail extends StatelessWidget {
  final String guide;

  const UseGuideDetail({Key? key, required this.guide}) : super(key: key);

  // late TabController _tabcontroller = TabController(length: 5, vsync: this);
  // final scrollCotroller = ScrollController();

  // List<String> items = ["쇼핑몰에서 보낼 경우", "집에서 보낼 경우"];
  // String selectValue = "쇼핑몰에서 보낼 경우";

  // late VerticalScrollPosition position = VerticalScrollPosition.begin;

  // @override
  // void initState() {
  //   super.initState();
  //   setState((){
  //     selectValue = widget.guide;
  //   });
  //
  //   _tabcontroller = TabController(length: 5, vsync: this);
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _tabcontroller.dispose();
  //   scrollCotroller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final UseGuideDetailController controller =
        Get.put(UseGuideDetailController());
    controller.selectValue.value = guide;

    int currentTab = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              )),
        ),
        backgroundColor: Colors.white,
        title: Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 70),
                      child: Text(
                        "이용가이드",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
        actions: [
          AppbarItem(
              icon: "cartIcon.svg",
              iconColor: Colors.black,
              iconFilename: "main",
              widget: CartInfo()),
          AppbarItem(
              icon: "alramIcon.svg",
              iconColor: Colors.black,
              iconFilename: "main",
              widget: AlramInfo()),
        ],
      ),
      body: Obx(
        () => VerticalScrollableTabView(
          tabController: controller.tabController.value.value!,
          listItemData: controller.selectValue.value == "쇼핑몰에서 보낼 경우"
              ? shoppingsteps
              : homesteps,
          verticalScrollPosition: controller.verticalPosition.value.value!,
          eachItemChild: (object, index) =>
              UseGuideTabView(step: index, items: object as UseGuideShopping),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 100.0,
              leadingWidth: 0,
              titleSpacing: 0,
              title: Container(
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 18),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          "니들크루 이용하기",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          value: controller.selectValue.value.isNotEmpty
                              ? controller.selectValue.value
                              : null,
                          onChanged: (value) {
                            // setState(() {
                            // currentTab = value as int;
                            controller.selectValue.value = value as String;
                            // });
                          },
                          hint: Text(
                            controller.items[0],
                            style: TextStyle(fontSize: 14),
                          ),
                          items: controller.items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          buttonWidth: 166,
                          buttonHeight: 36,
                          buttonPadding: EdgeInsets.only(left: 10, right: 14),
                          buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: HexColor("#f7f7f7")),
                          icon: SvgPicture.asset(
                            "assets/icons/dropdownIcon.svg",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
              bottom: DecoratedTabBar(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: HexColor("#d5d5d5")))),
                tabBar: TabBar(
                  isScrollable: true,
                  controller: controller.tabController.value.value!,
                  // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  indicatorColor: HexColor("#fd9a03"),
                  labelColor: HexColor("#fd9a03"),
                  unselectedLabelColor: HexColor("#909090"),
                  indicatorWeight: 1.0,
                  tabs: controller.selectValue.value == "쇼핑몰에서 보낼 경우"
                      ? shoppingsteps.map((e) {
                          return Tab(
                            text: "STEP" + e.step.toString(),
                          );
                        }).toList()
                      : homesteps.map((e) {
                          return Tab(
                            text: "STEP" + e.step.toString(),
                          );
                        }).toList(),
                  onTap: (index) {
                    VerticalScrollableTabBarStatus.setIndex(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // setState(() {
          controller.tabController.value.value!.animateTo(0,
              duration: Duration(seconds: 3), curve: Curves.easeIn);
          // });

          VerticalScrollableTabBarStatus.setIndex(0);

          print("upbtn click!!!!  ");
        },
        child: SvgPicture.asset("assets/icons/upIcon.svg"),
      ),
    );
  }
}

// tabbar 밑줄 표시
class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  final BoxDecoration decoration;

  DecoratedTabBar({required this.tabBar, required this.decoration});

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}
