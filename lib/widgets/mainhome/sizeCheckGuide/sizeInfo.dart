import 'package:needlecrew/models/sizeCheckGuideItem.dart';
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

    print(widget.tabItems[currentPage]);
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
                items.length,
                (index) => CategoryItem(items[index].categoryName, index),
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    items.length,
                    (index) => Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child:
                        CategoryImage(items[index].categoryImg)
                            ,
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
    print("$index");
    // print(tabHeader.length);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          height: 40,
          child: Text(
            category,
            style: TextStyle(
              color: _tabController.index == index ? HexColor("fd9a03") : Colors.black,
            ),
          ),
        ),
        items.length - index != 1
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
    return Container(
      child: Image.asset("assets/images/useguide/guideImage/" + img),
    );
  }
}
