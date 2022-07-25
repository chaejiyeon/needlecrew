import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/mysizePantsUpdate.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';

class MysizePants extends StatelessWidget {
  const MysizePants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "바지", icon: "updateIcon.svg", widget: MysizePantsUpdate(), appbar: AppBar()),
      body: Container(
          color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizeForm(title: "기장", hintTxt: "101", isTextfield: false),
                  SizedBox(
                    height: 20,
                  ),
                  SizeForm(title: "밑위 길이", hintTxt: "32", isTextfield: false),
                  SizedBox(
                    height: 20,
                  ),
                  SizeForm(title: "허리", hintTxt: "24", isTextfield: false),
                  SizedBox(
                    height: 20,
                  ),
                  SizeForm(title: "전체 통(밑단)", hintTxt: "15", isTextfield: false),
                  SizedBox(
                    height: 20,
                  ),
                  SizeForm(title: "힙", hintTxt: "15", isTextfield: false),
                ],
              ),
            ),
    );
  }
}
