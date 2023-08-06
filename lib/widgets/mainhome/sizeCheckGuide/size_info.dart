import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/models/size_check_guide_item.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SizeInfo extends StatefulWidget {
  final List<SizeCheckGuideItem> tabItems;

  const SizeInfo({Key? key, required this.tabItems}) : super(key: key);

  @override
  State<SizeInfo> createState() => _SizeInfoState();
}

class _SizeInfoState extends State<SizeInfo> with TickerProviderStateMixin {
  List<SizeCheckGuideItem> items = [];

  late TabController _tabController =
      TabController(length: widget.tabItems.length, vsync: this);
  int currentPage = 0;

  @override
  void initState() {
    print(widget.tabItems.length);
    super.initState();
    items = widget.tabItems;
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
    return Container(
      child: Column(
        children: [
          Container(
            child: TabBar(
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide.none,
              ),
              tabs: List.generate(
                widget.tabItems.length,
                (index) =>
                    CategoryItem(widget.tabItems[index].categoryName, index),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  widget.tabItems.length,
                  (index) => Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 450.h,
                      child: CategoryImage(widget.tabItems[index].categoryImg),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // category 목록
  Widget CategoryItem(String category, int index) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          height: 40,
          child: Text(
            category,
            style: TextStyle(
              color: _tabController.index == index
                  ? HexColor("fd9a03")
                  : Colors.black,
            ),
          ),
        ),
        widget.tabItems.length - index != 1
            ? Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 20,
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                  color: HexColor("#909090"),
                ))),
              )
            : Container(),
      ],
    );
  }

  Widget CategoryImage(String img) {
    return SingleChildScrollView(
      child: Image.asset(
        width: 327.w,
        "assets/images/useguide/guideImage/" + img,
        fit: BoxFit.fill,
      ),
    );
  }
}
