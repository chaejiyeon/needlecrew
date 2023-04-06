import 'package:get/get.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/myPage/address_insert_form.dart';
import 'package:flutter/material.dart';

class AddressAdd extends GetView<HomeController> {
  const AddressAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AddressInsertForm(
            appbarName: "주소 등록", hinttext1: "", hinttext2: ""),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: CircleBlackBtn(
                function: () => controller.updateAddress("register"), btnText: "완료")),
      ),
    );
  }
}
