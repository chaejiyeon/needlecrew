// media upload 정보 가져오기
class MediaUploadInfo {
  final dynamic imageId;
  final dynamic guid;

  MediaUploadInfo({required this.imageId, required this.guid});

  factory MediaUploadInfo.fromJson(Map json) {
    return MediaUploadInfo(
      imageId: json["id"],
      guid: json["guid"],
    );
  }
}

class GuidInfo {
  final dynamic rendered;

  GuidInfo({required this.rendered});

  factory GuidInfo.fromJson(Map json) {
    return GuidInfo(
      rendered: json["rendered"],
    );
  }
}
