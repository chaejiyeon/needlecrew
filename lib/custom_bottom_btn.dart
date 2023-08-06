import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/widget_controller/custom_widget_controller.dart';
import 'package:needlecrew/custom_circle_btn.dart';
import 'package:needlecrew/models/util/set_color.dart';

class CustomBottomBtn extends StatelessWidget {
  final String formName;
  final double? formHeight;
  final EdgeInsets? formMargin;
  final EdgeInsets? formPadding;

  //
  final Widget? visibleWidget;
  final Widget? infoWidget;

  //
  final List btnItems;

  //
  final dynamic iconFt;

  //
  final bool isNextBtn;
  final Widget? nextWidget;

  const CustomBottomBtn(
      {Key? key,
      required this.formName,
      this.formMargin,
      this.formPadding,
      this.visibleWidget,
      this.formHeight,
      this.infoWidget,
      this.btnItems = const [],
      this.iconFt, //
      this.isNextBtn = false,
      this.nextWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomWidgetController controller = Get.find(tag: formName);

    return Container(
      height: formHeight ?? 148.h,
      padding: formPadding ??
          EdgeInsets.only(
            left: 24.w,
            top: 19.h,
            right: 24.w,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: SetColor().colorEd, blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: isNextBtn
          ? nextWidget ?? Container()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                visibleWidget ?? Container(),
                Expanded(
                  child: SizedBox(
                    height: 20.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoWidget != null
                            ? Expanded(
                                child: infoWidget!,
                              )
                            : Container(),
                        Obx(
                          () => GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                controller.isAnimated.toggle();
                                if (iconFt != null) {
                                  iconFt();
                                }
                              },
                              child: AnimatedBuilder(
                                animation: controller.animationController,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 20.w,
                                  height: 20.h,
                                  child: !controller.isAnimated.value
                                      ? SvgPicture.asset(
                                          "assets/icons/dropdownIcon.svg",
                                          color: SetColor().color90,
                                          width: 14.w,
                                          height: 8.h,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/dropdownupIcon.svg",
                                          color: SetColor().color90,
                                          width: 14.w,
                                          height: 8.h,
                                        ),
                                ),
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle:
                                        controller.animationController.value *
                                            2.0 *
                                            3.14,
                                    child: child,
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                btnItems.isNotEmpty
                    ? Row(
                        children: List.generate(
                            btnItems!.length,
                            (index) => Expanded(
                                  child: CustomCircleBtn(
                                    btnMargin: EdgeInsets.only(
                                        top: 16.h,
                                        bottom: 39.h,
                                        right: btnItems.length != index
                                            ? 10.w
                                            : 0),
                                    btnText: btnItems[index].text,
                                    btnTextColor: btnItems[index].textColor,
                                    btnTextSize: btnItems[index].textSize,
                                    borderColor: btnItems[index].borderColor ??
                                        Colors.black,
                                    btnColor: btnItems[index].btnColor ??
                                        Colors.black,
                                    btnFt: btnItems[index].callback,
                                  ),
                                )),
                      )
                    : Container()
              ],
            ),
    );
  }
}
