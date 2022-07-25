import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mysizeBottom.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';

class MysizePantsUpdate extends StatefulWidget {
  const MysizePantsUpdate({Key? key}) : super(key: key);

  @override
  State<MysizePantsUpdate> createState() => _MysizePantsUpdateState();
}

class _MysizePantsUpdateState extends State<MysizePantsUpdate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: MypageAppBar(
            title: "바지", icon: "", widget: MainHome(), appbar: AppBar()),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizeForm(title: "총 길이", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "밑위 길이", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "허리", hintTxt: "", isTextfield: true),
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
