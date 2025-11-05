import 'dart:io';

import 'package:flutter/cupertino.dart';

class ProductTransactionModel {
  int status;
  bool error;
  String message;
  List<ProductTransactionData> data;

  ProductTransactionModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory ProductTransactionModel.fromJson(Map<String, dynamic> json) => ProductTransactionModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<ProductTransactionData>.from(json["data"].map((x) => ProductTransactionData.fromJson(x))),
  );
}

class ProductTransactionData {
  String id;
  String title;
  List<Media> medias;
  String caption;
  bool isReviewed;
  double rating;
  List<File> befores;
  List<File> files;
  TextEditingController reviewC;

  ProductTransactionData({
    required this.id,
    required this.title,
    required this.medias,
    required this.caption,
    required this.isReviewed,
    required this.rating,
    required this.befores,
    required this.files,
    required this.reviewC
  });

  factory ProductTransactionData.fromJson(Map<String, dynamic> json) => ProductTransactionData(
    id: json["id"],
    title: json["title"],
    medias: List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
    caption: json["caption"],
    isReviewed: json["is_reviewed"],
    rating: 0.0,
    befores: [],
    files: [],
    reviewC: TextEditingController(text: "")
  );
}

class Media {
  int id;
  String path;

  Media({
    required this.id,
    required this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    path: json["path"],
  );
}