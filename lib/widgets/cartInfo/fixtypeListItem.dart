import 'package:intl/intl.dart';
import 'package:needlecrew/modal/tearIconModal.dart';
import 'package:needlecrew/models/cartItemModel.dart';
import 'package:needlecrew/screens/main/fixClothes/fixUpdate.dart';
import 'package:needlecrew/widgets/fixClothes/listLine.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../getxController/fixClothes/cartController.dart';

class FixTypeListItem extends StatefulWidget {
  final int index;
  // final List<LineItems> lineItem;
  final CartItem cartItem;

  const FixTypeListItem({Key? key, required this.cartItem, required this.index}) : super(key: key);

  @override
  State<FixTypeListItem> createState() => _FixTypeListItemState();
}

class _FixTypeListItemState extends State<FixTypeListItem> {
  final CartController controller = Get.put( CartController());



  List<String> images = [
    "sample_2.jpeg",
    "sample_2.jpeg",
    "sample_3.jpeg",
  ];
  bool ischecked = false;







  // 금액 단위 변환
  String setPrice(int price) {
    String setPrice = NumberFormat('###,###,###').format(price);
    return setPrice;
  }


  @override
  void initState(){

    for(int i=0; i<controller.orderid.length; i++){
      if(controller.orderid[i] == controller.orders[widget.index].id){
        setState((){ischecked = true;});
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.isInitialized.value) {
              return checkBoxCustom("");
            } else {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
          }),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image slide
                Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 150,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(images.length,
                            (index) => ImageItem(images[index])))),
                SizedBox(
                  height: 10,
                ),

                // detail info
                FontStyle(
                    text: widget.cartItem.cartProductName,
                    fontsize: "md",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                SizedBox(
                  height: 10,
                ),
                detailInfo("의뢰 방법", widget.cartItem.cartWay),
                detailInfo("치수", widget.cartItem.cartSize + "cm"),
                detailInfo("추가 설명", widget.cartItem.cartContent),
                detailInfo("물품 가액", setPrice(int.parse(widget.cartItem.guaranteePrice)) + "원"),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ListLine(
                      height: 2,
                      width: double.infinity,
                      lineColor: HexColor("#909090"),
                      opacity: 0.2),
                ),
                priceInfo("의뢰 예상 비용", setPrice(int.parse(widget.cartItem.productPrice)) , true, false),
                priceInfo("배송 비용", "6,000", true, false),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fixBtn("삭제", TearIconModal(title: "선택한 의뢰를 삭제할까요?", btnText1: "취소", btnText2: "삭제")),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(child: fixBtn("의뢰 수정", FixUpdate())),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // checkbox custom
  Widget checkBoxCustom(String text) {
    return GestureDetector(
      onTap: () {

        if(ischecked == true) {
          setState((){ischecked = false;});
          controller.iswholePrice(ischecked, int.parse(widget.cartItem.productPrice));
          controller.isOrderId(ischecked, controller.orders[widget.index].id!);
        }
        else if(ischecked == false) {
          setState((){ischecked = true;});
          controller.iswholePrice(ischecked, int.parse(widget.cartItem.productPrice));
          controller.isOrderId(ischecked, controller.orders[widget.index].id!);
        }
      },
      child:  Container(
        margin: EdgeInsets.only(top: 15),
          child: Row(
            children: [
              ischecked == false
                  ? Container(width: 22, height: 22, child: Image.asset("assets/icons/checkBtnIcon.png"))
                  : Container(width: 22, height: 22, child: Image.asset("assets/icons/selectCheckIcon.png")),
              SizedBox(width: 7,),
              Text(
                text,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
    );
  }


  
  // slider Image Item
  Widget ImageItem(String image) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/" + image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  // detail 목록
  Widget detailInfo(String title, String content) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FontStyle(
              text: title + " : ",
              fontsize: "",
              fontbold: "bold",
              fontcolor: Colors.black,
              textdirectionright: false),
          Expanded(child: Text(content))
        ],
      ),
    );
  }

  // 비용 목록
  Widget priceInfo(String title, String price, bool infoIcon, bool wholePrice) {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Row(
              children: [
                FontStyle(
                    text: title,
                    fontsize: "",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                SizedBox(
                  width: 5,
                ),
                infoIcon == true
                    ? Icon(
                        CupertinoIcons.question_circle,
                        color: HexColor("#909090"),
                        size: 20,
                      )
                    : Container(),
              ],
            ),
          ),
          Row(
            children: [
              FontStyle(
                  text: price,
                  fontsize: "",
                  fontbold: "bold",
                  fontcolor:
                      wholePrice == true ? HexColor("#fd9a03") : Colors.black,
                  textdirectionright: false),
              FontStyle(
                  text: "원",
                  fontsize: "",
                  fontbold: "",
                  fontcolor: Colors.black,
                  textdirectionright: false),
            ],
          ),
        ],
      ),
    );
  }

  // 삭제 / 수정 버튼
  Widget fixBtn(String text, Widget widget) {
    return GestureDetector(
      onTap: () {
        text == "삭제" ? Get.dialog(widget) : Get.to(widget);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: HexColor("#d5d5d5"),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
