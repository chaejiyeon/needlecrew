import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mysizeBottom.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';

class MysizeSkirtUpdate extends StatefulWidget {
  const MysizeSkirtUpdate({Key? key}) : super(key: key);

  @override
  State<MysizeSkirtUpdate> createState() => _MysizeSkirtUpdateState();
}

class _MysizeSkirtUpdateState extends State<MysizeSkirtUpdate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MypageAppBar(
            title: "스커트", icon: "", widget: MainHome(), appbar: AppBar()),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizeForm(title: "총 길이", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "전체 통(밑단)", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "힙", hintTxt: "", isTextfield: true),
            ],
          ),
        ),
        bottomNavigationBar: MysizeBottom(),
      ),
    );
  }
}
