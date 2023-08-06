import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/customer.dart';
import 'package:get/get.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/controller/home_controller.dart';
import 'package:needlecrew/controller/page_controller/select_clothes_type_controller.dart';
import 'package:needlecrew/controller/widget_controller/custom_drop_down_controller.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/db/wp-api.dart';
import 'package:needlecrew/format_method.dart';
import 'package:needlecrew/models/address_item.dart';
import 'package:needlecrew/models/cart_item.dart';
import 'package:needlecrew/models/wp_models/annoucement_item.dart';
import 'package:needlecrew/models/wp_models/banner_item.dart';
import 'package:needlecrew/models/billing_info.dart';
import 'package:needlecrew/models/util/set_color.dart';
import 'package:needlecrew/models/wp_models/base_url.dart';
import 'package:needlecrew/models/wp_models/wp_size_model.dart';
import 'package:needlecrew/screens/login/loading_page.dart';
import '../screens/main_page.dart';
import 'package:http/http.dart' as http;

class HomeInitService extends GetxService {
  final HomeController homeController = Get.put(HomeController());
  final FixSelectController fixSelectController =
      Get.put(FixSelectController());
  final SelectClothesTypeController selectClothesTypeController =
      Get.put(SelectClothesTypeController());

  late CustomDropDownController dropDownController;

  late Stream stream;

  // user id
  RxInt userId = 0.obs;

  // user 정보 -UI
  RxMap userInfo = {
    'login_token': '',
    'user_name': '',
    'phone_number': '',
    'address': '',
    'default_card': ''
  }.obs;

  // 전체 주문 | map list : { 'order_date': '${orderDate['date']} ${orderDate['day']}',
  //                 'order_id': orders[i].id,
  //                 'order_status': orders[i].status,
  //                 'orders': List<OrderMetaData>}
  RxList getOrders = [].obs;

  // user 정보
  var user = Rxn<WooCustomer>().obs;

  // 로그인에 따른 화면 설정
  var mainHome = Rxn<Widget>().obs;

  // 주소 목록
  RxList items = [].obs;

  // 카드 목록
  RxList cardItems = [].obs;

  // 가격표 카테고리 목록 {'id' : , 'name' : ''}
  RxList priceCategories = [].obs;

  // 메인 진입시 메인창 설정
  RxBool mainModalcheck = false.obs;

  // banner 목록
  var banners = List<BannerItem>.empty(growable: true).obs;
  RxList<AnnouncementItem> announcements = <AnnouncementItem>[].obs;

  // 사이즈 목록 ['shirt' : ShirtModel, 'pants' : PantsModel, 'skirt' : SkirtModel, 'one_piece' : OnepieceModel, 'jumper' : OuterModel, 'jacket' : OuterModel, 'coat' : OuterModel]
  RxList getSizeList = [].obs;

  // 로딩
  RxBool isLoading = false.obs;

  // 로그인 로딩
  RxBool loginLoading = false.obs;

  @override
  void onInit() async {
    log('home init service');
    await getPriceInfoCategories();
    dropDownController = Get.put(CustomDropDownController());

    await syncUser();
    await getBanner();
    await getAnnouncement();
    await getSize();
    await utilsService.getHolidays();
    await getOrderAll();

    ever<bool>(
        loginLoading,
        (callback) => {
              if (callback)
                {
                  Get.dialog(
                      barrierDismissible: false,
                      Center(
                        child: CircularProgressIndicator(
                          color: SetColor().mainColor,
                        ),
                      ))
                }
            });
    ever(user, (callback) async {
      await getSize();
    });

    Timer.periodic(Duration(seconds: 10), (timer) async {
      log('get order all ----------------');
      await getOrderAll();
    });
    super.onInit();
  }

  /// 로그인 유저 정보
  Future syncUser() async {
    printInfo(info: 'init!!!!!!!!!');

    try {
      printInfo(info: '1. init!!!!!!!!! ');

      var login = await wp_api.isLogged();

      items.clear();

      printInfo(info: '2. init!!!!!!!!! $login');
      if (login) {
        try {
          int? setUserId = await wp_api.wooCommerceApi.fetchLoggedInUserId();

          printInfo(info: 'init!!!!!!!!! ${setUserId}');
          user.value.value =
              await wp_api.wooCommerceApi.getCustomerById(id: setUserId);
          printInfo(info: 'init!!!!!!!!! ${user.value.value!.username}');
          userId.value = setUserId!;

          List<WooCustomerMetaData> metadata = user.value.value!.metaData!;

          printInfo(info: "login 성공!!!!!!!! ${user.value!.toString()}");

          FlutterNativeSplash.remove();
          homeInitService.mainHome.value.value = MainPage(pageNum: 0);

          for (int i = 0; i < metadata.length; i++) {
            printInfo(info: 'metadata key this ${metadata[i].key}');
            if (metadata[i].key == "phoneNum") {
              userInfo['phone_number'] = metadata[i].value;
            } else if (metadata[i].key == "default_address") {
              if (metadata[i].value != "") {
                printInfo(info: 'address info ${metadata[i].value}');
                var addressInfo = jsonDecode(metadata[i].value);
                addressInfo.forEach((key, value) => {
                      printInfo(info: 'key this $key value this $value'),
                      items.add(AddressItem(
                          key == 'home'
                              ? 0
                              : key == 'company'
                                  ? 1
                                  : 2,
                          key,
                          value)),
                    });
                printInfo(info: 'address list length this ${items.length}');
                userInfo['address'] = addressInfo['home'];
              }
            } else if (metadata[i].key == "default_card") {
              printInfo(info: 'get card info this ${metadata[i].value}');
              if (metadata[i].value != null || metadata[i].value != "") {
                CardInfo cardInfo =
                    await paymentService.getCardInfo(metadata[i].value) ??
                        CardInfo();
                if (cardInfo.card_name != null) {
                  userInfo['default_card'] = cardInfo.card_name +
                      "(" +
                      cardInfo.card_number.substring(12, 16) +
                      ")";
                }
              }
            } else if (metadata[i].key == 'pay_cards') {
              printInfo(info: 'get card info this ${metadata[i].value}');

              if (metadata[i].value != null || metadata[i].value != "") {
                if (metadata[i].value.contains(',')) {
                  var getCardItems = metadata[i].value.split(',');
                  for (String item in getCardItems) {
                    CardInfo cardInfo =
                        await paymentService.getCardInfo(item) ?? CardInfo();
                    if (cardInfo.card_name != null) {
                      cardItems.add(cardInfo);
                    }
                  }
                } else {
                  CardInfo cardInfo =
                      await paymentService.getCardInfo(metadata[i].value) ??
                          CardInfo();
                  if (cardInfo.card_name != null) {
                    cardItems.add(cardInfo);
                  }
                }
              }
            }
          }

          items.sort((a, b) => a.sort.compareTo(b.sort));

          print("user " + user.toString());
        } catch (e) {
          printInfo(info: "login 실패!!!!!!!! ${user.value!.toString()}");
          FlutterNativeSplash.remove();
          homeInitService.mainHome.value.value = LoadingPage();
        }
      } else {
        printInfo(info: "login 실패!!!!!!!! ${user.value!.toString()}");
        FlutterNativeSplash.remove();
        homeInitService.mainHome.value.value = LoadingPage();
      }
      return true;
    } catch (e) {
      print("wp-api - getUser info error" + e.toString());
      if (e.toString().indexOf('jwt_auth_invalid_token') != -1) {
        wp_api.logOut();
        print("Expired token - 재로그인");
      }
      print("wp-api - getUser info error" + e.toString());
      return false;
    }
  }

  /// 치수 가져오기
  Future getSize() async {
    try {
      getSizeList.clear();

      printInfo(info: 'user id this ${user.value.value!.id}');
      var getUser =
          await wp_api.wooCommerceApi.getCustomerById(id: user.value.value?.id);

      List<WooCustomerMetaData> metadata = getUser.metaData!;

      if (metadata.isEmpty) {
        if (getSizeList.isNotEmpty) {
          if (!getSizeList.any((e) => e.containsKey('shirt'))) {
            getSizeList.add({'shirt': ShirtModel()});
          } else if (!getSizeList.any((e) => e.containsKey('pants'))) {
            getSizeList.add({'pants': PantsModel()});
          } else if (!getSizeList.any((e) => e.containsKey('skirt'))) {
            getSizeList.add({'skirt': SkirtModel()});
          } else if (!getSizeList.any((e) => e.containsKey('one_piece'))) {
            getSizeList.add({'one_piece': OnepieceModel()});
          } else if (!getSizeList.any((e) => e.containsKey('jumper'))) {
            getSizeList.add({'jumper': OuterModel()});
          } else if (!getSizeList.any((e) => e.containsKey('jacket'))) {
            getSizeList.add({'jacket': OuterModel()});
          } else if (!getSizeList.any((e) => e.containsKey('coat'))) {
            getSizeList.add({'coat': OuterModel()});
          }
        } else {
          getSizeList.add({'shirt': ShirtModel()});
          getSizeList.add({'pants': PantsModel()});
          getSizeList.add({'skirt': SkirtModel()});
          getSizeList.add({'one_piece': OnepieceModel()});
          getSizeList.add({'jumper': OuterModel()});
          getSizeList.add({'jacket': OuterModel()});
          getSizeList.add({'coat': OuterModel()});
        }
        getSizeList.refresh();
      } else {
        for (WooCustomerMetaData data in metadata) {
          switch (data.key) {
            case 'shirt_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  ShirtModel shirtModel = ShirtModel.fromJson(metaInfo);
                  getSizeList.add({'shirt': shirtModel});
                } else {
                  getSizeList.add({'shirt': ShirtModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('shirt'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    ShirtModel shirtModel = ShirtModel.fromJson(metaInfo);
                    getSizeList.add({'shirt': shirtModel});
                  } else {
                    getSizeList.add({'shirt': ShirtModel()});
                  }
                }
              }
              break;
            case 'pants_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  PantsModel pantsModel = PantsModel.fromJson(metaInfo);
                  getSizeList.add({'pants': pantsModel});
                } else {
                  getSizeList.add({'pants': PantsModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('pants'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    PantsModel pantsModel = PantsModel.fromJson(metaInfo);
                    getSizeList.add({'pants': pantsModel});
                  } else {
                    getSizeList.add({'pants': PantsModel()});
                  }
                }
              }
              break;
            case 'skirt_size':
              if (data.value != "") {
                Map metaInfo = jsonDecode(data.value);
                SkirtModel skirtModel = SkirtModel.fromJson(metaInfo);
                getSizeList.add({'skirt': skirtModel});
              } else {
                getSizeList.add({'skirt': SkirtModel()});
              }
              if (getSizeList.isEmpty) {
              } else {
                if (!getSizeList.any((e) => e.containsKey('skirt'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    SkirtModel skirtModel = SkirtModel.fromJson(metaInfo);
                    getSizeList.add({'skirt': skirtModel});
                  } else {
                    getSizeList.add({'skirt': SkirtModel()});
                  }
                }
              }
              break;
            case 'onepiece_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  OnepieceModel onepieceModel =
                      OnepieceModel.fromJson(metaInfo);
                  getSizeList.add({'one_piece': onepieceModel});
                } else {
                  getSizeList.add({'one_piece': OnepieceModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('one_piece'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    OnepieceModel onepieceModel =
                        OnepieceModel.fromJson(metaInfo);
                    getSizeList.add({'one_piece': onepieceModel});
                  } else {
                    getSizeList.add({'one_piece': OnepieceModel()});
                  }
                }
              }
              break;
            case 'jumper_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  OuterModel outerModel = OuterModel.fromJson(metaInfo);
                  getSizeList.add({'jumper': outerModel});
                } else {
                  getSizeList.add({'jumper': OuterModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('jumper'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    OuterModel outerModel = OuterModel.fromJson(metaInfo);
                    getSizeList.add({'jumper': outerModel});
                  } else {
                    getSizeList.add({'jumper': OuterModel()});
                  }
                }
              }
              break;
            case 'jacket_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  OuterModel outerModel = OuterModel.fromJson(metaInfo);
                  getSizeList.add({'jacket': outerModel});
                } else {
                  getSizeList.add({'jacket': OuterModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('jacket'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    OuterModel outerModel = OuterModel.fromJson(metaInfo);
                    getSizeList.add({'jacket': outerModel});
                  } else {
                    getSizeList.add({'jacket': OuterModel()});
                  }
                }
              }
              break;
            case 'coat_size':
              if (getSizeList.isEmpty) {
                if (data.value != "") {
                  Map metaInfo = jsonDecode(data.value);
                  OuterModel outerModel = OuterModel.fromJson(metaInfo);
                  getSizeList.add({'coat': outerModel});
                } else {
                  getSizeList.add({'coat': OuterModel()});
                }
              } else {
                if (!getSizeList.any((e) => e.containsKey('coat'))) {
                  if (data.value != "") {
                    Map metaInfo = jsonDecode(data.value);
                    OuterModel outerModel = OuterModel.fromJson(metaInfo);
                    getSizeList.add({'coat': outerModel});
                  } else {
                    getSizeList.add({'coat': OuterModel()});
                  }
                }
              }
              break;
          }
        }
      }
      getSizeList.refresh();

      printInfo(
          info:
              '=============== get size success ==============${getSizeList.length}');
    } catch (e) {
      printInfo(info: '=============== get size failed ==============\n $e');
    }
  }

  /// banner 가져오기
  Future getBanner() async {
    banners.clear();

    try {
      /// url : 'https://needlecrew.com/wp-json/wp/v2/app_banner'
      var response = await http.get(
        Uri.https(baseUrl, wpBase + '/app_banner'),
      );

      printInfo(info: 'get banner this ${response.body}');

      var getBanners = jsonDecode(response.body);
      for (Map item in getBanners) {
        printInfo(info: 'item this $item');
        var getImage = await http.get(
            Uri.https(baseUrl, wpBase + '/media/${item['featured_media']}'));
        printInfo(info: 'get image this ${getImage.body}');
        var image = jsonDecode(getImage.body);
        printInfo(info: 'get image info $image');
        if (banners.isNotEmpty) {
          if (banners.indexWhere((element) => element.id == item['id']) == -1) {
            banners.add(BannerItem(
                id: item['id'].toString(),
                imageId: image['id'].toString(),
                title: item['title']['rendered'],
                imgUrl: image['guid']['rendered']));
          }
        } else {
          banners.add(BannerItem(
              id: item['id'].toString(),
              imageId: image['id'].toString(),
              title: item['title']['rendered'],
              imgUrl: image['guid']['rendered']));
        }
      }
      banners.refresh();
      printInfo(info: 'get banner success ===========${banners.length}');

      return true;
    } catch (e) {
      printInfo(
          info: '================ get banner failed ================= \n$e');

      return false;
    }
  }

  /// 공지사항 가져오기
  Future getAnnouncement() async {
    try {
      var response = await http.get(
        Uri.https(baseUrl, wpBase + '/announcement_info'),
      );

      printInfo(info: 'get announcement this ${response.body}');

      var getAnnouncements = jsonDecode(response.body);

      for (Map item in getAnnouncements) {
        var getImage = await http.get(
            Uri.https(baseUrl, wpBase + '/media/${item['featured_media']}'));
        printInfo(info: 'get image this ${getImage.body}');
        var image = jsonDecode(getImage.body);
        printInfo(info: 'get image info $image');

        if (announcements.isNotEmpty) {
          if (announcements.indexWhere((element) => element.id == item['id']) ==
              -1) {
            announcements.add(AnnouncementItem(
                id: item['id'].toString(),
                title: item['title']['rendered'],
                content: item['content']['rendered'],
                imgUrl: '',
                createdAt: item['title']['modified']));
          }
        } else {
          announcements.add(
            AnnouncementItem(
              id: item['id'].toString(),
              title: item['title']['rendered'],
              content: item['content']['rendered'],
              imgUrl: '',
              createdAt: DateTime.parse(item['date']),
            ),
          );
        }
      }
      announcements.refresh();
      printInfo(
          info: 'get announcement success ===========${announcements.length}');
    } catch (e) {
      printInfo(
          info: '=============== get announcement failed ============== \n $e');
    }
  }

  /// 가격표 가져오기
  Future getPriceInfoCategories() async {
    try {
      List<WooProductCategory> categories = await wp_api.wooCommerceApi
          .getProductCategories(parent: 0, order: 'desc');

      for (int i = 0; i < categories.length; i++) {
        priceCategories.add(
            {'id': categories[i].id.toString(), 'name': categories[i].name});
      }
      log('get price info categories success');
      return true;
    } catch (e) {
      log('get price info categories failed  --------------- $e');
      return false;
    }
  }

  /// 주문건 가져오기
  Future getOrderAll() async {
    try {
      log('get order all init user id ${homeInitService.user.value.value?.id}');
      if (homeInitService.user.value.value?.id != null) {
        log('0. get order all init user id ${homeInitService.user.value.value?.id}');
        var orders = await wp_api.wooCommerceApi.getOrders(
          customer: homeInitService.user.value.value?.id,
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

        if (orders.isNotEmpty) {
          if (getOrders.isNotEmpty) {
            for (Map item in getOrders) {
              if (orders.indexWhere(
                      (element) => element.id == item['order_id']) ==
                  -1) {
                log('order delete=======');
                getOrders.remove(item);
              }
            }
          }
          for (int i = 0; i < orders.length; i++) {
            Map orderDate = FormatMethod().convertedUseInfoDate(
                'yyyy. MM. dd', orders[i].dateCreated.toString());
            Map statusDate = FormatMethod().convertedUseInfoDate(
                'MM/dd hh:mm', orders[i].dateModifiedGmt.toString());

            var orderMetaData = orders[i].metaData ?? [];

            if (orderMetaData.isNotEmpty) {
              var setOrders = [];
              var customerInfo;
              var payInfo;

              log('. set order this ${orderMetaData.length}');
              for (int i = 0; i < orderMetaData.length; i++) {
                log('...... set order this ${orderMetaData[i].key} ${orderMetaData[i].value} ${orderMetaData[i].value.runtimeType}');
                if (orderMetaData[i].key!.contains('상품')) {
                  log('0. get order item this ${orderMetaData[i].value.runtimeType} ${OrderMetaData.fromJson(jsonDecode(orderMetaData[i].value))}');
                  var changeOrderItem = OrderMetaData.fromJson(
                      jsonDecode(orderMetaData[i].value));
                  setOrders.add(changeOrderItem);
                  log('1. set order this ${setOrders.length}');
                }
                if (orderMetaData[i].key == '수령인정보') {
                  if (orderMetaData[i].value.runtimeType == String) {
                    customerInfo = jsonDecode(orderMetaData[i].value);
                  } else {
                    customerInfo = orderMetaData[i].value;
                  }
                }
                if (orderMetaData[i].key == '결제정보') {
                  if (orderMetaData[i].value.runtimeType == String) {
                    payInfo = jsonDecode(orderMetaData[i].value);
                  } else {
                    payInfo = orderMetaData[i].value;
                  }
                }
              }
              log('2. set order this ${setOrders.length}');
              if (getOrders.isNotEmpty) {
                log('0. has order!!!!!');
                if (getOrders.indexWhere(
                        (element) => element['order_id'] == orders[i].id) !=
                    -1) {
                  // 주문 목록이 비어있지 않고, 해당 주문이 있을 경우
                  log('0. has order');
                  getOrders[getOrders.indexWhere(
                          (element) => element['order_id'] == orders[i].id)]
                      .update('orders', (value) => setOrders);
                  // ['orders'] = setOrders;
                  log('0. has order ddddd${getOrders[getOrders.indexWhere((element) => element['order_id'] == orders[i].id)]['orders'].first.cartProductName}');
                } else {
                  log('0. has order');
                  getOrders.add({
                    'order_info': orders[i],
                    'order_date': '${orderDate['date']} ${orderDate['day']}',
                    'order_id': orders[i].id,
                    'order_status': orders[i].status,
                    'customer_info': customerInfo,
                    'pay_info': payInfo,
                    'orders': setOrders
                  });
                  log('1. has order${getOrders.length}');
                }
              } else {
                // 해당 주문이 없을 경우
                log('0. order empty');
                getOrders.add({
                  'order_info': orders[i],
                  'order_date': '${orderDate['date']} ${orderDate['day']}',
                  'order_id': orders[i].id,
                  'order_status': orders[i].status,
                  'customer_info': customerInfo,
                  'pay_info': payInfo,
                  'orders': setOrders
                });
                log('1. order empty ${getOrders.length}');
              }
            }
          }
          getOrders.refresh();
        }
      }
      log('get order all list this $getOrders');
      return true;
    } catch (e) {
      print("get all order isError " + e.toString());
      return false;
    }
  }
}
