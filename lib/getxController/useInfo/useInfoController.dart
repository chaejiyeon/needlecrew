import 'dart:developer';
import 'dart:ffi';
// import 'dart:math';

import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:flutter_woocommerce_api/models/order_payload.dart';
import 'package:needlecrew/models/fixReady.dart';
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

  // // 상태별 건수
  // void stateCount() {
  //   // readyCount.value = 0;
  //   // progressCount.value = 0;
  //   // completeCount.value = 0;
  //   for (int i = 0; i < useLists.length; i++) {
  //     if (useLists[i].fixState == "ready") {
  //       readyCount++;
  //     } else if (useLists[i].fixState == "progress") {
  //       progressCount++;
  //     } else {
  //       completeCount++;
  //     }
  //   }
  //   update();
  // }

  // 초기화
  Future<void> initialize() async {
    await getCompleteOrder();

    isInitialized.value = true;
    return;
  }

  // 해당 유저에 정보
  Future<void> getCompleteOrder() async {
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
          'fix-cancle',
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
        print("this status  " + orders[i].status.toString());
        DateTime dateTime = DateTime.parse(orders[i].dateCreated.toString());
        String registerDate = DateFormat('yyyy. MM. dd').format(dateTime);
        String day = DateFormat.E('ko_KR').format(dateTime);

        String orderDate = registerDate + " " + day;

        switch (orders[i].status) {
          case 'processing':
            progressLists.add(FixReady(orders[i].id!, "progress", orderDate,
                orders[i].lineItems!.first.name.toString(), 0));
            break;
          case 'completed':
            completeLists.add(FixReady(orders[i].id!, "complete", orderDate,
                orders[i].lineItems!.first.name.toString(), 1));
            break;
          case 'completed-shipp':
            completeLists.add(FixReady(orders[i].id!, "complete", orderDate,
                orders[i].lineItems!.first.name.toString(), 2));
            break;
          case 'completed-done':
            completeLists.add(FixReady(orders[i].id!, "complete", orderDate,
                orders[i].lineItems!.first.name.toString(), 3));
            break;
          case 'fix-register':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 1));
            break;
          case 'fix-ready':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 2));
            break;
          case 'fix-picked':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 3));
            break;
          case 'fix-arrive':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 4));
            break;
          case 'fix-confirm':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 5));
            break;
          case 'fix-select':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 6));
            break;
          case 'fix-cancle':
            readyLists.add(FixReady(orders[i].id!, "ready", orderDate,
                orders[i].lineItems!.first.name.toString(), 7));
            break;
          default:
            useLists.add(FixReady(orders[i].id!, "pending", orderDate,
                orders[i].lineItems!.first.name.toString(), 0));
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
      await wp_api.wooCommerceApi.updateOrder(
          id: updateOrderId.value, orderMap: {'status': 'processing'});

      print("order status change complete!!! ");

      Get.off(() => PayMent());
    } catch (e) {
      print("isupdateState Error $e");
    }
  }

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
