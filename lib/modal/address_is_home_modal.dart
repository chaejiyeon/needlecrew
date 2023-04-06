import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/widgets/font_style.dart';

class AddressIsHomeModal extends StatelessWidget {
  const AddressIsHomeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: 300,
        height: 174,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 43, left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "쇼핑몰에서 의류를 보낼 경우 \n'기장 수선'만 이용하실 수 있습니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: HexColor("#ededed")),
              )),
              child: TextButton(
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Get.back();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
