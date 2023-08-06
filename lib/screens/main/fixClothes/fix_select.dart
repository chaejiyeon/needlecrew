import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_question.dart';
import 'package:needlecrew/screens/main/fixClothes/image_upload.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/radio_btn.dart';
import 'package:needlecrew/widgets/fixClothes/circle_line_text_field.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/progress_bar.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;
import 'package:needlecrew/widgets/tootip_custom.dart';

class FixSelect extends StatefulWidget {
  final String lastCategory;
  final int productId;
  final List crumbs;

  const FixSelect(
      {Key? key,
      required this.productId,
      required this.crumbs,
      required this.lastCategory})
      : super(key: key);

  @override
  State<FixSelect> createState() => _FixSelectState();
}

class _FixSelectState extends State<FixSelect> {
  final FixSelectController controller = Get.put(FixSelectController());

  List<FocusNode> focusNode = [];

  // 리로딩 방지
  late Future productFuture;

  // late Future categoryFuture;
  late Future variationFuture;

  // late Future lastcategoryFuture;

  // 제품 선택 갯수
  late int selectCount = 1;

  // option id
  late int variationId = 0;

  final maxLines = 10;

  late bool checked = false;

  // // 예상 비용
  // late String wholePrice = "0";

  // option list
  late List<WooProductVariation> variations = [];

  // textfield texteditingcontroller list
  List<TextEditingController> texteditingController = [];

  // cart 상세정보
  List<WooOrderPayloadMetaData> metadata = [];

  // product price 표시
  String price(String chanePrice) {
    // string -> int 타입 변환
    int priceCvt = int.parse(chanePrice);
    // 금액 표시 ex) "6,000"
    String price = NumberFormat("###,###,###").format(priceCvt);
    return price;
  }

  // option name  변환
  String name(String optionName) {
    // 반환할 이름
    String name = "";

    // option name '-' 제거
    List nameList = optionName.split('-');

    // name 전체 표시
    for (int i = 0; i < nameList.length; i++) {
      name += nameList[i] + " ";
    }
    return name;
  }

  // html tag remove
  String parseHtmlTagRemove(String tooltipText) {
    try {
      var document = parse(tooltipText);
      // html 태그 제거
      String parsedText = parse(document.body!.text).documentElement!.text;

      return parsedText;
    } catch (e) {
      print("Tooltip Error   " + e.toString());

      return "";
    }
  }

  @override
  void initState() {
    controller.isProductId(widget.productId);
    controller.setImages.clear();
    controller.getImages.clear();

    print("this categoryIds " +
        widget.crumbs.last.toString() +
        widget.lastCategory.toString());
    productFuture = controller.getProduct(widget.productId);
    variationFuture = controller.getVariation(widget.productId);
    // addToCart();

    // textediting controller 생성
    for (int i = 0; i < 4; i++) {
      texteditingController.add(TextEditingController());
      focusNode.add(FocusNode());
    }

    controller.uploadImg.value = "";
    // controller.setImages.clear();
    print("isShopping" + controller.isshopping.toString());
    super.initState();
  }

  @override
  void dispose() {
    if (texteditingController.length != 0) {
      for (int i = 0; i < texteditingController.length; i++) {
        texteditingController[i].dispose();
      }
    }
    controller.getImages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(
          leadingWidget: BackBtn(),
          appbarcolor: 'white',
          appbar: AppBar(),
          actionItems: [
            AppbarItem(
              icon: 'homeIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: MainPage(pageNum: 0),
            ),
            AppbarItem(
              icon: 'cartIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: CartInfo(),
            ),
            AppbarItem(
              icon: 'alramIcon.svg',
              iconColor: Colors.black,
              iconFilename: 'main',
              widget: AlramInfo(),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // progressbar
                Container(
                  alignment: Alignment.topLeft,
                  child: ProgressBar(progressImg: "fixProgressbar_2.svg"),
                ),

                // header
                Header(
                  title: "수선 선택",
                  subtitle1: "",
                  question: true,
                  btnIcon: "rollIcon.svg",
                  btnText: "치수 측정 가이드",
                  widget: FixQuestion(),
                  imgPath: "fixClothes",
                  bottomPadding: 35,
                ),

                // 선택한 제품 정보
                FutureBuilder(
                    future: productFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 38.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                  future: controller
                                      .getCategory(controller.crumbs.last),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      controller.setGetMySize(
                                          controller.product.name.toString());
                                      return FontStyle(
                                          text: controller.category.name
                                              .toString(),
                                          fontsize: "md",
                                          fontbold: "bold",
                                          fontcolor: Colors.black,
                                          textdirectionright: false);
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FontStyle(
                                      text: controller.product.name.toString(),
                                      fontsize: "",
                                      fontbold: "",
                                      fontcolor: Colors.black,
                                      textdirectionright: false),
                                  Row(
                                    children: [
                                      FontStyle(
                                          text:
                                              price(controller.product.price!),
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
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),

                // 수량 선택
                widget.lastCategory == "기타"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: FontStyle(
                                  text: "수량 선택",
                                  fontsize: "md",
                                  fontbold: "bold",
                                  fontcolor: Colors.black,
                                  textdirectionright: false)),
                          Container(
                              padding: EdgeInsets.only(bottom: 40.h),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        int price = int.parse(
                                            controller.product.price!);
                                        if (selectCount != 1) selectCount -= 1;
                                        price *= selectCount;
                                        controller.iswholePrice(price);
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: HexColor("#d5d5d5")),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        color: HexColor("#707070"),
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 30.w, right: 30.w),
                                    child: FontStyle(
                                        text: selectCount.toString(),
                                        fontsize: "md",
                                        fontbold: "",
                                        fontcolor: Colors.black,
                                        textdirectionright: false),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        int price = int.parse(
                                            controller.product.price!);
                                        selectCount += 1;
                                        price *= selectCount;
                                        controller.iswholePrice(price);
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: HexColor("#d5d5d5")),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Icon(
                                        CupertinoIcons.plus,
                                        color: HexColor("#707070"),
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )
                    : Container(),

                // 참고사항 - 기타일 경우에만 표시
                FutureBuilder(
                  future: productFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return controller.product.description.toString() != ""
                          ? Container(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FontStyle(
                                      text: "참고 사항",
                                      fontsize: "md",
                                      fontbold: "bold",
                                      fontcolor: Colors.black,
                                      textdirectionright: false),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 11, right: 13, left: 15),
                                    margin: EdgeInsets.only(bottom: 40),
                                    decoration: BoxDecoration(
                                      color: HexColor("#f7f7f7"),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/fixClothes/pointIcon.svg"),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            parseHtmlTagRemove(controller
                                                        .product.description
                                                        .toString()) ==
                                                    "0"
                                                ? ""
                                                : parseHtmlTagRemove(controller
                                                    .product.description
                                                    .toString()),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : parseHtmlTagRemove(controller.product.description
                                      .toString()) !=
                                  "0"
                              ? Container(
                                  height: 0,
                                )
                              : Container(
                                  height: 0,
                                );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),

                // 추가 옵션
                FutureBuilder(
                    future: variationFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Obx(() => controller.variation.length != 0
                            ? Container(
                                margin: EdgeInsets.only(bottom: 40),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: FontStyle(
                                            text: "추가 옵션",
                                            fontsize: "md",
                                            fontbold: "bold",
                                            fontcolor: Colors.black,
                                            textdirectionright: false),
                                      ),
                                      Obx(
                                        () => Column(
                                          children: List.generate(
                                              controller.variation.length,
                                              (index) => optionItem(
                                                  controller.variation[index])),
                                        ),
                                      ),
                                    ]),
                              )
                            : Container());
                      } else if (snapshot.hasData == false) {
                        return Container();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),

                // 의뢰 방법
                widget.lastCategory != "기타"
                    ? Container(
                        padding: EdgeInsets.only(bottom: 41),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FontStyle(
                                text: "의뢰 방법",
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
                                list: "완성 치수를 입력할게요.",
                                bottomPadding: 15,
                                textBold: ""),
                            controller.isshopping != true
                                ? RadioBtn(
                                    list: "잘 맞는 옷을 함께 보낼게요.",
                                    bottomPadding: 15,
                                    textBold: "")
                                : Container(),
                          ],
                        ),
                      )
                    : Container(
                        height: 0,
                      ),

                // 치수 입력
                widget.lastCategory != "기타"
                    ? Obx(
                        () => controller.isshopping.value == true ||
                                controller.isSelected.value !=
                                    "잘 맞는 옷을 함께 보낼게요."
                            ? textForm("치수 입력", "의뢰 방법에 해당하는 치수를 입력해주세요.", 0)
                            : Container(
                                height: 0,
                              ),
                      )
                    : Container(
                        height: 0,
                      ),

                // 사진 업로드
                Container(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontStyle(
                          text: "사진 업로드",
                          fontsize: "md",
                          fontbold: "bold",
                          fontcolor: Colors.black,
                          textdirectionright: false),
                      SizedBox(
                        height: 10,
                      ),
                      ImageUpload(icon: "cameraIcon.svg", isShopping: false),
                    ],
                  ),
                ),

                // 물품 가액
                textForm("물품 가액", "수선물품의 가액을 입력해주세요.", 1),

                // 물품가액에 대한 설명
                Container(
                  padding: EdgeInsets.only(
                      top: 11.h, right: 13.w, bottom: 17.h, left: 15.w),
                  margin: EdgeInsets.only(bottom: 40.h),
                  decoration: BoxDecoration(
                    color: HexColor("#f7f7f7"),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "* ",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          "물품가액은 배송 사고 및 수선 사고시 보장의 기준이 되며, 허위 기재 시 배송과정에서 불이익이 발생할 수 있으니 실제 물품의 가치를 정확히 기재해 주시기 바랍니다.",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                // 추가 설명
                Container(
                  padding: EdgeInsets.only(bottom: 40.h),
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
                          controller: texteditingController[2],
                          maxLines: maxLines,
                          hintText:
                              "추가로 설명할 부분을 입력해주세요.\n\n예) 흰색 바지와 함께 보내는 옷입니다. 흰색 바지의 기장 참고해서 수선 부탁드릴게요!",
                          hintTextColor: HexColor("#707070"),
                          borderRadius: 10,
                          borderSideColor: HexColor("#d5d5d5"),
                          widthOpacity: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 고정 bottom navigation
        bottomNavigationBar: FutureBuilder(
            future: productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(
                    "fixselect wholeprice " + controller.wholePrice.toString());
                return GestureDetector(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: HexColor("#d5d5d5").withOpacity(0.1),
                          spreadRadius: 10,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FontStyle(
                                text: "예상 비용 : ",
                                fontsize: "md",
                                fontbold: "bold",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            Obx(
                              () => FontStyle(
                                  text: controller.wholePrice.value == 0
                                      ? price(controller.product.price!)
                                      : controller.wholePrice.value.toString(),
                                  fontsize: "md",
                                  fontbold: "bold",
                                  fontcolor: Colors.black,
                                  textdirectionright: false),
                            ),
                            FontStyle(
                                text: "원",
                                fontsize: "md",
                                fontbold: "",
                                fontcolor: Colors.black,
                                textdirectionright: false),
                            TooltipCustom(
                                tooltipText: cost.tooltipText,
                                titleText: "",
                                boldText: cost.boldText,
                                tailPosition: "up",
                                iconColor: HexColor("#707070")),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            if (controller.getImages.length == 0) {
                              Get.dialog(
                                  barrierDismissible: false,
                                  AlertDialogYes(
                                      titleText: "이미지를 1장이상 등록해주세요!"));
                            } else if (controller.getImages.length >= 1) {
                              bool isUploaded = await controller.uploadImage();

                              if ((texteditingController[0].text.length > 0 &&
                                      texteditingController[1].text.length >
                                          0) ||
                                  (widget.lastCategory == "기타" &&
                                      texteditingController[1].text.length >
                                          0)) {
                                if (isUploaded == true) {
                                  Get.offAndToNamed('/cart');
                                  // await controller.registerCart({
                                  //   "customerNote":
                                  //       texteditingController[2].text,
                                  //   "variationId": variationId,
                                  //   "metadata": metadata
                                  // }, [
                                  //   WooOrderPayloadMetaData(
                                  //       key: '의뢰 방법',
                                  //       value: widget.lastCategory == "기타"
                                  //           ? "기타"
                                  //           : controller.isSelected.value
                                  //               .toString()),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '치수',
                                  //       value: texteditingController[0].text),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '사진',
                                  //       value: controller.uploadImg.value != ""
                                  //           ? controller.uploadImg.value
                                  //           : ""),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '물품 가액',
                                  //       value: texteditingController[1].text),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '추가 옵션',
                                  //       value: controller.radioGroup["추가 옵션"]),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '수선 불가 사유', value: ""),
                                  //   WooOrderPayloadMetaData(
                                  //       key: '추가 수선',
                                  //       value:
                                  //           "{'여부':'false','추가 비용':'', '사유':''}")
                                  // ]);
                                }
                              }
                            }
                          },
                          child: (texteditingController[0].text.length > 0 &&
                                      texteditingController[1].text.length >
                                          0) ||
                                  (widget.lastCategory == "기타" &&
                                      texteditingController[1].text.length > 0)
                              ? Image.asset(
                                  "assets/icons/selectFloatingIcon.png",
                                  height: 54,
                                  width: 54,
                                )
                              : SvgPicture.asset(
                                  "assets/icons/floatingNext.svg",
                                  color: HexColor("#d5d5d5"),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget mysizeInsert() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
            barrierDismissible: false,
            CustomDialog(
              header: DialogHeader(
                  title: '내 치수를 불러오시겠습니까?',
                  content:
                      '총 길이 : ${controller.selectSize.value.toString()}cm'),
              bottom: DialogBottom(isExpanded: true, btn: [
                BtnModel(text: '취소', callback: () => Get.back()),
                BtnModel(
                    text: '불러오기',
                    callback: () {
                      texteditingController[0].text =
                          controller.selectSize.value.toString();
                      Get.close(1);
                    })
              ]),
            ));
      },
      child: Row(
        children: [
          FontStyle(
              text: "내 치수 불러오기",
              fontsize: "",
              fontbold: "",
              fontcolor: Colors.black,
              textdirectionright: false),
          Icon(
            CupertinoIcons.chevron_forward,
            size: 16,
          ),
        ],
      ),
    );
  }

  // optionItem custom
  Widget optionItem(WooProductVariation variation) {
    productFuture;

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
    int currentPrice = int.parse(controller.product.price!);
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
            CustomRadioWidgetOrigin(
              optionName: name(optionName),
              value: controller.radioId.value,
              groupValue: variation.id!,
              onChanged: (value) {
                controller.isRadioGroup({
                  'variation_id': variation.id!,
                  '추가 옵션': name(optionName),
                  '가격': finalPrice.toString()
                });
                controller.radioId.value = variation.id!;
                controller.iswholePrice(addPrice);
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

  // textform
  Widget textForm(String listName, String hintText, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: listName == "물품 가액" ? 10 : 40),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FontStyle(
                text: listName,
                fontsize: "md",
                fontbold: "bold",
                fontcolor: Colors.black,
                textdirectionright: false),
            listName == "치수 입력" ? mysizeInsert() : Container(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 54,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: listName == "치수 입력" || listName == "물품 가액"
                ? [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))]
                : null,
            controller: texteditingController[index],
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                  color: HexColor("#909090").withOpacity(0.7), fontSize: 14),
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
              suffixIcon: listName == "물품 가액"
                  ? Container(
                      padding: EdgeInsets.only(right: 17),
                      child: Text("원"),
                    )
                  : listName == "치수 입력"
                      ? Container(
                          padding: EdgeInsets.only(right: 17),
                          child: Text("cm"),
                        )
                      : null,
            ),
          ),
        ),
      ]),
    );
  }
}
