import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/widget_controller/custom_text_field_controller.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/widgets/alramInfo/alram_btn_text.dart';

/// 뒤로가기 버튼
class BackBtn extends StatelessWidget {
  final Color iconColor;
  final dynamic backFt;

  const BackBtn({Key? key, this.iconColor = Colors.black, this.backFt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (backFt != null) {
          backFt();
        } else {
          Get.back();
        }
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          color: iconColor,
          "assets/icons/prevIcon.svg",
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

/// 이미지 표시
class ImageItem extends StatelessWidget {
  final String imageType;
  final String image;
  final double imgWidth;
  final double imgHeight;

  //
  final EdgeInsets padding;

  const ImageItem(
      {Key? key,
      this.imageType = '',
      required this.image,
      this.imgWidth = 120,
      this.imgHeight = 120,
      this.padding = const EdgeInsets.all(10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List imageInfo =
        Functions().setImageList(imageType: imageType, image: image);
    printInfo(info: 'image info this $imageInfo');

    return GestureDetector(
      child: imageInfo.isNotEmpty && imageInfo[0] != ""
          ? Container(
              padding: padding,
              height: imgHeight.h,
              width: imgWidth.w,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageInfo[1], fit: BoxFit.cover)),
            )
          : Container(),
    );
  }
}

/// 플로팅 버튼 (full color custom)
class CustomNextBtn extends StatelessWidget {
  final bool isAvailable;
  final dynamic btnFt;

  const CustomNextBtn({Key? key, this.isAvailable = false, this.btnFt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (btnFt != null && isAvailable) {
          btnFt();
        }
      },
      child: !isAvailable
          ? Container(
              height: 54.h,
              width: 54.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: SetColor().colorD5)),
              child: SvgPicture.asset(
                "assets/icons/nextIcon.svg",
                color: SetColor().colorD5,
                height: 15.h,
              ),
            )
          : Image.asset(
              height: 54.h,
              width: 54.w,
              "assets/icons/selectFloatingIcon.png",
            ),
    );
  }
}

/// radio cucstom
class CustomRadioWidgetOrigin<T> extends StatelessWidget {
  final String optionName;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  CustomRadioWidgetOrigin({
    required this.optionName,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(this.value);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
                width: 22,
                height: 22,
                child: value == groupValue
                    ? Image.asset("assets/icons/selectCheckIcon.png")
                    : Image.asset("assets/icons/checkBtnIcon.png")),
            SizedBox(
              width: 10,
            ),
            Text(optionName),
          ],
        ),
      ),
    );
  }
}

// text field
class CustomTextField extends StatelessWidget {
  final String? controllerName;
  final double? formHeight;

  //
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;

  //
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Widget? suffixIcon;

  //
  final int? maxLength;
  final int? maxLines;
  final TextStyle? counterStyle;

  //
  final double? borderRadius;
  final Color? borderSideColor;

  const CustomTextField(
      {Key? key,
      this.controllerName,
      this.formHeight = 54,
      //
      this.textInputType,
      this.inputFormatters,
      this.textEditingController,
      this.focusNode,
      this.contentPadding,
      //
      this.hintText,
      this.hintTextStyle,
      this.suffixIcon,
      //
      this.maxLength,
      this.maxLines,
      this.counterStyle,
      //
      this.borderRadius,
      this.borderSideColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomTextFieldController controller = Get.find(tag: controllerName);

    return Container(
      height: formHeight?.h,
      child: TextFormField(
        onTap: () {
          controller.formFocus.value = focusNode!;
        },
        onChanged: (value) {
          controller.textFieldControllers.refresh();
        },
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        controller: textEditingController,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: contentPadding ?? EdgeInsets.only(left: 10.w),
          counterStyle: counterStyle,
          hintText: hintText,
          hintStyle: hintTextStyle ??
              TextStyle(
                  color: SetColor().color90.withOpacity(0.7),
                  fontSize: FontSize().fs4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            borderSide: BorderSide(
              color: borderSideColor ?? SetColor().colorD5,
            ),
          ),
          suffixIconConstraints: BoxConstraints(),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

/// 선
class Line extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? lineColor;
  final EdgeInsets? margin;

  const Line({Key? key, this.height, this.width, this.lineColor, this.margin})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(color: lineColor),
    );
  }
}

/// 버튼
class CustomBtn extends StatelessWidget {
  final dynamic btnFt;

  //
  final double? btnWidth;
  final double? btnHeight;
  final EdgeInsets? btnMargin;
  final EdgeInsets? btnPadding;
  final Decoration? boxDecoration;
  final Alignment? btnAlignment;

  //
  final String? btnText;
  final double? btnTextSize;
  final Color? btnTextColor;
  final FontWeight? btnTextWeight;

  //
  final Widget? btnWidget;

  const CustomBtn(
      {Key? key,
      this.btnFt, //
      this.btnWidth,
      this.btnHeight,
      this.btnMargin,
      this.btnPadding,
      this.boxDecoration,
      this.btnAlignment,
      //
      this.btnText,
      this.btnTextSize,
      this.btnTextColor,
      this.btnTextWeight,
      //
      this.btnWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (btnFt != null) {
          btnFt();
        }
      },
      child: Container(
        alignment: btnAlignment,
        width: btnWidth,
        height: btnHeight,
        margin: btnMargin,
        padding: btnPadding,
        decoration: boxDecoration,
        child: btnText == null
            ? btnWidget ?? Container()
            : CustomText(
                text: btnText!,
                fontSize: btnTextSize ?? FontSize().fs4,
                fontWeight: btnTextWeight,
                fontColor: btnTextColor),
      ),
    );
  }
}
