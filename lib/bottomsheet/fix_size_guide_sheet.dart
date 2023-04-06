import 'package:needlecrew/models/size_check_guide_item.dart';
import 'package:needlecrew/widgets/mainhome/sizeCheckGuide/size_info.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FixSizeQuideSheet extends StatefulWidget {
  const FixSizeQuideSheet({Key? key}) : super(key: key);

  @override
  State<FixSizeQuideSheet> createState() => _FixSizeQuideSheetState();
}

class _FixSizeQuideSheetState extends State<FixSizeQuideSheet>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  List<String> tabHeader = [
    "상의",
    "하의",
    "원피스",
    "아우터",
    "스커트",
  ];

  List<SizeCheckGuideItem> shirtItems = [
    SizeCheckGuideItem(1, "총 기장 줄임", "guideImageItem_1.png"),
    SizeCheckGuideItem(1, "전체 폭 줄임", "guideImageItem_2.png"),
    SizeCheckGuideItem(1, "목 둘레 줄임", "guideImageItem_3.png"),
    SizeCheckGuideItem(1, "소매 기장 줄임", "guideImageItem_4.png"),
    SizeCheckGuideItem(1, "소매 통 줄임", "guideImageItem_5.png"),
    SizeCheckGuideItem(1, "암홀 줄임", "guideImageItem_6.png"),
    SizeCheckGuideItem(1, "어깨 줄임", "guideImageItem_7.png"),
  ];

  List<SizeCheckGuideItem> pantsItems = [
    SizeCheckGuideItem(2, "총 기장 줄임", "guideImageItem_pants_1.png"),
    SizeCheckGuideItem(2, "밑위 기장", "guideImageItem_pants_2.png"),
    SizeCheckGuideItem(2, "허리 길이", "guideImageItem_pants_3.png"),
    SizeCheckGuideItem(2, "힙", "guideImageItem_pants_4.png"),
    SizeCheckGuideItem(2, "통", "guideImageItem_pants_5.png"),
  ];

  List<SizeCheckGuideItem> outerItems = [
    SizeCheckGuideItem(4, "총 기장 줄임", "guideImageItem_outer_1.png"),
    SizeCheckGuideItem(4, "전체 품 줄임", "guideImageItem_outer_2.png"),
    SizeCheckGuideItem(4, "소매 기장", "guideImageItem_outer_3.png"),
    SizeCheckGuideItem(4, "소매 통", "guideImageItem_outer_4.png"),
    SizeCheckGuideItem(4, "어깨 줄임", "guideImageItem_outer_5.png"),
  ];

  List<SizeCheckGuideItem> skirtItems = [
    SizeCheckGuideItem(2, "총 기장 줄임", "guideImageItem_skirt_1.png"),
    SizeCheckGuideItem(2, "허리 길이", "guideImageItem_skirt_2.png"),
    SizeCheckGuideItem(2, "힙", "guideImageItem_skirt_3.png"),
    SizeCheckGuideItem(2, "통", "guideImageItem_skirt_4.png"),
  ];

  List<SizeCheckGuideItem> onepieceItems = [
    SizeCheckGuideItem(3, "총 기장 줄임", "guideImageItem_onepiece_1.png"),
    SizeCheckGuideItem(3, "품", "guideImageItem_onepiece_2.png"),
    SizeCheckGuideItem(3, "소매 기장 줄임", "guideImageItem_onepiece_3.png"),
    SizeCheckGuideItem(3, "소매 통", "guideImageItem_onepiece_4.png"),
    SizeCheckGuideItem(3, "암홀", "guideImageItem_onepiece_5.png"),
    SizeCheckGuideItem(3, "어깨 줄임", "guideImageItem_onepiece_6.png"),
  ];

  late TabController _tabController =
      TabController(length: tabHeader.length, vsync: this);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      setState(() {
        currentPage = _tabController.index;
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
    return ListView(
      padding: EdgeInsets.only(left: 24, right: 24),
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          margin: EdgeInsets.only(bottom: 20),
          height: 70,
          child: TabBar(
            padding: EdgeInsets.zero,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
            controller: _tabController,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide.none,
            ),
            tabs: List.generate(
              tabHeader.length,
              (index) => CategoryItem(tabHeader[index], index),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: _tabController,
            children: List.generate(
                tabHeader.length,
                (index) => tabHeader[index] == "상의"
                    ? SizeInfo(
                        tabItems: shirtItems,
                      )
                    : tabHeader[index] == "하의"
                        ? SizeInfo(tabItems: pantsItems)
                        : tabHeader[index] == "원피스"
                            ? SizeInfo(tabItems: onepieceItems)
                            : tabHeader[index] == "스커트"
                                ? SizeInfo(tabItems: skirtItems)
                                : tabHeader[index] == "아우터"
                                    ? SizeInfo(tabItems: outerItems)
                                    : Container()),
          ),
        ),
      ],
    );
  }

  // category 목록
  Widget CategoryItem(String category, int index) {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22),
      alignment: Alignment.center,
      height: 60,
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
          fontSize: 14,
          color: currentPage == index ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
