import 'package:saka/data/models/feed/feednumvalues.dart';

enum Charset { utf8, charsetUtf8 }

final charsetValues = EnumValues({
  "UTF_8": Charset.charsetUtf8,
  "UTF-8": Charset.utf8
});