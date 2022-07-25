import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MysizeShirt extends StatelessWidget {
  const MysizeShirt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "상의",
          icon: "updateIcon.svg",
          widget: MysizeShirtUpdate(),
          appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizeForm(title: "품", hintTxt: "101", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "목둘레", hintTxt: "32", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "소매길이", hintTxt: "24", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "소매통", hintTxt: "15", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "민소매 암홀 길이", hintTxt: "15", isTextfield: false),
            SizedBox(
              height: 20,
            ),
            SizeForm(title: "어깨 길이", hintTxt: "52", isTextfield: false),
          ],
        ),
      ),
    );
  }
}
