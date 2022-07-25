import 'package:needlecrew/screens/main/mainHome.dart';
import 'package:needlecrew/screens/main/myPage/mysizeOnePiece.dart';
import 'package:needlecrew/screens/main/myPage/mysizePants.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirt.dart';
import 'package:needlecrew/screens/main/myPage/mysizeSkirt.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/mypageMenu.dart';
import 'package:flutter/material.dart';

import 'mysizeOuterCoatUpdate.dart';

class MySizeInfo extends StatefulWidget {
  const MySizeInfo({Key? key}) : super(key: key);

  @override
  State<MySizeInfo> createState() => _MySizeInfoState();
}

class _MySizeInfoState extends State<MySizeInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MypageAppBar(
          title: "내 치수", icon: "", widget: MainHome(), appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            MypageMenu(listTitle: "상의", widget: MysizeShirt()),
            MypageMenu(listTitle: "바지", widget: MysizePants()),
            MypageMenu(listTitle: "스커트", widget: MysizeSkirt()),
            MypageMenu(listTitle: "원피스", widget: MysizeOnePiece()),
            MypageMenu(listTitle: "아우터", widget: MysizeOuterUpdate()),
          ],
        ),
      ),
    );
  }
}
