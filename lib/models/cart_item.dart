class CartItem {
  final int categoryId; // parent ID
  late final int cartId; // 고유 ID
  late final int productId; // 고유 ID
  late final String cartProductName;
  late final String cartCategory; // 상위 카테고리 명
  final List cartImages; // cart Image
  final int cartCount;
  final String cartWay;
  final String cartSize; // 치수
  final String cartContent;
  final String guaranteePrice; // 물품가액
  final String productPrice; // 상품가격


  CartItem(this.categoryId, this.cartId, this.productId, this.cartProductName, this.cartCount, this.cartCategory, this.cartImages, this.cartWay, this.cartSize,
      this.cartContent, this.guaranteePrice, this.productPrice);
}
