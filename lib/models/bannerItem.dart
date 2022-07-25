class bannerItem{
  late String img;
  late String text1;
  late String text2;
  late String btnText;

  bannerItem(this.img, this.text1, this.text2, this.btnText);
}


List<bannerItem> banners= [
  bannerItem('assets/images/bannerImage.png', '쇼핑몰에서도?', '우리집에서도? 어디서든!', '수선하기'),
  bannerItem('assets/images/bannerImage.png', '종류에 상관없이', '어떤 옷이든 맡겨보세요', '수선하기'),
  bannerItem('assets/images/bannerImage.png', '믿고 맡길 수 있는', '니들크루의 전문 수선사', '수선하기'),
  bannerItem('assets/images/bannerImage.png', '믿고 맡길 수 있는', '니들크루의 전문 수선사', '수선하기'),
];