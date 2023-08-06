import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';

class UseInfoEmpty extends StatelessWidget {
  final String orderState;

  const UseInfoEmpty({Key? key, required this.orderState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 50.h),
        child: CustomText(
          text: orderState == 'ready'
              ? "대기 중인 의뢰가 없습니다."
              : orderState == "progress"
                  ? "진행 중인 의뢰가 없습니다."
                  : "수선 목록이 없습니다.",
          fontSize: FontSize().fs6,
        ));
  }
}
