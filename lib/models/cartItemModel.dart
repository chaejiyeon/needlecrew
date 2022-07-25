class CartItem {
  late final String cartProductName; // 상위 카테고리 명
  late final List cartCategory; // 상위 카테고리 명
  final List cartImages; // cart Image
  final int cartCount;
  final String cartWay;
  final String cartSize;
  final String cartContent;
  final String guaranteePrice;
  final String productPrice;

  CartItem(this.cartProductName, this.cartCount, this.cartCategory, this.cartImages, this.cartWay, this.cartSize,
      this.cartContent, this.guaranteePrice, this.productPrice);
}
