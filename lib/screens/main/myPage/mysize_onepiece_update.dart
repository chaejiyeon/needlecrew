import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/mysize_bottom.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/material.dart';

import '../main_home.dart';

class MysizeOnepieceUpdate extends StatefulWidget {
  const MysizeOnepieceUpdate({Key? key}) : super(key: key);

  @override
  State<MysizeOnepieceUpdate> createState() => _MysizeOnepieceUpdateState();
}

class _MysizeOnepieceUpdateState extends State<MysizeOnepieceUpdate> {
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
          title: '원피스',
          leadingWidget: BackBtn(),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizeForm(title: "기장", hintTxt: "", isTextfield: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MysizeBottom(),
      ),
    );
  }
}
