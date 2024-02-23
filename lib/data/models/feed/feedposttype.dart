import 'package:saka/data/models/feed/feednumvalues.dart';

enum PostType { text, document, link, image, video, sticker }

final postTypeValues = EnumValues({
  "TEXT": PostType.text,
  "LINK": PostType.link,
  "DOCUMENT": PostType.document,
  "IMAGE": PostType.image,
  "VIDEO": PostType.video,
  "STICKER": PostType.sticker
});