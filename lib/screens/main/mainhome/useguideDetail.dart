import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:needlecrew/models/useguideShopping.dart';
import 'package:needlecrew/screens/main/alramInfo.dart';
import 'package:needlecrew/screens/main/cartInfo.dart';
import 'package:needlecrew/widgets/appbarItem.dart';
import 'package:needlecrew/widgets/mainhome/useguide/useguideTabview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class UseGuideDetail extends StatefulWidget {
  final String guide;
  const UseGuideDetail({Key? key, required this.guide}) : super(key: key);

  @override
  State<UseGuideDetail> createState() => _UseGuideDetailState();
}

class _UseGuideDetailState extends State<UseGuideDetail>
    with TickerProviderStateMixin {
  late TabController _tabcontroller = TabController(length: 5, vsync: this);
  final scrollCotroller = ScrollController();

  List<String> items = ["쇼핑몰에서 보낼 경우", "집에서 보낼 경우"];
  String selectValue = "쇼핑몰에서 보낼 경우";


  late VerticalScrollPosition position = VerticalScrollPosition.begin;

  @override
  void initState() {
    super.initState();
    setState((){
      selectValue = widget.guide;
    });

    _tabcontroller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabcontroller.dispose();
    scrollCotroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: VerticalScrollableTabView(
        tabController: _tabcontroller,
        listItemData: selectValue == "쇼핑몰에서 보낼 경우" ? shoppingsteps : homesteps,
        verticalScrollPosition: position,
        eachItemChild: (object, index) => UseGuideTabView(
            step: index,
            items: object as UseGuideShopping),
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
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      value: selectValue.isNotEmpty ? selectValue : null,
                      onChanged: (value) {
                        setState(() {
                          // currentTab = value as int;
                          selectValue = value as String;
                        });
                      },
                      hint: Text(
                        items[0],
                        style: TextStyle(fontSize: 14),
                      ),
                      items: items
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
                controller: _tabcontroller,
                // indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                indicatorColor: HexColor("#fd9a03"),
                labelColor: HexColor("#fd9a03"),
                unselectedLabelColor: HexColor("#909090"),
                indicatorWeight: 1.0,
                tabs: selectValue == "쇼핑몰에서 보낼 경우" ? shoppingsteps.map((e) {
                  return Tab(
                    text: "STEP" + e.step.toString(),
                  );
                }).toList() : homesteps.map((e) {
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
      floatingActionButton: GestureDetector(
        onTap: () {
          setState((){
            _tabcontroller.animateTo(1,duration: Duration(seconds: 3),curve: Curves.easeIn);
          });

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
