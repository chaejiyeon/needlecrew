import 'package:needlecrew/getxController/useInfo/useInfoController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/mainhome/useinfo/useAppbar.dart';
import 'package:needlecrew/widgets/mainhome/useinfo/userInfoList.dart';
import 'package:shimmer/shimmer.dart';

class UseInfo extends StatefulWidget {
  final int pageNum;

  const UseInfo({Key? key, required this.pageNum}) : super(key: key);

  @override
  State<UseInfo> createState() => _UseInfoState();
}

class _UseInfoState extends State<UseInfo> with TickerProviderStateMixin {
  final UseInfoController controller = Get.put(UseInfoController());

  List<String> img = [
    "assets/images/guideImage_3.png",
    "assets/images/useInfoImage_2.png",
    "assets/images/useInfoImage_3.png"
  ];
  late TabController _tabController = TabController(length: 3, vsync: this);

  late Future myFuture;

  int tabIndex = 0;
  int initTab = 0;

  // late Future myFuture;

  @override
  void initState() {
    myFuture = controller.getCompleteOrder();
    // controller.getCompleteOrder();
    super.initState();
    print("pageNum " + widget.pageNum.toString());

    if (widget.pageNum >= 0) {
      setState(() {
        tabIndex = widget.pageNum;
      });
    }
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: tabIndex);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("imgindex : $tabIndex");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          UseAppBar(title: "나의 이용내역", appbarcolor: "black", appbar: AppBar()),
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
                heightFactor: 5,
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 10),
                    height: 70,
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                              color: HexColor("#fd9a03").withOpacity(0.2),
                              width: 2),
                        ),
                      ),
                      child: TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        unselectedLabelColor: HexColor("#909090"),
                        unselectedLabelStyle: TextStyle(fontSize: 16),
                        indicatorColor: HexColor("#fd9a03"),
                        controller: _tabController,
                        tabs: [
                          Tab(text: "수선 대기"),
                          Tab(text: "수선 진행중"),
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
              child:
                  Obx(() {
                if (controller.isInitialized.value) {
                  print("this state count " +
                      controller.readyLists.length.toString());
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      UseInfoList(
                          fixState: "ready",
                          fixItems: controller.readyLists,
                          myFuture: myFuture),
                      UseInfoList(
                          fixState: "progress",
                          fixItems: controller.progressLists,
                          myFuture: myFuture),
                      UseInfoList(
                          fixState: "complete",
                          fixItems: controller.completeLists,
                          myFuture: myFuture),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
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
              FutureBuilder(
                  future: myFuture,
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.connectionState == ConnectionState.waiting;

                    return isLoading
                        ? countSkeleton()
                        : Text(
                            content == "수선 대기"
                                ? controller.readyLists.length.toString()
                                : content == "수선 진행중"
                                    ? controller.progressLists.length.toString()
                                    : controller.completeLists.length
                                        .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          );
                  }),

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
