import 'dart:developer';
import 'dart:ffi';
// import 'dart:math';

import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:needlecrew/models/fix_ready.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/order.dart';
import 'package:get/get.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:http/http.dart';

// import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:needlecrew/screens/main/myPage/payMent.dart';

class UseInfoController extends GetxController {
  static UseInfoController get to => Get.find();

  final isInitialized = false.obs;

  late WooCustomer user;

  late List<WooOrder> orders;

  late WooOrder order;
  late WooOrder orderUpdate;

  // 이용내역 list ( 수선대기, 수선 진행중, 수선완료 )
  List<FixReady> readyLists = [];
  List<FixReady> progressLists = [];
  List<FixReady> completeLists = [];
  List<FixReady> useLists = [];

  // status 변경 orderId
  RxInt updateOrderId = 0.obs;

  // order meta_data map
  Map orderMetaData = {
    '의뢰 방법': '줄이고 싶은 만큼 치수 입력',
    '치수': '101.5',
    '추가 설명': '시접 여유분 충분히 남겨주세요.',
    '물품 가액': '20000',
  };

  RxBool widgetUpdate = false.obs;

  @override
  void onInit() {
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

  // 초기화
  Future<void> initialize() async {
    // await getCompleteOrder();

    isInitialized.value = true;
    return;
  }

  // 날짜 변환
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




  Future<void> getCompleteOrder() async{
    try {
      user = await wp_api.getUser();

      orders = await wp_api.wooCommerceApi.getOrders(
        customer: user.id,
        status: [
          'fix-register',
          'fix-ready',
          'fix-picked',
          'fix-arrive',
          'fix-confirm',
          'fix-select',
          'fix-cancley',
          'fix-canclen',
          'processing',
          'completed',
          'completed-shipp',
          'completed-done',
        ],
      );

      readyLists.clear();
      progressLists.clear();
      completeLists.clear();
      useLists.clear();

      log("order status  ddfsd " + orders.toString());
      // 수선 대기 단계별 state 설정
      for (int i = 0; i < orders.length; i++) {
        // DateTime dateTime = DateTime.parse(orders[i].dateCreated.toString());
        // String registerDate = DateFormat('yyyy. MM. dd').format(dateTime);
        // String day = DateFormat.E('ko_KR').format(dateTime);

        // String orderDate = registerDate + " " + day;

        Map orderDate =
            convertedDate('yyyy. MM. dd', orders[i].dateCreated.toString());

        // print("UseInfoController - getCompleteOrder customerNote" + orders[i].customerNote.toString());
        Map statusDate =
            convertedDate('MM/dd hh:mm', orders[i].dateModifiedGmt.toString());

        print("UseInfoController - getCompleteOrder" + statusDate.toString());

        switch (orders[i].status) {
          case 'processing':
            progressLists.add(FixReady(
                orders[i].id!,
                "progress",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                0,
                false));
            break;
          case 'completed':
            completeLists.add(FixReady(
                orders[i].id!,
                "complete",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                1,
                false));
            break;
          case 'completed-shipp':
            completeLists.add(FixReady(
                orders[i].id!,
                "complete",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                2,
                false));
            break;
          case 'completed-done':
            completeLists.add(FixReady(
                orders[i].id!,
                "complete",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                3,
                false));
            break;
          case 'fix-register':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                1,
                false));
            break;
          case 'fix-ready':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                2,
                false));
            break;
          case 'fix-picked':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                3,
                false));
            break;
          case 'fix-arrive':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                4,
                false));
            break;
          case 'fix-confirm':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                5,
                false));
            break;
          case 'fix-select':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                6,
                false));
            break;
          case 'fix-cancley':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                7,
                true));
            break;
          case 'fix-canclen':
            readyLists.add(FixReady(
                orders[i].id!,
                "ready",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                7,
                false));
            break;
          default:
            useLists.add(FixReady(
                orders[i].id!,
                "pending",
                orderDate['date'],
                statusDate['date'],
                orders[i].lineItems!.first.name.toString(),
                0,
                false));
        }

        print("list count " +
            readyLists.length.toString() +
            progressLists.length.toString() +
            completeLists.length.toString());


      }
    } catch (e) {
      print("isError " + e.toString());
    }
  }

  // 수선 확정 버튼 클릭 시 > 수선 진행중으로 status  변경
  Future<void> updateState() async {
    try {
      await wp_api.wooCommerceApi
          .updateOrder(id: updateOrderId.value, orderMap: {
        'status': 'processing',
        'meta_data': [
          {'key': '진행 상황', 'value': '수선 진행중'}
        ]
      });

      print("order status change complete!!! ");

      // Get.off(() => PayMent());
    } catch (e) {
      print("isupdateState Error $e");
    }
  }

  // 해당 유저에 정보
  // Future<void> getCompleteOrder() async {
  //   try {
  //     user = await wp_api.getUser();
  //
  //     orders = await wp_api.wooCommerceApi.getOrders(
  //       customer: user.id,
  //       status: [
  //         'fix-register',
  //         'fix-ready',
  //         'fix-picked',
  //         'fix-arrive',
  //         'fix-confirm',
  //         'fix-select',
  //         'fix-cancley',
  //         'fix-canclen',
  //         'processing',
  //         'completed',
  //         'completed-shipp',
  //         'completed-done',
  //       ],
  //     );
  //
  //     readyLists.clear();
  //     progressLists.clear();
  //     completeLists.clear();
  //     useLists.clear();
  //
  //     log("order status  ddfsd " + orders.toString());
  //     // 수선 대기 단계별 state 설정
  //     for (int i = 0; i < orders.length; i++) {
  //       // DateTime dateTime = DateTime.parse(orders[i].dateCreated.toString());
  //       // String registerDate = DateFormat('yyyy. MM. dd').format(dateTime);
  //       // String day = DateFormat.E('ko_KR').format(dateTime);
  //
  //       // String orderDate = registerDate + " " + day;
  //
  //       Map orderDate =
  //           convertedDate('yyyy. MM. dd', orders[i].dateCreated.toString());
  //
  //       // print("UseInfoController - getCompleteOrder customerNote" + orders[i].customerNote.toString());
  //       Map statusDate =
  //           convertedDate('MM/dd hh:mm', orders[i].dateModifiedGmt.toString());
  //
  //       print("UseInfoController - getCompleteOrder" + statusDate.toString());
  //
  //       switch (orders[i].status) {
  //         case 'processing':
  //           progressLists.add(FixReady(
  //               orders[i].id!,
  //               "progress",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               0,
  //               false));
  //           break;
  //         case 'completed':
  //           completeLists.add(FixReady(
  //               orders[i].id!,
  //               "complete",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               1,
  //               false));
  //           break;
  //         case 'completed-shipp':
  //           completeLists.add(FixReady(
  //               orders[i].id!,
  //               "complete",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               2,
  //               false));
  //           break;
  //         case 'completed-done':
  //           completeLists.add(FixReady(
  //               orders[i].id!,
  //               "complete",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               3,
  //               false));
  //           break;
  //         case 'fix-register':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               1,
  //               false));
  //           break;
  //         case 'fix-ready':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               2,
  //               false));
  //           break;
  //         case 'fix-picked':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               3,
  //               false));
  //           break;
  //         case 'fix-arrive':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               4,
  //               false));
  //           break;
  //         case 'fix-confirm':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               5,
  //               false));
  //           break;
  //         case 'fix-select':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               6,
  //               false));
  //           break;
  //         case 'fix-cancley':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               7,
  //               true));
  //           break;
  //         case 'fix-canclen':
  //           readyLists.add(FixReady(
  //               orders[i].id!,
  //               "ready",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               7,
  //               false));
  //           break;
  //         default:
  //           useLists.add(FixReady(
  //               orders[i].id!,
  //               "pending",
  //               orderDate['date'],
  //               statusDate['date'],
  //               orders[i].lineItems!.first.name.toString(),
  //               0,
  //               false));
  //       }
  //
  //
  //       print("list count " +
  //           readyLists.length.toString() +
  //           progressLists.length.toString() +
  //           completeLists.length.toString());
  //     }
  //   } catch (e) {
  //     print("isError " + e.toString());
  //   }
  // }
  //
  // // 수선 확정 버튼 클릭 시 > 수선 진행중으로 status  변경
  // Future<void> updateState() async {
  //   try {
  //     await wp_api.wooCommerceApi
  //         .updateOrder(id: updateOrderId.value, orderMap: {
  //       'status': 'processing',
  //       'meta_data':[ {'key': '진행 상황', 'value': '수선 진행중'}]
  //     });
  //
  //     print("order status change complete!!! ");
  //
  //     // Get.off(() => PayMent());
  //   } catch (e) {
  //     print("isupdateState Error $e");
  //   }
  // }

  // fixready / fixprogress / fixcomplete 수선내역 bottomsheet
  Future<bool> getFixInfo() async {
    try {
      print("getFixInfo orderid this    " + updateOrderId.value.toString());
      order = await wp_api.wooCommerceApi.getOrderById(updateOrderId.value);

      for (int i = 0; i < order.metaData!.length; i++) {
        if (order.metaData![i].key!.indexOf('물품 가액') != -1) {
          orderMetaData['물품 가액'] = order.metaData![i].value;
        } else if (order.metaData![i].key!.indexOf('사진') != -1) {
          orderMetaData['사진'] = order.metaData![i].value;
        } else if (order.metaData![i].key!.indexOf('의뢰 방법') != -1) {
          orderMetaData['의뢰 방법'] = order.metaData![i].value;
        } else if (order.metaData![i].key!.indexOf('추가 설명') != -1) {
          orderMetaData['추가 설명'] = order.metaData![i].value;
        } else if (order.metaData![i].key!.indexOf('추가 옵션') != -1) {
          orderMetaData['추가 옵션'] = order.metaData![i].value;
        } else if (order.metaData![i].key!.indexOf('치수') != -1) {
          orderMetaData['치수'] = order.metaData![i].value;
        }
      }
      print("getFixInfo this     " + order.toString());
      print("getFixInfo this order metadata     " + orderMetaData.toString());
      return true;
    } catch (e) {
      print("getFixInfo Error   $e");
      return false;
    }
  }
}
