import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/controller/login_controller.dart';
import 'package:needlecrew/main.dart';
import 'package:needlecrew/screens/join/choose_gender.dart';
import 'package:needlecrew/widgets/base_appbar.dart';
import 'package:needlecrew/widgets/circle_check_btn.dart';
import 'package:needlecrew/widgets/floating_next_btn.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/myPage/service_policy_item.dart';

class AgreeTerms extends StatefulWidget {
  const AgreeTerms({Key? key}) : super(key: key);

  @override
  State<AgreeTerms> createState() => _AgreeTermsState();
}

class _AgreeTermsState extends State<AgreeTerms> {
  final LoginController controller = Get.put(LoginController());
  bool whole_checked = false;

  @override
  Widget build(BuildContext context) {
    controller.setChecked();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppbar(
        appbar: AppBar(),
        prevFunction: () => Get.back(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.h, bottom: 20.h),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FontStyle(
                      text: "환영합니다 :D",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      fontsize: "lg",
                      textdirectionright: false),
                  FontStyle(
                      text: "니들크루 서비 이용에 필요한 사항을",
                      fontbold: "",
                      fontcolor: HexColor("#606060"),
                      fontsize: "md",
                      textdirectionright: false),
                  FontStyle(
                      text: "안내해드릴께요.",
                      fontbold: "",
                      fontcolor: HexColor("#606060"),
                      fontsize: "md",
                      textdirectionright: false),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (whole_checked == false) {
                    whole_checked = true;
                  } else {
                    whole_checked = false;
                  }
                });

                controller.wholeChecked(whole_checked);
              },
              child: Container(
                margin: EdgeInsets.only(top: 72),
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1,
                    color: HexColor("#d5d5d5"),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/icons/startPage/allcheckIcon.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "약관 전체동의",
                      style: TextStyle(
                        color: HexColor("#404040"),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 17),
                child: Column(
                  children: [
                    CircleCheckBtn(
                      list: "개인정보 처리방침 (필수)",
                      listInfo: ServicePolicyItem(policyName: "개인정보 처리 방침"),
                      checked: whole_checked,
                      index: 0,
                    ),
                    CircleCheckBtn(
                      list: "서비스 이용 약관 (필수)",
                      listInfo: ServicePolicyItem(policyName: "서비스 이용 약관"),
                      checked: whole_checked,
                      index: 1,
                    ),
                    CircleCheckBtn(
                      list: "혜택 정보 앱 푸시 알림 수신 (선택)",
                      listInfo:
                          ServicePolicyItem(policyName: "혜택 정보 앱 푸시 알림 수신"),
                      checked: whole_checked,
                      index: 2,
                    ),
                    CircleCheckBtn(
                      list: "추가비용 결제 안내 (필수)",
                      listInfo: ServicePolicyItem(policyName: "추가비용 결제 안내"),
                      checked: whole_checked,
                      index: 3,
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => FloatingNextBtn(
                function: () => Get.to(ChooseGender()),
                ischecked: controller.ischecked[0] == true &&
                        controller.ischecked[1] == true &&
                        controller.ischecked[3] == true
                    ? true
                    : false))
          ],
        ),
      ),
      // floatingActionButton: ,
    );
  }
}
