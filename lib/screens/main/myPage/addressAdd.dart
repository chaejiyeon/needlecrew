import 'package:get/get.dart';
import 'package:needlecrew/getxController/homeController.dart';
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
        body: AddressInsertForm(appbarName: "주소 등록", hinttext1: "",hinttext2: ""),


        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: CircleBlackBtn(btnText: "완료", pageName: "addressUpdate", )),
      ),
    );
  }


}
