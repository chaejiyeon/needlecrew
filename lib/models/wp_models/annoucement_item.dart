class AnnouncementItem {
  final String id;
  final String title;
  final String content;
  final String imgUrl;
  final DateTime createdAt;

  AnnouncementItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.imgUrl,
      required this.createdAt});
}
