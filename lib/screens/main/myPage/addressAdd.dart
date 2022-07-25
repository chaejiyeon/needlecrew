import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/myPage/addressInsertForm.dart';
import 'package:flutter/material.dart';

class AddressAdd extends StatefulWidget {
  const AddressAdd({Key? key}) : super(key: key);

  @override
  State<AddressAdd> createState() => _AddressAddState();
}

class _AddressAddState extends State<AddressAdd> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AddressInsertForm(appbarName: "주소 등록",addressSearch: true, hinttext1: "지번,도로명,건물명 검색",hinttext2: "상세주소"),


        bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 56),
            child: CircleBlackBtn(btnText: "완료", pageName: "back")),
      ),
    );
  }


}
