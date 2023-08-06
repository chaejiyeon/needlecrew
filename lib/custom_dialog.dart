import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';

// custom dialog form
class CustomDialog extends StatelessWidget {
  final Widget? headerWidget;
  final double? width;
  final double? height;
  final EdgeInsets formPadding;
  final Widget header;
  final Widget bottom;

  const CustomDialog({
    Key? key,
    this.headerWidget,
    this.width,
    this.height,
    this.formPadding = EdgeInsets.zero,
    required this.header,
    required this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        headerWidget ?? Container(),
        // SingleChildScrollView(
        //   child:
        Container(
          padding: formPadding,
          width: width ?? 297.w,
          height: height ?? 174.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [header, Expanded(child: bottom)],
          ),
          // ),
        ),
      ]),
    );
  }
}

// dialog header 설정
class DialogHeader extends StatelessWidget {
  final String title;
  final String content;
  final String btnIcon;
  final Widget? headerWidget;

  //
  final EdgeInsets? headerPadding;

  const DialogHeader(
      {Key? key,
      this.title = '',
      this.content = '',
      this.btnIcon = '',
      //
      this.headerPadding,
      this.headerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124.h,
      padding: headerPadding,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        headerWidget ?? Container(),
        title != ''
            ? CustomText(
                text: title,
                fontSize: FontSize().fs6,
                fontWeight: FontWeight.bold,
                formMargin: EdgeInsets.only(bottom: 5.h))
            : Container(),
        btnIcon != ''
            ? Container(
                width: 50.w,
                height: 50.h,
                child: SvgPicture.asset(
                  "assets/icons/$btnIcon",
                  fit: BoxFit.scaleDown,
                ),
              )
            : Container(),
        content != ''
            ? CustomText(
                text: content,
                fontSize: FontSize().fs4,
                fontColor: SetColor().color60,
              )
            : Container(),
      ]),
    );
  }
}

// dialog bottom btn 설정
class DialogBottom extends StatelessWidget {
  final bool isExpanded;
  final List<BtnModel> btn;
  final MainAxisAlignment mainAlignment;

  const DialogBottom(
      {Key? key,
      this.isExpanded = false,
      required this.btn,
      this.mainAlignment = MainAxisAlignment.spaceBetween})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: SetColor().colorEd))),
      child: Row(
        mainAxisAlignment: mainAlignment,
        children: List.generate(
            btn.length,
            (index) => isExpanded == true
                ? Expanded(
                    child: btnCustom(
                        btn[index], index != btn.length - 1 ? true : false))
                : btnCustom(
                    btn[index], index != btn.length - 1 ? true : false)),
      ),
    );
  }

  Widget btnCustom(BtnModel e, bool hasLine) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // function 실행
        e.callback();
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: e.margin!),
        width: e.width,
        height: e.height,
        decoration: BoxDecoration(
          color: e.btnColor,
          border: Border(
            right: hasLine
                ? BorderSide(color: SetColor().colorEd)
                : BorderSide(color: Colors.transparent),
          ),
        ),
        child: CustomText(
            text: e.text,
            fontColor: e.textColor,
            fontSize: e.textSize!,
            fontWeight: e.textWeight),
      ),
    );
  }
}
