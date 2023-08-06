import 'package:needlecrew/format_method.dart';

class CartItem {
  final int categoryId; // parent ID
  late final int cartId; // 고유 ID
  late final int productId; // 고유 ID
  late final int variationId; // 고유 ID
  late final String cartProductName;
  late final String cartCategory; // 상위 카테고리 명
  final List cartImages; // cart Image
  final int cartCount;
  final String cartWay;
  final String cartSize; // 치수
  final String cartContent;
  final String guaranteePrice; // 물품가액
  final String productPrice; // 상품가격

  CartItem(
      this.categoryId,
      this.cartId,
      this.productId,
      this.variationId,
      this.cartProductName,
      this.cartCount,
      this.cartCategory,
      this.cartImages,
      this.cartWay,
      this.cartSize,
      this.cartContent,
      this.guaranteePrice,
      this.productPrice);
}

class OrderMetaData {
  late int? orderId; // 고유 ID
  late String? cartId; // 장바구니 아이템 Id
  late int? productId; // 고유 ID
  late int? variationId; // 고유 ID
  late String? addOption; // 추가 옵션
  late String? cartProductName;
  late String? cartCategoryName;
  late List? cartImages; // cart Image
  late int? cartCount; // 상품개수
  late String? cartWay; // 의뢰방법
  late String? cartSize; // 치수
  late String? cartContent; // 추가설명
  late String? guaranteePrice; // 물품가액
  late String? productPrice; // 상품가격
  late Map?
      changeInfo; // 추가 금액 및 수선 가능 여부 확인 {'수선 가능여부' : true, '수선 불가 사유' : '', '추가 금액' : 0}

  OrderMetaData(
      {this.orderId,
      this.cartId,
      this.productId,
      this.variationId,
      this.addOption,
      this.cartProductName,
      this.cartCategoryName,
      this.cartCount,
      this.cartImages,
      this.cartWay,
      this.cartSize,
      this.cartContent,
      this.guaranteePrice,
      this.productPrice,
      this.changeInfo = const {
        '수선 가능여부': true,
        '수선 불가 사유': '',
        '추가 금액': 0,
        '추가 사유': ''
      }});

  factory OrderMetaData.fromJson(Map json) {
    return OrderMetaData(
        cartId: json['장바구니아이디'],
        productId: json['상품아이디'] ?? -1,
        cartProductName: json['상품명'] ?? '',
        cartCategoryName: json['카테고리'] ?? '기타',
        variationId: json['추가옵션'] ?? -1,
        addOption: json['옵션'] ?? '',
        cartCount: json['상품개수'] ?? 0,
        cartImages: json['사진'] ?? [],
        cartWay: json['의뢰방법'] ?? '',
        cartSize: json['치수'] ?? 0,
        cartContent: json['추가설명'] ?? '',
        guaranteePrice: json['물품가액'] ?? 0,
        productPrice: json['상품가격'] ?? 0,
        changeInfo: json['변경사항'] ??
            {'수선 가능여부': true, '수선 불가 사유': '', '추가 금액': 0, '추가 사유': ''});
  }

  toMap() {
    return {
      '장바구니아이디': cartId,
      '상품아이디': productId,
      '상품가격': productPrice,
      '상품개수': cartCount,
      '상품명': cartProductName,
      '카테고리': cartCategoryName,
      '추가옵션': variationId,
      '옵션': addOption,
      '사진': cartImages,
      '의뢰방법': cartWay,
      '치수': cartSize,
      '추가설명': cartContent,
      '물품가액': guaranteePrice,
      '변경사항': changeInfo
    };
  }
}
