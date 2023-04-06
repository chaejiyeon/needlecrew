import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/mysize_bottom.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/material.dart';

import '../main_home.dart';

class MysizeShirtUpdate extends StatefulWidget {
  final String type;

  const MysizeShirtUpdate({Key? key, required this.type}) : super(key: key);

  @override
  State<MysizeShirtUpdate> createState() => _MysizeShirtUpdateState();
}

class _MysizeShirtUpdateState extends State<MysizeShirtUpdate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: widget.type,
          leadingWidget: BackBtn(),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizeForm(title: "품", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "목둘레", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "소매길이", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "민소매 암홀 길이", hintTxt: "", isTextfield: true),
              SizedBox(
                height: 20,
              ),
              SizeForm(title: "어깨 길이", hintTxt: "", isTextfield: true),
            ],
          ),
        ),
        bottomNavigationBar: MysizeBottom(),
      ),
    );
  }
}
