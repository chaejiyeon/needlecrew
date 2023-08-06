import 'dart:developer';
// import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needlecrew/bottomsheet/useInfoBottomsheet/use_info_process_sheet.dart';
import 'package:needlecrew/custom_text.dart';
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/functions.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/models/util/font_size.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/widgets/update_widgets/use_info/order_list.dart';

class UseInfoController extends GetxController
    with GetTickerProviderStateMixin {
  static UseInfoController get to => Get.find();

  RxInt currentTab = 0.obs;

  final isInitialized = false.obs;

  late List<WooOrder> orders;

  late WooOrder order;
  late WooOrder orderUpdate;

  // 이용내역 list ( 수선대기, 수선 진행중, 수선완료 )
  RxList readyLists = [].obs;
  RxList progressLists = [].obs;
  RxList completeLists = [].obs;
  RxList useLists = [].obs;

  // status 변경 orderId
  RxInt updateOrderId = 0.obs;

  // order meta_data map
  RxMap orderMetaData = {
    '의뢰 방법': '',
    '치수': '',
    '추가 설명': '',
    '추가 옵션': '',
    '물품 가액': '',
    '상품 가격': '',
    '수거 희망일': '',
    '사진': [],
    '수선 불가 사유': ''
  }.obs;

  RxBool widgetUpdate = false.obs;

  // 수선정보 수정-삭제할 이미지 리스트
  RxList delImgs = [].obs;

  // 수선 내역 슬라이드 컨트롤러
  final CarouselController carouselController = CarouselController();


  @override
  void onInit() {
    if (homeInitService.getOrders.isNotEmpty) {
      log('use info controller get orders init-------');
      for (Map item in homeInitService.getOrders) {
        switch (item['order_status']) {
          case 'fix-register':
          case 'fix-ready':
          case 'fix-picked':
          case 'fix-arrive':
          case 'fix-confirm':
          case 'fix-select':
          case 'fix-cancley':
          case 'fix-canclen':
            if (readyLists.isNotEmpty &&
                readyLists.indexWhere(
                        (element) => element['order_id'] == item['order_id']) !=
                    -1) {
              // ready list에 같은 주문 번호가 있을 경우 대치 시켜줌
              readyLists[readyLists.indexWhere(
                      (element) => element['order_id'] == item['order_id'])]
                  ['orders'] = item['orders'];
            } else {
              // ready list에 같은 주문 번호가 없을 경우 추가
              readyLists.add(item);
            }
            log('ready list length this ${readyLists.length}');
            break;
          case 'processing':
            if (progressLists.isNotEmpty &&
                progressLists.indexWhere(
                        (element) => element['order_id'] == item['order_id']) !=
                    -1) {
              // progress list에 같은 주문 번호가 있을 경우 대치 시켜줌
              progressLists[progressLists.indexWhere(
                      (element) => element['order_id'] == item['order_id'])]
                  ['orders'] = item['orders'];
            } else {
              // progress list에 같은 주문 번호가 없을 경우 추가
              progressLists.add(item);
            }
            break;
          case 'completed':
          case 'completed-shipp':
          case 'completed-done':
            if (completeLists.isNotEmpty &&
                completeLists.indexWhere(
                        (element) => element['order_id'] == item['order_id']) !=
                    -1) {
              // complete list에 같은 주문 번호가 있을 경우 대치 시켜줌
              completeLists[completeLists.indexWhere(
                      (element) => element['order_id'] == item['order_id'])]
                  ['orders'] = item['orders'];
            } else {
              // complete list에 같은 주문 번호가 없을 경우 추가
              completeLists.add(item);
            }
            break;
        }
      }

      for (Map item in readyLists) {
        // progress or complete 단계에 주문이 있을 경우 ready 에서 삭제
        if ((progressLists.isNotEmpty &&
                progressLists.indexWhere(
                        (element) => element['order_id'] == item['order_id']) !=
                    -1) ||
            (completeLists.isNotEmpty &&
                completeLists.indexWhere(
                        (element) => element['order_id'] == item['order_id']) !=
                    -1)) {
          readyLists.remove(item);
        }
      }

      for (Map item in progressLists) {
        // complete 주문이 있을 경우 progress에서 삭제
        if (completeLists.isNotEmpty &&
            completeLists.indexWhere(
                    (element) => element['order_id'] == item['order_id']) !=
                -1) {
          progressLists.remove(item);
        }
      }
    }

    ever(homeInitService.getOrders, (callback) {
      if (homeInitService.getOrders.isNotEmpty) {
        log('use info controller get orders init-------');
        for (Map item in homeInitService.getOrders) {
          switch (item['order_status']) {
            case 'fix-register':
            case 'fix-ready':
            case 'fix-picked':
            case 'fix-arrive':
            case 'fix-confirm':
            case 'fix-select':
            case 'fix-cancley':
            case 'fix-canclen':
              if (readyLists.isNotEmpty &&
                  readyLists.indexWhere((element) =>
                          element['order_id'] == item['order_id']) !=
                      -1) {
                // ready list에 같은 주문 번호가 있을 경우 대치 시켜줌
                log('0. use info controller get orders init-------');
                readyLists[readyLists.indexWhere(
                        (element) => element['order_id'] == item['order_id'])]
                    .update('orders', (value) => item['orders']);

                log('0. use info controller get orders init------- ${readyLists[readyLists.indexWhere((element) => element['order_id'] == item['order_id'])]['orders']}');
                // ['orders'] = item['orders'];
              } else {
                // ready list에 같은 주문 번호가 없을 경우 추가
                readyLists.add(item);
              }
              log('ready list length this ${readyLists.length}');
              break;
            case 'processing':
              if (progressLists.isNotEmpty &&
                  progressLists.indexWhere((element) =>
                          element['order_id'] == item['order_id']) !=
                      -1) {
                // progress list에 같은 주문 번호가 있을 경우 대치 시켜줌
                progressLists[progressLists.indexWhere(
                        (element) => element['order_id'] == item['order_id'])]
                    .update('orders', (value) => item['orders']);
                // ['orders'] = item['orders'];
              } else {
                // progress list에 같은 주문 번호가 없을 경우 추가
                progressLists.add(item);
              }
              break;
            case 'completed':
            case 'completed-shipp':
            case 'completed-done':
              if (completeLists.isNotEmpty &&
                  completeLists.indexWhere((element) =>
                          element['order_id'] == item['order_id']) !=
                      -1) {
                // complete list에 같은 주문 번호가 있을 경우 대치 시켜줌
                completeLists[completeLists.indexWhere(
                        (element) => element['order_id'] == item['order_id'])]
                    .update('orders', (value) => item['orders']);
                // ['orders'] = item['orders'];
              } else {
                // complete list에 같은 주문 번호가 없을 경우 추가
                completeLists.add(item);
              }
              break;
          }
        }

        for (Map item in readyLists) {
          // progress or complete 단계에 주문이 있을 경우 ready 에서 삭제
          if ((progressLists.isNotEmpty &&
                  progressLists.indexWhere((element) =>
                          element['order_id'] == item['order_id']) !=
                      -1) ||
              (completeLists.isNotEmpty &&
                  completeLists.indexWhere((element) =>
                          element['order_id'] == item['order_id']) !=
                      -1)) {
            readyLists.remove(item);
          }
        }

        for (Map item in progressLists) {
          // complete 주문이 있을 경우 progress에서 삭제
          if (completeLists.isNotEmpty &&
              completeLists.indexWhere(
                      (element) => element['order_id'] == item['order_id']) !=
                  -1) {
            progressLists.remove(item);
          }
        }
      } else {
        log('get order empty');
        readyLists.clear();
        progressLists.clear();
        completeLists.clear();
      }
      readyLists.refresh();
      progressLists.refresh();
      completeLists.refresh();
    });
    initialize();
    super.onInit();
    initializeDateFormatting();
  }

  @override
  void onClose() {
    isInitialized.value = false;
    useLists.clear();
    super.onClose();
  }

  /// 초기화
  Future<void> initialize() async {
    // await getCompleteOrder();

    isInitialized.value = true;
    return;
  }

  /// 날짜 변환
  Map convertedDate(String pattern, String date) {
    Map dateInfo = {
      'date': '',
      'day': '',
    };

    DateTime dateTime = DateTime.parse(date);
    String registerDate = DateFormat(pattern).format(dateTime);
    String day = DateFormat.E('ko_KR').format(dateTime);

    dateInfo['date'] = registerDate;
    dateInfo['day'] = day;

    return dateInfo;
  }

  /// 수선 내역 업데이트
  Future updateOrder(int id, Map updateContent) async {
    try {
      await wp_api.wooCommerceApi.updateOrder(id: id, orderMap: updateContent);
      printInfo(info: 'update order success===================');
      return true;
    } catch (e) {
      printInfo(info: 'update order failed======================\n$e');
      return false;
    }
  }

  /// 수선 진행 버튼 전체 구성
  setBtnWhole(BuildContext context, order) {
    var setBtnWholeWidget;
    switch (order['order_status']) {
      case 'fix-register':
      case 'fix-ready':
      case 'fix-picked':
      case 'fix-arrive':
      case 'fix-confirm':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '진행 상황', order),
            setBtn(context, '수선 내역', order)
          ],
        );
        break;
      case 'fix-cancley':
      case 'fix-canclen':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '진행 상황', order),
            setBtn(context, '내용 확인', order)
          ],
        );
        break;
      case 'fix-select':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '진행 상황', order),
            setBtn(context, '수선 확정', order)
          ],
        );
        break;
      case 'processing':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '수선 내역', order),
            setBtn(context, '사진 보기', order)
          ],
        );
        break;
      case 'completed-done':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '수선 내역', order),
            setBtn(context, '사진 보기', order)
          ],
        );
        break;
      case 'completed-shipp':
        setBtnWholeWidget = Row(
          children: [
            setBtn(context, '수선 내역', order),
            setBtn(context, '배송 조회', order)
          ],
        );
        break;
      case 'completed':
        setBtnWholeWidget = setBtn(context, '수선 내역', order);
        break;
    }

    return setBtnWholeWidget;
  }

  /// 수선 진행 버튼
  setBtn(BuildContext context, btnText, order) {
    var setBtnWidget;
    var setBtnColor;
    var setBtnBorderColor;
    var setTextColor;
    var setBtnFt;
    switch (btnText) {
      case '진행 상황':
        setBtnFt = () => Functions().showBottomSheet(context,
            bottomSheetHeight: ScreenUtil().screenHeight * 0.68,
            header: Container(
                margin: EdgeInsets.only(top: 50.h),
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                child: CustomText(
                  formPadding: EdgeInsets.only(bottom: 7.h),
                  textAlign: TextAlign.start,
                  formWidth: double.infinity,
                  formDecoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: SetColor().mainColor.withOpacity(0.1),
                  ))),
                  text: '수선 진행 상황',
                  fontSize: FontSize().fs6,
                  fontWeight: FontWeight.bold,
                )),
            bottom: UseInfoProcessSheet(
                progressNum: statusIndex(order['order_status'])));
        break;
      case '수선 내역':
        setBtnFt = () => Functions().showBottomSheet(context,
            scrollBar: false,
            bottomSheetColor: SetColor().colorF7,
            bottomSheetHeight: ScreenUtil().screenHeight * 1.05,
            bottomSheetBorderRadius: 39,
            header: Container(
              padding: EdgeInsets.only(left: 45.w, top: 25.h, right: 24.w),
              margin: EdgeInsets.only(bottom: 11.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: '수선 내역',
                    fontSize: FontSize().fs6,
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Get.back(),
                      child: SvgPicture.asset(
                        'assets/icons/xmarkIcon_full_acolor.svg',
                      ))
                ],
              ),
            ),
            bottom: OrderList(order: order,));
        break;
      case '수선 확정':
        setBtnFt = () {};
        break;
      case '사진 보기':
        setBtnFt = () {};
        break;
      case '내용 확인':
        setBtnFt = () {};
        break;
      case '배송 조회':
        setBtnFt = () {};
        break;
      default:
        break;
    }

    switch (btnText) {
      case '수선 확정':
      case '사진 보기':
      case '내용 확인':
      case '배송 조회':
        setBtnColor = SetColor().mainColor;
        setBtnBorderColor = SetColor().mainColor;
        setTextColor = Colors.white;
        break;
      default:
        setBtnColor = Colors.transparent;
        setBtnBorderColor = SetColor().colorD5;
        setTextColor = Colors.black;
        break;
    }

    setBtnWidget = Container(
      margin: EdgeInsets.only(right: 10),
      width: 87,
      height: 36,
      decoration: BoxDecoration(
        color: setBtnColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 1,
          color: setBtnBorderColor,
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: setBtnFt,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              btnText,
              style: TextStyle(
                color: setTextColor,
              ),
            ),
          ],
        ),
      ),
    );

    return setBtnWidget;
  }

  /// 수선 진행 타이틀
  setTitleComment(order) {
    var setTitle = '';
    switch (order['order_status']) {
      case 'fix-register':
      case 'fix-ready':
      case 'fix-picked':
      case 'fix-arrive':
      case 'fix-confirm':
      case 'fix-select':
      case 'fix-cancley':
      case 'fix-canclen':
        setTitle =
            '${order['order_date']} / ${order['orders'].first.cartProductName} 외 ${order['orders'].length - 1}개';
        break;
      case 'processing':
        setTitle = '고객님의 의류를 수선 중입니다.';
        break;
      case 'completed':
        setTitle = '수선 완료';
        break;
      case 'completed-shipp':
        setTitle = '고객님의 수령지로 의류를 발송하였습니다.';
        break;
      case 'completed-done':
        setTitle = '수선이 완료되었습니다.';
        break;
    }
    return setTitle;
  }

  /// 수선 진행 상태 코멘트
  setStatusComment(String orderStatus) {
    var setStatus = '';
    switch (orderStatus) {
      case 'fix-register':
        setStatus = '수선 접수가 완료되었습니다.';
        break;
      case 'fix-ready':
        setStatus = '의류 수거를 위해 준비중입니다.';
        break;
      case 'fix-picked':
        setStatus = '고객님의 의류가 수선사에게 배송중입니다.';
        break;
      case 'fix-arrive':
        setStatus = '고객님의 의류가 수선사에게 도착했습니다.';
        break;
      case 'fix-confirm':
        setStatus = '수선사가 고객님의 의류를 확인하고 있습니다.';
        break;
      case 'fix-select':
        setStatus = '수선내역에서 최종 결제 비용을 확인해주세요!';
        break;
      case 'fix-cancley':
      case 'fix-canclen':
        setStatus = '접수하신 의뢰는 수선이 불가합니다.';
        break;
    }
    return setStatus;
  }

  /// 진행 상태 인덱스 설정
  statusIndex(orderStatus) {
    var index;
    switch (orderStatus) {
      case 'fix-register':
        index = 1;
        break;
      case 'fix-ready':
        index = 2;
        break;
      case 'fix-picked':
        index = 3;
        break;
      case 'fix-arrive':
        index = 4;
        break;
      case 'fix-confirm':
        index = 5;
        break;
      case 'fix-select':
        index = 6;
        break;
      case 'fix-cancley':
      case 'fix-canclen':
        index = 7;
        break;
    }
    return index;
  }

  // /// 이용내역 화면 설정
  // setUseList() {
  //
  // }

  // Future getCompleteOrder() async {
  //   try {
  //     print(
  //         'get complete order init user id ${homeInitService.user.value.value?.id}');
  //     if (homeInitService.user.value.value?.id != null) {
  //       print(
  //           '1. get complete order init user id ${homeInitService.user.value.value?.id}');
  //       orders = await wp_api.wooCommerceApi.getOrders(
  //         customer: homeInitService.user.value.value?.id,
  //         status: [
  //           'fix-register',
  //           'fix-ready',
  //           'fix-picked',
  //           'fix-arrive',
  //           'fix-confirm',
  //           'fix-select',
  //           'fix-cancley',
  //           'fix-canclen',
  //           'processing',
  //           'completed',
  //           'completed-shipp',
  //           'completed-done',
  //         ],
  //       );
  //
  //       readyLists.clear();
  //       progressLists.clear();
  //       completeLists.clear();
  //       useLists.clear();
  //
  //       log("order status  ddfsd " + orders.toString());
  //       // 수선 대기 단계별 state 설정
  //       for (int i = 0; i < orders.length; i++) {
  //         // DateTime dateTime = DateTime.parse(orders[i].dateCreated.toString());
  //         // String registerDate = DateFormat('yyyy. MM. dd').format(dateTime);
  //         // String day = DateFormat.E('ko_KR').format(dateTime);
  //
  //         // String orderDate = registerDate + " " + day;
  //
  //         Map orderDate =
  //             convertedDate('yyyy. MM. dd', orders[i].dateCreated.toString());
  //
  //         // print("UseInfoController - getCompleteOrder customerNote" + orders[i].customerNote.toString());
  //         Map statusDate = convertedDate(
  //             'MM/dd hh:mm', orders[i].dateModifiedGmt.toString());
  //
  //         print("UseInfoController - getCompleteOrder" + statusDate.toString());
  //
  //         switch (orders[i].status) {
  //           case 'processing':
  //             progressLists.add(FixReady(
  //                 orders[i].id!,
  //                 "progress",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 0,
  //                 false));
  //             break;
  //           case 'completed':
  //             completeLists.add(FixReady(
  //                 orders[i].id!,
  //                 "complete",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 1,
  //                 false));
  //             break;
  //           case 'completed-shipp':
  //             completeLists.add(FixReady(
  //                 orders[i].id!,
  //                 "complete",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 2,
  //                 false));
  //             break;
  //           case 'completed-done':
  //             completeLists.add(FixReady(
  //                 orders[i].id!,
  //                 "complete",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 3,
  //                 false));
  //             break;
  //           case 'fix-register':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 1,
  //                 false));
  //             break;
  //           case 'fix-ready':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 2,
  //                 false));
  //             break;
  //           case 'fix-picked':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 3,
  //                 false));
  //             break;
  //           case 'fix-arrive':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 4,
  //                 false));
  //             break;
  //           case 'fix-confirm':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 5,
  //                 false));
  //             break;
  //           case 'fix-select':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 6,
  //                 false));
  //             break;
  //           case 'fix-cancley':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 7,
  //                 true));
  //             break;
  //           case 'fix-canclen':
  //             readyLists.add(FixReady(
  //                 orders[i].id!,
  //                 "ready",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 7,
  //                 false));
  //             break;
  //           default:
  //             useLists.add(FixReady(
  //                 orders[i].id!,
  //                 "pending",
  //                 orderDate['date'],
  //                 statusDate['date'],
  //                 orders[i].lineItems!.first.name.toString(),
  //                 0,
  //                 false));
  //         }
  //
  //         print("list count " +
  //             readyLists.length.toString() +
  //             progressLists.length.toString() +
  //             completeLists.length.toString());
  //       }
  //     }
  //     return true;
  //   } catch (e) {
  //     print("completeisError " + e.toString());
  //     return false;
  //   }
  // }

  // fixready / fixprogress / fixcomplete 수선내역 bottomsheet
  Future<bool> getFixInfo() async {
    try {
      orderMetaData.clear();
      print("getFixInfo orderid this    " + updateOrderId.value.toString());
      order = await wp_api.wooCommerceApi.getOrderById(updateOrderId.value);

      await orderServices.searchProductById(order.lineItems!.first.productId);

      for (int i = 0; i < order.metaData!.length; i++) {
        printInfo(info: 'oreder metadata this ${order.metaData![i].value}');

        switch (order.metaData![i].key!) {
          case '물품 가액':
            orderMetaData['물품 가액'] = order.metaData![i].value;
            break;
          case '사진':
            orderMetaData['사진'] = order.metaData![i].value.trim().split(',');
            orderMetaData['사진'].remove('');
            break;
          case '의뢰 방법':
            orderMetaData['의뢰 방법'] = order.metaData![i].value;
            break;
          case '추가 옵션':
            orderMetaData['추가 옵션'] = order.metaData![i].value;
            break;
          case '치수':
            orderMetaData['치수'] = order.metaData![i].value;
            break;
          case '수거 희망일':
            orderMetaData['수거 희망일'] = order.metaData![i].value;
            break;
          case '수선 불가 사유':
            orderMetaData['수선 불가 사유'] = order.metaData![i].value;
            break;
        }
      }
      orderMetaData['추가 설명'] = order.customerNote;
      print("getFixInfo this     " + order.toString());
      print("getFixInfo this order metadata     " + orderMetaData.toString());
      return true;
    } catch (e) {
      print("getFixInfo Error $e");
      return false;
    }
  }
}
