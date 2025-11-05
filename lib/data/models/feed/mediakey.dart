class MediaKey {
  MediaKey({
    required this.code,
    required this.message,
    required this.body,
  });

  int code;
  String message;
  String body;

  factory MediaKey.fromJson(Map<String, dynamic> json) => MediaKey(
    code: json["code"],
    message: json["message"],
    body: json["body"],
  );
}
