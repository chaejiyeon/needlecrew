import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/controller/my_use_info/useInfo_controller.dart';
import 'package:needlecrew/custom_dialog.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/modal/alert_dialog_yes.dart';
import 'package:needlecrew/models/widgets/btn_model.dart';
import 'package:flutter/material.dart';
import 'package:needlecrew/widgets/font_style.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FixCompleteModal extends StatelessWidget {
  final UseInfoController controller;
  final int orderid;

  const FixCompleteModal(
      {Key? key, required this.orderid, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    paymentService.getCardAll();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        width: 297,
        height: 174,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FontStyle(
                      text: "수선을 확정하시겠습니까?",
                      fontsize: "md",
                      fontbold: "bold",
                      fontcolor: Colors.black,
                      textdirectionright: false),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "수선 확정 시 수선을 진행합니다.\n수선 진행 중에는 치수를 변경할 수 없습니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HexColor("#606060")),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#d5d5d5")),
                        right: BorderSide(color: HexColor("#d5d5d5")),
                      )),
                      child: TextButton(
                          child: Text(
                            "취소",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Get.back();
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: HexColor("#d5d5d5")),
                      )),
                      child: TextButton(
                          child:
                              Text("확정", style: TextStyle(color: Colors.black)),
                          onPressed: () async {
                            Get.close(1);
                            controller.updateOrderId.value = orderid;
                            // if (paymentService.cardsInfo.length == 0) {
                            //   Get.dialog(AlertDialogYes(
                            //     titleText: "결제할 카드를 등록해주세요.",
                            //     widgetname: "alert",
                            //   ));
                            // } else {
                            if (await paymentService.orderInfo(orderid)) {
                              paymentService.payOrder(
                                paidShipping: {
                                  'paid_shipping': false,
                                  'order_id': orderid
                                },
                                payType: 'card',
                                payInfo: {
                                  'order_name': '',
                                  'merchant_uid':
                                      'mid_${FormatMethod().convertDate(DateTime.now().millisecondsSinceEpoch, 'yyMMdd')}${paymentService.orderMap['order_no']}',
                                  'amount': int.parse(
                                      paymentService.orderMap['order_price'])
                                },
                              );
                            } else {
                              Get.dialog(
                                  barrierDismissible: false,
                                  CustomDialog(
                                      header: DialogHeader(
                                          title: '결제 정보 확인',
                                          content: '관리자에게 문의해주세요.'),
                                      bottom: DialogBottom(
                                          mainAlignment:
                                              MainAxisAlignment.center,
                                          btn: [
                                            BtnModel(
                                                text: '확인',
                                                callback: () => Get.close(1))
                                          ])));
                              // }
                              // Get.off(() => PayMent(orderid: orderid,));
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
