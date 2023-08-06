import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/screens/main/fixClothes/image_upload.dart';
import 'package:needlecrew/widgets/fixClothes/circle_line_text_field.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InsertForm extends StatefulWidget {
  final String titleText;
  final String iconImage;
  final String hintText;

  const InsertForm(
      {Key? key,
      required this.titleText,
      required this.iconImage,
      required this.hintText})
      : super(key: key);

  @override
  State<InsertForm> createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  int maxLines = 20;
  late List<TextEditingController> controller = [];

  @override
  void initState() {
    if (widget.titleText == "직접 입력하기") {
      for (int i = 0; i < 2; i++) controller.add(TextEditingController());
    } else {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < controller.length; i++) {
      controller[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FontStyle(
                  text: widget.titleText,
                  fontsize: "lg",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              SizedBox(
                height: 50,
              ),
              FontStyle(
                  text: "사진 업로드",
                  fontsize: "md",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              SizedBox(
                height: 20,
              ),
              ImageUpload(icon: widget.iconImage, isShopping: false),
              SizedBox(
                height: 30,
              ),

              // 물품가액 > 직접 입력하기
              widget.titleText == "직접 입력하기"
                  ? Container(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FontStyle(
                                  text: "물품 가액",
                                  fontsize: "md",
                                  fontbold: "bold",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 54,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'))
                              ],
                              controller: controller[0],
                              decoration: InputDecoration(
                                  hintText: "수선물품의 가액을 입력해주세요.",
                                  hintStyle: TextStyle(
                                      color:
                                          HexColor("#909090").withOpacity(0.7),
                                      fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: HexColor("#d5d5d5"),
                                    ),
                                  ),
                                  suffixIconConstraints: BoxConstraints(),
                                  suffixIcon: Container(
                                    padding: EdgeInsets.only(right: 17.w),
                                    child: Text("원"),
                                  )),
                            ),
                          ),

                          // 물품가액에 대한 설명
                          Container(
                            padding: EdgeInsets.only(
                                top: 11.h, right: 13.w, bottom: 17.h, left: 15.w),
                            margin: EdgeInsets.only(top:10.h, bottom: 40.h),
                            decoration: BoxDecoration(
                              color: HexColor("#f7f7f7"),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "* ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                Expanded(
                                  child: Text(
                                    "물품가액은 배송 사고시 보장의 기준이 되며, 허위 기재 시 배송과정에서 불이익이 발생할 수 있으니 실제 물품의 가치를 정확히 기재해 주시기 바랍니다.",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
              SizedBox(
                height: 20,
              ),
              FontStyle(
                  text: widget.titleText == "직접 입력하기" ? "의뢰 내용" : "문의 내용",
                  fontsize: "md",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: CircleLineTextField(
                    controller: widget.titleText == "직접 입력하기" && controller.length >= 2
                        ? controller[1]
                        : controller[0],
                    maxLines: maxLines,
                    hintText: widget.hintText,
                    hintTextColor: HexColor("#909090"),
                    borderRadius: 10,
                    borderSideColor: HexColor("#d5d5d5"),
                    widthOpacity: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
