import 'package:needlecrew/widgets/baseAppbar.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fixClothes/insertForm.dart';
import 'package:flutter/material.dart';

class DirectInsert extends StatefulWidget {
  const DirectInsert({Key? key}) : super(key: key);

  @override
  State<DirectInsert> createState() => _DirectInsertState();
}

class _DirectInsertState extends State<DirectInsert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appbar: AppBar(),
      ),


      body: InsertForm(
          titleText: "직접 입력하기",
          hintText:
              "수선하고자 하는 부분을 상세히 기입해주셔야 수선진행에 차질이 없습니다! \n\n 예) 셔츠 팔꿈치 부분하고 목뒷부분 짜집기 부탁 드립니다!",
          iconImage: "cameraIcon.svg"),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: CircleBlackBtn(btnText: "문의하기", pageName: "/mainHome"),
      ),
    );
  }
}
