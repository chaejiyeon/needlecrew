import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';


class AlramDeleteModal extends StatelessWidget {
  const AlramDeleteModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        width: 297,
        height: 174,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: "선택한 알림을 삭제하시겠습니까?",
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,textdirectionright: false),
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
                            top: BorderSide(color: HexColor("#ededed")),
                            right: BorderSide(color: HexColor("#ededed")),
                          )),
                      child: TextButton(child: Text("취소",style: TextStyle(color: Colors.black),), onPressed: () {
                        Get.back();
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor("#ededed")),
                          )),
                      child: TextButton(child: Text("삭제",style: TextStyle(color: Colors.black)), onPressed: () {}),
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
