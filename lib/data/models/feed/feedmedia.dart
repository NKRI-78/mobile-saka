import 'feedposttype.dart';

class FeedMedia {
  FeedMedia({
    this.originalName,
    this.fileLength,
    this.path,
    this.contentType,
    this.kind
  });

  String? originalName;
  int? fileLength;
  String? path;
  String? contentType;
  PostType? kind;

  factory FeedMedia.fromJson(Map<String, dynamic> json) => FeedMedia(
    originalName: json["originalName"],
    fileLength: json["fileLength"],
    path: json["path"],
    contentType: json["contentType"],
    kind: postTypeValues.map[json["kind"]],
  );
}