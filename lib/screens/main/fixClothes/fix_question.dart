import 'package:get/get.dart';
import 'package:needlecrew/widgets/base_appbar.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/fixClothes/insert_form.dart';
import 'package:flutter/material.dart';

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
      appBar: BaseAppbar(
        appbar: AppBar(),
        prevFunction: () => Get.back(),
      ),
      body: InsertForm(
          iconImage: "cameraIcon.svg",
          titleText: "수선 문의하기",
          hintText: "내용을 입력해주세요."),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: CircleBlackBtn(
          function: () => Get.toNamed('/mainHome'),
          btnText: "문의하기",
        ),
      ),
    );
  }
}
