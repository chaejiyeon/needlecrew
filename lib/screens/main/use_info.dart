import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/update_widgets/use_info/use_info_empty.dart';
import 'package:needlecrew/widgets/update_widgets/use_info/use_info_list_item.dart';
import 'package:shimmer/shimmer.dart';

class UseInfo extends StatefulWidget {
  final int pageNum;

  const UseInfo({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<UseInfo> createState() => _UseInfoState();
}

class _UseInfoState extends State<UseInfo> with TickerProviderStateMixin {
  int tabIndex = 0;
  int initTab = 0;

  List<String> img = [
    "assets/images/guideImage_3.png",
    "assets/images/useInfoImage_2.png",
    "assets/images/useInfoImage_3.png"
  ].obs;

  late TabController tabController = TabController(length: 3, vsync: this);
  final UseInfoController controller = Get.find();

  @override
  void initState() {
    super.initState();
    print("pageNum " + widget.pageNum.toString());

    if (widget.pageNum >= 0) {
      setState(() {
        tabIndex = widget.pageNum;
      });
    }
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        appbarcolor: "black",
        appbar: AppBar(),
        showLeadingBtn: false,
        title: '나의 이용내역',
        actionItems: [
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: Colors.white,
            iconFilename: 'main',
            function: () {
              Get.close(1);
              Get.to(CartInfo());
            },
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: Colors.white,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    child: Image.asset(
                      img[tabIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 350,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/overlayImage.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              Positioned(
                left: 61,
                right: 62,
                bottom: 120,
                child: Container(
                  width: 251,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconStyle("bookIcon.svg", "useinfo"),
                            dotLine(),
                            iconStyle("fixclothesIcon.svg", "main"),
                            dotLine(),
                            iconStyle("useClothesIcon.svg", "useinfo"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          iconWrap("수선 대기"),
                          iconWrap("수선 진행중"),
                          iconWrap("수선 완료"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // tab명
              Align(
                heightFactor: 6,
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 24.w, right: 24.w, top: 30.h),
                    height: 60,
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                              color: SetColor().mainColor.withOpacity(0.1),
                              width: 2),
                        ),
                      ),
                      child: TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        labelColor: Colors.black,
                        unselectedLabelColor: SetColor().color90,
                        unselectedLabelStyle: TextStyle(fontSize: 16),
                        indicatorColor: SetColor().mainColor,
                        indicatorPadding: EdgeInsets.only(bottom: -1.5),
                        controller: tabController,
                        tabs: [
                          Tab(text: "수선 대기"),
                          Container(
                            width: double.infinity,
                            child: Stack(children: [
                              controller.widgetUpdate.value == true
                                  ? Positioned(
                                      right: 7,
                                      top: 15,
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor("#fd9a03")),
                                      ),
                                    )
                                  : Container(),
                              Align(
                                  alignment: Alignment.center,
                                  child: Tab(text: "수선 진행중"))
                            ]),
                          ),
                          Tab(text: "수선 완료"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // tab별 화면
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              margin: EdgeInsets.only(bottom: 25.h),
              child: TabBarView(
                controller: tabController,
                children: List.generate(
                    tabController.length,
                    (index) => tabIndex == 0
                        ? Obx(
                            () => controller.readyLists.length > 0
                                ? ListView(
                                    padding: EdgeInsets.zero,
                                    children: List.generate(
                                      controller.readyLists.length,
                                      (index) => Obx(
                                        () => UseInfoListItem(
                                            order:
                                                controller.readyLists[index]),
                                      ),
                                    ),
                                  )
                                : UseInfoEmpty(orderState: 'ready'),
                          )
                        : tabIndex == 1
                            ? Obx(
                                () => controller.progressLists.length > 0
                                    ? ListView(
                                        padding: EdgeInsets.zero,
                                        children: List.generate(
                                          controller.progressLists.length,
                                          (index) => Obx(
                                            () => UseInfoListItem(
                                                order: controller
                                                    .progressLists[index]),
                                          ),
                                        ),
                                      )
                                    : UseInfoEmpty(orderState: 'ready'),
                              )
                            : Obx(
                                () => controller.completeLists.length > 0
                                    ? ListView(
                                        padding: EdgeInsets.zero,
                                        children: List.generate(
                                          controller.completeLists.length,
                                          (index) => Obx(
                                            () => UseInfoListItem(
                                                order: controller
                                                    .completeLists[index]),
                                          ),
                                        ),
                                      )
                                    : UseInfoEmpty(orderState: 'ready'),
                              )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // icon style 설정
  Widget iconStyle(String icon, String filename) {
    return SvgPicture.asset(
      "assets/icons/" + filename + "/" + icon,
      width: 32,
      height: 39,
    );
  }

  // icon 사이 바
  Widget barDot() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      height: 1,
      width: 5,
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  // icon, 건수, title 전체 wrap
  Widget iconWrap(String content) {
    Color fontcolor = Colors.white;
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  content == "수선 대기"
                      ? controller.readyLists.length.toString()
                      : content == "수선 진행중"
                          ? controller.progressLists.length.toString()
                          : controller.completeLists.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                "건",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // bar dot
  Widget dotLine() {
    return Container(
        height: 50,
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [barDot(), barDot(), barDot(), barDot()],
        ));
  }

  Widget countSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        width: 10,
        height: 21,
        color: Colors.grey,
      ),
    );
  }
}
