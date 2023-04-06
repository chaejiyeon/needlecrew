import 'package:get/get.dart';
import 'package:needlecrew/controller/homeController.dart';
import 'package:needlecrew/screens/main/myPage/mysize_shirt_update.dart';
import 'package:needlecrew/widgets/circle_black_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/material.dart';

class MysizeShirt extends StatelessWidget {
  final String sizeType;

  const MysizeShirt({Key? key, required this.sizeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

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

    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: sizeType,
        leadingWidget: BackBtn(),
      ),
      body: StreamBuilder(
          stream: Stream.periodic(
            Duration(seconds: 1),
          ).asyncMap((event) => controller.getSize(sizeType)),
          builder: (context, snapshot) {
            return Container(
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
                  (index) => SizeForm(
                      title: sizeType == "상의"
                          ? shirt[index]
                          : sizeType == "바지"
                              ? pants[index]
                              : sizeType == "스커트"
                                  ? skirt[index]
                                  : onepiece[index],
                      hintTxt: controller.getsizeInfo.length == 0
                          ? "0"
                          : controller.getsizeInfo[index],
                      isTextfield: false),
                ),
              ),
            );
          }),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: CircleBlackBtn(
              function: () => Get.to(MysizeShirtUpdate(
                    type: sizeType,
                  )),
              btnText: "치수 측정 가이드 및 수정")),
    );
  }
}
