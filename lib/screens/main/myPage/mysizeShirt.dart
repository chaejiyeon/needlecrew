import 'package:get/get.dart';
import 'package:needlecrew/getxController/homeController.dart';
import 'package:needlecrew/screens/main/myPage/mysizeShirtUpdate.dart';
import 'package:needlecrew/widgets/circleBlackBtn.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:needlecrew/widgets/myPage/mypageAppbar.dart';
import 'package:needlecrew/widgets/myPage/sizeForm.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MysizeShirt extends StatelessWidget {
  final String sizeType;

  const MysizeShirt({Key? key, required this.sizeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    // 상의 치수 폼
    List<String> shirt = [
      "품",
      "목둘레",
      "소매길이",
      "소매통",
      "민소매 암홀 길이",
      "어깨 길이",
    ];

    // 바지 치수 폼
    List<String> pants = [
      "기장",
      "밑위 길이",
      "허리",
      "전체 통(밑단)",
      "힙",
    ];

    // 스커트 치수 폼
    List<String> skirt = [
      "기장",
      "전체 통(밑단)",
      "힙",
    ];

    // 원피스 치수 폼
    List<String> onepiece = ["기장"];

    // 치수 정보 가져오기
    controller.getSize(sizeType == "상의"
        ? "상의"
        : sizeType == "바지"
        ? "바지"
        : sizeType == "스커트"
        ? "스커트"
        : "원피스");

    return Scaffold(
      appBar: MypageAppBar(
          title: "상의", icon: "", widget: MysizeShirtUpdate(), appbar: AppBar()),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          children: List.generate(
              sizeType == "상의"
                  ? shirt.length
                  : sizeType == "바지"
                      ? pants.length
                      : sizeType == "스커트"
                          ? skirt.length
                          : onepiece.length,
              (index) => SizeForm(title: sizeType == "상의"
                  ? shirt[index]
                  : sizeType == "바지"
                  ? pants[index]
                  : sizeType == "스커트"
                  ? skirt[index]
                  : onepiece[index], hintTxt: controller.getsizeInfo[index], isTextfield: false)),
        ),
      ),
      // Container(
      //   color: Colors.white,
      //   padding: EdgeInsets.all(20),
      //   child: Column(
      //     children: [
      //       SizeForm(title: "품", hintTxt: "101", isTextfield: false),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       SizeForm(title: "목둘레", hintTxt: "32", isTextfield: false),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       SizeForm(title: "소매길이", hintTxt: "24", isTextfield: false),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       SizeForm(title: "소매통", hintTxt: "15", isTextfield: false),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       SizeForm(title: "민소매 암홀 길이", hintTxt: "15", isTextfield: false),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       SizeForm(title: "어깨 길이", hintTxt: "52", isTextfield: false),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: CircleBlackBtn(btnText: "치수 측정 가이드 및 수정", pageName: "")),
    );
  }
}
