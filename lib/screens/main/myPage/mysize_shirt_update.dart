import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/my_page/mysize_info_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_bottom_btn.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/myPage/size_form.dart';
import 'package:flutter/material.dart';

class MysizeShirtUpdate extends StatefulWidget {
  final String type;
  final List sizeInfo;

  const MysizeShirtUpdate(
      {Key? key, required this.type, required this.sizeInfo})
      : super(key: key);

  @override
  State<MysizeShirtUpdate> createState() => _MysizeShirtUpdateState();
}

class _MysizeShirtUpdateState extends State<MysizeShirtUpdate> {
  final MysizeInfoController controller = Get.find();
  final CustomWidgetController widgetController =
      Get.put(CustomWidgetController(), tag: 'my_size');

  @override
  Widget build(BuildContext context) {
    controller.setInit(widget.sizeInfo);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(
          appbarcolor: 'white',
          appbar: AppBar(),
          title: widget.type == 'shirt'
              ? '상의'
              : widget.type == 'pants'
                  ? '하의'
                  : widget.type == 'one_piece'
                      ? '원피스'
                      : '스커트',
          leadingWidget: BackBtn(),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: ListView(
              children: List.generate(
                  widget.sizeInfo.length,
                  (index) => SizeForm(
                      editingController: controller.sizeController[controller
                              .sizeController
                              .indexWhere((element) => element.containsKey(
                                  widget.sizeInfo[index]['key_name']))]
                          [widget.sizeInfo[index]['key_name']],
                      title: widget.sizeInfo[index]['title'],
                      hintTxt: widget.sizeInfo[index]['content'],
                      isTextfield: true))),
        ),
        bottomNavigationBar: CustomBottomBtn(
          formName: 'my_size',
          formHeight: 148.h,
          iconFt: () {
            CustomWidgetController widgetController = Get.find();

            if (widgetController.isAnimated.value) {
              Functions().showSizeGuideBottomSheet(context);
              widgetController.isAnimated.value = false;
            }
          },
          infoWidget: Container(
            height: 20.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/fixClothes/rollIcon.svg",
                ),
                CustomText(
                  text: '치수 측정가이드',
                  fontSize: FontSize().fs4,
                  formMargin: EdgeInsets.only(left: 5),
                ),
              ],
            ),
          ),
          btnItems: [
            BtnModel(
                text: '수정 완료',
                callback: () => controller.updateSize(widget.type))
          ],
        ),
      ),
    );
  }
}
