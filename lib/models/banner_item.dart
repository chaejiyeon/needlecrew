class BannerItem {
  final String id;
  final String imageId;
  final String title;
  final String imgUrl;

  BannerItem(
      {required this.id,
      required this.imageId,
      required this.title,
      required this.imgUrl});

  factory BannerItem.fromJson(Map json) {
    return BannerItem(
        id: json[''], imageId: json[''], title: json[''], imgUrl: json['']);
  }
}
