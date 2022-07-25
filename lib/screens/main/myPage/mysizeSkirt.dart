import 'package:needlecrew/screens/main/myPage/mysizePantsUpdate.dart';
import 'package:needlecrew/screens/main/myPage/mysizeSkirtUpdate.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';

class MysizeSkirt extends StatelessWidget {
  const MysizeSkirt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "스커트",
          icon: "updateIcon.svg",
          widget: MysizeSkirtUpdate(),
          appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizeForm(title: "기장", hintTxt: "101", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "전체 통(밑단)", hintTxt: "32", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "합", hintTxt: "24", isTextfield: false),
          ],
        ),
      ),
    );
  }
}
