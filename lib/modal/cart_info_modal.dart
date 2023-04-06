import 'package:needlecrew/screens/main/fixClothes/address_info.dart' as cart_info_modal;
import 'package:needlecrew/screens/main/fixClothes/address_insert.dart';
import 'package:needlecrew/screens/main/fixClothes/choose_clothes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CartInfoModal extends StatelessWidget {
  const CartInfoModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {Get.back();},
                    icon: Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                    ))),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FontStyle(
                            text: "다른 의류는 수선이 필요없으신가요?",
                            fontsize: "md",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "필요없으시다면 '다음 단계'를 눌러주세요!",
                          style: TextStyle(color: HexColor("#909090")),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(color: HexColor("#d5d5d5")),
                              right: BorderSide(color: HexColor("#d5d5d5")),
                            )),
                            child: TextButton(
                                child: Text(
                                  "수선할게요!",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Get.to(ChooseClothes());
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(color: HexColor("#d5d5d5")),
                            )),
                            child: TextButton(
                                child: Text("다음단계",
                                    style:
                                        TextStyle(color: HexColor("#fd9a03"))),
                                onPressed: () {
                                  Get.off(() => AddressInsert());
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
