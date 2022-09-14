import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:get/get.dart';
import 'package:needlecrew/getxController/fixClothes/cartController.dart';
import 'package:needlecrew/getxController/fixClothes/fixselectController.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/screens/main/fixClothes/imageUpload.dart';
import 'package:needlecrew/widgets/fixClothes/checkBtn.dart';
import 'package:needlecrew/widgets/fixClothes/circleLineTextField.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class FixUpdate extends StatefulWidget {
  final CartItem cartItem;

  const FixUpdate({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<FixUpdate> createState() => _FixUpdateState();
}

class _FixUpdateState extends State<FixUpdate> {
  final CartController cartController = Get.put(CartController());
  final FixSelectController fixselectController =
      Get.put(FixSelectController());

  TextEditingController controller = TextEditingController();

  late Future variationFuture;

  @override
  void initState() {

    print("widget cart prpoductId this" + widget.cartItem.productId.toString());
    variationFuture = cartController.getVariation(widget.cartItem.productId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fixselectController.isSelected.value = widget.cartItem.cartWay;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: FixClothesAppBar(
          appbar: AppBar(),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FontStyle(
                  text: "의뢰 수정",
                  fontsize: "lg",
                  fontbold: "bold",
                  fontcolor: Colors.black,
                  textdirectionright: false),
              Expanded(
                child: ListView(
                  children: [
                    // 사진 업로드
                    Container(
                      padding: EdgeInsets.only(top: 14),
                      child: ImageUpload(
                          icon: "cameraIcon.svg", isShopping: false),
                    ),

                    // 의뢰 방법
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontStyle(
                              text: "치수 표기 방법",
                              fontsize: "md",
                              fontbold: "bold",
                              fontcolor: Colors.black,
                              textdirectionright: false),
                          SizedBox(
                            height: 10,
                          ),
                          RadioBtn(
                              list: "원하는 총 기장 길이 입력",
                              bottomPadding: 15,
                              textBold: ""),
                          RadioBtn(
                              list: "줄이고 싶은 만큼 치수 입력",
                              bottomPadding: 15,
                              textBold: ""),
                          RadioBtn(
                              list: "잘 맞는 옷을 함께 보낼게요.",
                              bottomPadding: 15,
                              textBold: ""),
                        ],
                      ),
                    ),

                    // 치수 입력
                    textForm(
                        "치수 입력", widget.cartItem.cartSize, Colors.black, true),

                    // 물품 가액
                    textForm("물품 가액", widget.cartItem.guaranteePrice,
                        Colors.black, false),

                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ",
                            style: TextStyle(color: HexColor("#aaaaaa")),
                          ),
                          Expanded(
                            child: Text(
                              "물품가액은 배송 사고시 보상의 기준이 되며, 허위 기재 시 배송과정에서 불이익이 발생할 수 있으니 실제 물품의 가치를 정확히 기재해주시기 바랍니다.",
                              style: TextStyle(color: HexColor("#aaaaaa")),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 추가 설명
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FontStyle(
                              text: "추가 설명",
                              fontsize: "md",
                              fontbold: "bold",
                              fontcolor: Colors.black,
                              textdirectionright: false),
                          SizedBox(
                            height: 10,
                          ),
                          CircleLineTextField(
                              controller: controller,
                              maxLines: 10,
                              hintText: widget.cartItem.cartContent,
                              hintTextColor: Colors.black,
                              borderRadius: 10,
                              borderSideColor: HexColor("#d5d5d5"),
                              widthOpacity: true),
                        ],
                      ),
                    ),

                    // 수거 주소 - 이용내역 > 접수 완료 후 의뢰 수정 시 표시
                    textForm("수거 주소", "경기 수원시 팔달구 인계동 156 104동 1702호",
                        Colors.black, false),
                    textForm("수거 희망일", "2022년 2월 15일", Colors.black, false),

                    // 추가 옵션
                    FutureBuilder(
                        future: variationFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return cartController.variation.length != 0
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 40),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: FontStyle(
                                                text: "추가 옵션",
                                                fontsize: "md",
                                                fontbold: "bold",
                                                fontcolor: Colors.black,
                                                textdirectionright: false),
                                          ),
                                          Column(
                                            children: List.generate(
                                                cartController.variation.length,
                                                (index) => optionItem(
                                                    cartController
                                                        .variation[index])),
                                          ),
                                        ]),
                                  )
                                : Container();
                          } else if (snapshot.hasData == false) {
                            return Container();
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: HexColor("#d5d5d5").withOpacity(0.2),
                  spreadRadius: 10,
                  blurRadius: 5,
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FontStyle(
                              text: "총 의뢰 예상 비용 : ",
                              fontsize: "",
                              fontbold: "",
                              fontcolor: Colors.black,
                              textdirectionright: false),
                          FontStyle(
                              text: "11,000",
                              fontsize: "md",
                              fontbold: "bold",
                              fontcolor: HexColor("#fd9a03"),
                              textdirectionright: false),
                          FontStyle(
                              text: "원",
                              fontsize: "",
                              fontbold: "",
                              fontcolor: Colors.black,
                              textdirectionright: false),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.chevron_up,
                            color: HexColor("#909090"),
                            size: 20,
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bottomBtn("취소"),
                      bottomBtn("수정 완료"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bottomNavigationbar button
  Widget bottomBtn(String btnText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.4,
      height: 54,
      decoration: BoxDecoration(
          color: btnText == "취소" ? Colors.white : HexColor("#fd9a03"),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color:
                  btnText == "취소" ? HexColor("#d5d5d5") : HexColor("#fd9a30"))),
      child: TextButton(
        onPressed: () {},
        child: Text(
          btnText,
          style: TextStyle(
              color: btnText == "취소" ? Colors.black : Colors.white,
              fontSize: 16),
        ),
      ),
    );
  }

  // slider Image Item
  Widget ImageItem(String image) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/" + image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  // textForm
  Widget textForm(
      String titleText, String hintText, Color hintColor, bool isxmark) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FontStyle(
                  text: titleText,
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
            height: titleText == "수거 주소" ? null : 54,
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintMaxLines: 2,
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: HexColor("#d5d5d5"),
                  ),
                ),
                suffixIcon: isxmark == true
                    ? IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/xmarkIcon_full_acolor.svg",
                          height: 18,
                          width: 18,
                        ),
                      )
                    : titleText == "물품 가액"
                        ? Container(
                            padding: EdgeInsets.only(top: 10, right: 10),
                            child: Text(
                              "원",
                              textAlign: TextAlign.right,
                            ),
                          )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // optionItem custom
  Widget optionItem(WooProductVariation variation) {
    print("variation " + variation.attributes[0].option.toString());

    // 디코딩된 옵션이름 변환
    String optionName = "";

    if (variation.attributes[0].option.toString().indexOf('%') != -1) {
      optionName =
          Uri.decodeComponent(variation.attributes[0].option.toString());
    } else {
      optionName = variation.attributes[0].option.toString();
    }

    // 원 가격
    int currentPrice = int.parse(widget.cartItem.productPrice);
    print("currentPrice" + currentPrice.toString());

    // optin 추가 된 가격
    int addPrice = int.parse(variation.price!);
    print("addPrice" + addPrice.toString());

    // 추가 될 가격
    int finalPrice = addPrice - currentPrice;

    return Obx(
      () => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomRadioWidget(
              optionname: cartController.name(optionName),
              groupValue: fixselectController.radioGroup["추가 옵션"] !=
                      {"추가 옵션": cartController.name(optionName)}
                  ? fixselectController.radioGroup["추가 옵션"]
                  : fixselectController.radioGroup["가격"],
              value: fixselectController.radioGroup["추가 옵션"] !=
                      {"추가 옵션": cartController.name(optionName)}
                  ? cartController.name(optionName)
                  : finalPrice.toString(),
              onChanged: (value) {
                fixselectController.isRadioGroup({
                  "추가 옵션": cartController.name(optionName),
                  "가격": finalPrice.toString()
                });
                fixselectController.radioId.value = variation.id!;
                fixselectController.iswholePrice(addPrice);
              },
            ),
            Row(
              children: [
                FontStyle(
                    text: "+" + finalPrice.toString(),
                    fontsize: "md",
                    fontbold: "bold",
                    fontcolor: Colors.black,
                    textdirectionright: false),
                FontStyle(
                    text: "원",
                    fontsize: "md",
                    fontbold: "",
                    fontcolor: Colors.black,
                    textdirectionright: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// radio cucstom
class CustomRadioWidget<T> extends StatelessWidget {
  final String optionname;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  CustomRadioWidget({
    required this.optionname,
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
            Text(optionname),
          ],
        ),
      ),
    );
  }
}
