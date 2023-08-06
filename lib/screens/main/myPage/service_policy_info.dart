import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/screens/main/main_home.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/list_line.dart';
import 'package:needlecrew/widgets/myPage/service_policy_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ServicePolicyInfo extends StatefulWidget {
  const ServicePolicyInfo({Key? key}) : super(key: key);

  @override
  State<ServicePolicyInfo> createState() => _ServicePolicyInfoState();
}

class _ServicePolicyInfoState extends State<ServicePolicyInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarcolor: 'white',
        appbar: AppBar(),
        title: '서비스 정책',
        leadingWidget: BackBtn(),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 27.h),
              child: Column(
                children: [
                  listMenu("서비스 이용 약관", true,
                      ServicePolicyItem(policyName: "서비스 이용 약관")),
                  listMenu("개인정보 처리 방침", true,
                      ServicePolicyItem(policyName: "개인정보 처리 방침")),
                  listMenu("재수선 및 환불정책", false,
                      ServicePolicyItem(policyName: "재수선 및 환불정책")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // list menu
  Widget listMenu(String listTitle, bool isLine, Widget widget) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.to(widget);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      listTitle,
                    )),
                Icon(
                  CupertinoIcons.forward,
                  size: 20,
                  color: HexColor("#909090"),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            isLine == true
                ? ListLine(
                    height: 1,
                    width: double.infinity,
                    lineColor: HexColor("#ededed"),
                    opacity: 1.0)
                : Container(),
          ],
        ),
      ),
    );
  }
}
