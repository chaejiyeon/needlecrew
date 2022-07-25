import 'package:needlecrew/screens/main/myPage/mysizeOnePieceUpdate.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';

class MysizeOnePiece extends StatelessWidget {
  const MysizeOnePiece({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "원피스",
          icon: "updateIcon.svg",
          widget: MysizeOnePieceUpdate(),
          appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizeForm(title: "기장", hintTxt: "101", isTextfield: false),
          ],
        ),
      ),
    );
  }
}
