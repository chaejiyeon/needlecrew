import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';

class UseInfoListItem extends GetView<UseInfoController> {
  final Map order;

  const UseInfoListItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 2,
        color: SetColor().mainColor.withOpacity(0.1),
      ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: controller.setTitleComment(order),
            fontSize: FontSize().fs4,
            fontColor: SetColor().color90,
          ),
          CustomText(
            formMargin: EdgeInsets.only(bottom: 20.h),
            text: controller.setStatusComment(order['order_status']),
            fontSize: FontSize().fs6,
            fontWeight: FontWeight.bold,
          ),
          controller.setBtnWhole(context, order)
        ],
      ),
    );
  }
}
