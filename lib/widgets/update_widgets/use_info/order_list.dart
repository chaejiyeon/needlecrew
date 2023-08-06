import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/functions.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/tooltip_text.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_update.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

class OrderList extends GetView<UseInfoController> {
  final Map order;

  const OrderList({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.currentTab.value = 0;

    return Column(children: [
      customForm(
          borderRadius: BorderRadius.circular(14),
          margin: EdgeInsets.only(left: 24.w, right: 24.w),
          padding: EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          widget: Stack(alignment: Alignment.center, children: [
            CarouselSlider(
              carouselController: controller.carouselController,
              items: List.generate(
                order['orders'].length,
                (index) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카테고리 이름
                      CustomText(
                        text: order['orders'][index].cartCategoryName,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      Line(
                          margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          width: double.infinity,
                          height: 1,
                          lineColor: SetColor().color90.withOpacity(0.5)),

                      // 상품 이미지
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: List.generate(
                                order['orders'][index].cartImages.length,
                                (i) => ImageItem(
                                    padding: EdgeInsets.only(right: 10.w),
                                    image:
                                        order['orders'][index].cartImages[i])),
                          ),
                        ),
                      ),

                      // 상품명
                      CustomText(
                        formMargin: EdgeInsets.only(bottom: 15.h),
                        text: order['orders'][index].cartProductName,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      // 의뢰 방법
                      Container(
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: EasyRichText(
                          '의뢰 방법 : ${order['orders'][index].cartWay}',
                          patternList: [
                            EasyRichTextPattern(
                                targetString: '의뢰 방법',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      // 치수
                      Container(
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: EasyRichText(
                          '치수 : ${order['orders'][index].cartSize}cm',
                          patternList: [
                            EasyRichTextPattern(
                                targetString: '치수',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      // 추가 설명
                      Container(
                        margin: EdgeInsets.only(bottom: 5.5.h),
                        child: EasyRichText(
                          '추가 설명 : ${order['orders'][index].cartContent == '' ? '없음 ' : order['orders'][index].cartContent}',
                          patternList: [
                            EasyRichTextPattern(
                                targetString: '추가 설명',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      // 물품 가액
                      EasyRichText(
                        '물품 가액 : ${FormatMethod().convertPrice(price: int.parse(order['orders'][index].guaranteePrice), type: '###,###,###원')}',
                        patternList: [
                          EasyRichTextPattern(
                              targetString: '물품 가액',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      Line(
                        margin: EdgeInsets.only(top: 10.4.h, bottom: 15.h),
                        lineColor: SetColor().colorEd,
                        width: double.infinity,
                        height: 1,
                      ),
                      // 의뢰 비용
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TooltipCustom(
                              tooltipText: cost.tooltipText,
                              titleText: cost.tooltipName,
                              boldText: cost.boldText,
                              tailPosition: 'up',
                              fontsize: 14,
                            ),
                            EasyRichText(
                              '${FormatMethod().convertPrice(price: int.parse(order['orders'][index].productPrice))}원',
                              patternList: [
                                EasyRichTextPattern(
                                    targetString: FormatMethod().convertPrice(
                                        price: int.parse(order['orders'][index]
                                            .productPrice)),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            )
                          ]),
                      // 버튼 구역
                      !order['orders'][index].changeInfo['수선 가능여부']
                          ? CustomText(
                              text:
                                  '수선 취소사유 : ${order['orders'][index].changeInfo['수선 불가 사유']}',
                              fontSize: FontSize().fs4,
                              fontColor: Colors.redAccent,
                            )
                          : Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomBtn(
                                        btnText: '수선 취소',
                                        btnFt: () {
                                          Get.dialog(
                                              barrierDismissible: false,
                                              CustomDialog(
                                                header: DialogHeader(
                                                    headerWidget: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 14.h),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/tearIcon.svg"),
                                                    ),
                                                    title: '접수한 의뢰를 취소할까요?'),
                                                bottom: DialogBottom(
                                                    isExpanded: true,
                                                    btn: [
                                                      BtnModel(
                                                          text: '아니요',
                                                          callback: () =>
                                                              Get.back()),
                                                      BtnModel(
                                                          text: '예, 취소할게요.',
                                                          callback: () async {
                                                            order['orders']
                                                                    [index]
                                                                .changeInfo = {
                                                              '수선 가능여부': false,
                                                              '수선 불가 사유':
                                                                  '사용자취소',
                                                              '추가 금액': 0
                                                            };

                                                            log('수선 가능여부 ㅇㅇㅇㅇㅇㅇㅇㅇ${order['orders'][index].changeInfo}');
                                                            if (await controller
                                                                .updateOrder(
                                                                    order[
                                                                        'order_id'],
                                                                    {
                                                                  'meta_data': [
                                                                    {
                                                                      'key':
                                                                          '상품_${order['orders'][index].cartProductName}_${order['orders'][index].cartId}',
                                                                      'value': order['orders']
                                                                              [
                                                                              index]
                                                                          .toMap()
                                                                    }
                                                                  ]
                                                                })) {
                                                              // if (await controller
                                                              //     .getCompleteOrder()) {
                                                              //   Get.close(2);
                                                              // }
                                                            }
                                                          })
                                                    ]),
                                              ));
                                        },
                                        btnHeight: 44.h,
                                        btnAlignment: Alignment.center,
                                        boxDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            color: SetColor().colorD5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9.5.w,
                                    ),
                                    Expanded(
                                        child: CustomBtn(
                                            btnText: '의뢰 수정',
                                            btnFt: () {
                                              Get.to(FixUpdate(
                                                  orderMetaData: OrderMetaData(
                                                      orderId:
                                                          order['order_id'],
                                                      productId: order['orders']
                                                              [index]
                                                          .productId!,
                                                      variationId:
                                                          order['orders'][index]
                                                              .variationId!,
                                                      cartProductName:
                                                          order['orders'][index]
                                                                  .cartProductName ??
                                                              '',
                                                      cartCount: order['orders']
                                                              [index]
                                                          .cartCount,
                                                      cartImages:
                                                          order['orders'][index]
                                                              .cartImages,
                                                      cartWay: order['orders'][index]
                                                          .cartWay,
                                                      cartSize: order['orders'][index].cartSize,
                                                      cartContent: order['orders'][index].cartContent,
                                                      guaranteePrice: order['orders'][index].guaranteePrice,
                                                      productPrice: order['orders'][index].productPrice)));
                                            },
                                            btnHeight: 44.h,
                                            btnAlignment: Alignment.center,
                                            boxDecoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                color: SetColor().colorD5,
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 512.h,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    controller.currentTab.value = index;
                  }),
            ),
            // 페이지 표시
            order['orders'].length > 1
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            order['orders'].length,
                            (index) => Obx(
                                  () => Container(
                                    width: 10.w,
                                    height: 10.h,
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.currentTab.value == index
                                                ? SetColor().color90
                                                : SetColor()
                                                    .color90
                                                    .withOpacity(0.1)),
                                  ),
                                )),
                      ),
                    ),
                  )
                : Container(),
          ])),
      //배송지 정보
      customForm(
          margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
          padding:
              EdgeInsets.only(top: 20.h, left: 44.w, right: 44.w, bottom: 20.h),
          height: 230.h,
          widget: Column(
            children: [
              CustomText(
                formAlign: Alignment.centerLeft,
                text: '배송지 정보',
                fontSize: FontSize().fs4,
                fontWeight: FontWeight.bold,
              ),
              Line(
                margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                lineColor: SetColor().colorEd,
                width: double.infinity,
                height: 1,
              ),
              customFormItem(
                  title: '수령인',
                  info: order['customer_info'] != null &&
                          order['customer_info']['수령인'] != null
                      ? order['customer_info']['수령인']
                      : ''),
              customFormItem(
                  title: '연락처',
                  info: order['customer_info'] != null &&
                          order['customer_info']['연락처'] != null
                      ? order['customer_info']['연락처']
                      : ''),
              customFormItem(
                  title: '배송지',
                  info: order['customer_info'] != null &&
                          order['customer_info']['주소'] != null
                      ? order['customer_info']['주소']
                      : ''),
              customFormItem(
                  title: '수거 희망일',
                  info: order['customer_info'] != null &&
                          order['customer_info']['수거희망일'] != null
                      ? order['customer_info']['수거희망일']
                      : ''),
            ],
          )),
      // 총 의뢰예상비용
      customForm(
          margin: EdgeInsets.only(
              bottom:
                  order['pay_info'] != null && order['pay_info']['결제여부'] == 'Y'
                      ? 10.h
                      : 30.h),
          padding:
              EdgeInsets.only(top: 20.h, left: 44.w, right: 44.w, bottom: 20.h),
          widget: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    formAlign: Alignment.centerLeft,
                    text: '총 의뢰 예상 비용',
                    fontSize: FontSize().fs4,
                    fontWeight: FontWeight.bold,
                  ),
                  EasyRichText(
                    '${FormatMethod().convertPrice(price: int.parse(order['order_info'].total ?? 0))}원',
                    patternList: [
                      EasyRichTextPattern(
                          targetString: FormatMethod().convertPrice(
                              price: int.parse(order['order_info'].total ?? 0)),
                          style: TextStyle(
                              color: SetColor().mainColor,
                              fontWeight: FontWeight.bold))
                    ],
                  )
                ],
              )
            ],
          )),
      // 결제정보
      order['pay_info'] != null && order['pay_info']['결제여부'] == 'Y'
          ? customForm(
              margin: EdgeInsets.only(bottom: 30.h),
              padding: EdgeInsets.only(
                  top: 20.h, left: 44.w, right: 44.w, bottom: 20.h),
              widget: Column(
                children: [
                  CustomText(
                    formAlign: Alignment.centerLeft,
                    text: '결제 정보',
                    fontSize: FontSize().fs4,
                    fontWeight: FontWeight.bold,
                  ),
                  Line(
                    margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    lineColor: SetColor().colorEd,
                    width: double.infinity,
                    height: 1,
                  ),
                  customFormItem(
                      title: '신용카드', info: order['pay_info']['결제카드']),
                ],
              ))
          : Container()
    ]);
  }

  Widget listItem(String title, String subText) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          CustomText(
            text: '$title : ',
            fontSize: FontSize().fs4,
            fontWeight: FontWeight.bold,
          ),
          CustomText(text: '$subText', fontSize: FontSize().fs4)
        ],
      ),
    );
  }

  Widget customForm(
      {EdgeInsets? margin,
      EdgeInsets? padding,
      Alignment? alignment,
      BorderRadius? borderRadius,
      double? height,
      Widget? widget}) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: SetColor().colorEd,
            blurRadius: 5,
            offset: Offset(1.5, 2.6),
          ),
        ],
      ),
      child: widget,
    );
  }

  Widget customFormItem({String title = '', String info = ''}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              text: title,
              fontSize: FontSize().fs4,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: CustomText(
              text: info,
              fontSize: FontSize().fs4,
              textAlign: TextAlign.right,
              textMaxLines: 100,
            ),
          )
        ],
      ),
    );
  }
}
