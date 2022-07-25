import 'package:get/get.dart';
import 'package:needlecrew/getxController/fixClothes/fixselectController.dart';
import 'package:needlecrew/screens/main/fixClothes/imageUpload.dart';
import 'package:needlecrew/widgets/baseAppbar.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fixClothes/circleLineTextField.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/insertForm.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FixQuestion extends StatefulWidget {
  const FixQuestion({Key? key}) : super(key: key);

  @override
  State<FixQuestion> createState() => _FixQuestionState();
}

class _FixQuestionState extends State<FixQuestion> {
  final int maxLines = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appbar: AppBar(),
      ),


      body: InsertForm(iconImage: "cameraIcon.svg",titleText: "수선 문의하기",hintText: "내용을 입력해주세요."),


      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: CircleBlackBtn(btnText: "문의하기", pageName: "/mainHome"),
      ),
    );
  }
}
