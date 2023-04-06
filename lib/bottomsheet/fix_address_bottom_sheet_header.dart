import 'package:needlecrew/bottomsheet/address_insert.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FixAddressBottomSheetHeader extends StatefulWidget {
  final bool addressExist;

  const FixAddressBottomSheetHeader({Key? key, required this.addressExist})
      : super(key: key);

  @override
  State<FixAddressBottomSheetHeader> createState() =>
      _FixAddressBottomSheetHeaderState();
}

class _FixAddressBottomSheetHeaderState
    extends State<FixAddressBottomSheetHeader> {
  void bottomsheetOpen(BuildContext context) {
    showStickyFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 0.9,
        maxHeight: 0.9,
        context: context,
        bottomSheetColor: HexColor("#909090").withOpacity(0.2),
        decoration: BoxDecoration(
          color: HexColor("#f5f5f5"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        headerHeight: 100,
        headerBuilder: (context, offset) {
          return widget.addressExist == true
              ? addressListHeader("주소 관리")
              : addressListHeader("주소 등록");
        },
        bodyBuilder: (context, offset) {
          print("init");
          return SliverChildListDelegate([
            widget.addressExist == true
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: AddressInsert())
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: 7,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FontStyle(
                        text: "내 주소",
                        fontsize: "md",
                        fontbold: "bold",
                        fontcolor: Colors.black,
                        textdirectionright: false),

                    // 주소가 있을때, 없을 때 구분 해야함
                    widget.addressExist == true
                        ? GestureDetector(
                            onTap: () {
                              bottomsheetOpen(context);
                            },
                            child: FontStyle(
                              text: "편집",
                              fontcolor: Colors.black,
                              fontbold: "",
                              textdirectionright: false,
                              fontsize: "",
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              bottomsheetOpen(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.plus_circle,
                                  color: HexColor("#fd9a03"),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                FontStyle(
                                    text: "등록하기",
                                    fontsize: "md",
                                    fontbold: "",
                                    fontcolor: HexColor("#fd9a03"),
                                    textdirectionright: false)
                              ],
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: HexColor("#d5d5d5").withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 주소가 있을 경우 / 없을 경우 header
  Widget addressListHeader(String title) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 60,
            height: 5,
            decoration: BoxDecoration(
                color: HexColor("#707070"),
                borderRadius: BorderRadius.circular(5)),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 8, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(CupertinoIcons.back)),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: FontStyle(
                            text: title,
                            fontsize: "md",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false))),
                Container(
                  width: 50,
                ),
              ],
            ),
          ),
          title == "주소 등록"
              ? ListLine(
                  height: 1,
                  width: double.infinity,
                  lineColor: HexColor("#d5d5d5"),
                  opacity: 0.5)
              : Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: ListLine(
                      height: 1,
                      width: double.infinity,
                      lineColor: HexColor("#d5d5d5"),
                      opacity: 0.5),
                ),
        ],
      ),
    );
  }
}
