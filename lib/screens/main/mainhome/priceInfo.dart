import 'package:needlecrew/widgets/mainhome/priceInfo/priceDropdown.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/priceInfoheader.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/tableHeader.dart';
import 'package:needlecrew/widgets/mainhome/priceInfo/tableListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/mainhome/useinfo/useAppbar.dart';

class PriceInfo extends StatefulWidget {
  const PriceInfo({Key? key}) : super(key: key);

  @override
  State<PriceInfo> createState() => _PriceInfoState();
}

class _PriceInfoState extends State<PriceInfo> {
  final scrollCotroller = ScrollController();

  late Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    scrollCotroller.addListener(listenScrolling);
  }


  @override
  void dispose() {
    super.dispose();
    scrollCotroller.dispose();
  }


  void listenScrolling() {
    if (scrollCotroller.position.atEdge) {
      final isTop = scrollCotroller.position.pixels == 0;
      setState((){
        color = Colors.transparent;
      });
      if (isTop) {
        print("start");
      } else if (scrollCotroller.position.pixels >= 100) {
        setState((){
          color = Colors.white;
        });
      } else {
        print("end");
        setState((){
          color = Colors.transparent;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: UseAppBar(title: "이용 가이드", appbarcolor: color == Colors.white ? "white" : "black", appbar: AppBar(),),
      body: ListView(
        padding: EdgeInsets.zero,
        controller: scrollCotroller,
        children: [
          PriceInfoHeader(bannerImg: "guideImage_2.png",mainText1: "믿을 수 있는 품질과",mainText2: "합리적인 가격으로 만나보세요!", titleText: "니들크루 수선 가격표", subtitle: "아래의 카테고리를 선택 후 가격을 확인해주세요!",),

          Container(
            child: Column(
              children: [
                PriceDropDown(
                  hint: "",
                  hintCheck: false,
                  selectNum: 1,
                ),
                PriceDropDown(
                  hint: "",
                  hintCheck: false,
                  selectNum: 2,
                ),
                PriceDropDown(
                  hint: "",
                  hintCheck: false,
                  selectNum: 3,
                ),
              ],
            ),
          ),

          // table header
          Container(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Row(
              children: [
                TableHeader(width: 80, borderColor: HexColor("#fd9a03").withOpacity(0.6), text: "종류"),
                Expanded(child: TableHeader(width: double.infinity, borderColor: HexColor("#fd9a03").withOpacity(0.2), text: "수선")),
                TableHeader(width: 80, borderColor: HexColor("#fd9a03").withOpacity(0.2), text: "가격"),
              ],
            ),
          ),

          Container(
              child: Column(
            children: [
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
              TableListItem(type: "일반바지", fixInfo: "기장-총 기장 줄임", price: "5,000"),
            ],
          )),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          scrollCotroller.animateTo(0, duration: Duration(milliseconds: 1), curve: Curves.linear);
        },
        child: SvgPicture.asset("assets/icons/upIcon.svg"),
      ),
    );
  }
}
