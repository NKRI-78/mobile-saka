import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/news/news.dart';
import 'package:saka/data/models/news/single.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

enum GetNewsStatus { loading, loaded, error, empty }
enum GetNewsSingleStatus { loading, loaded, error, empty }

class NewsProvider with ChangeNotifier {

  GetNewsStatus _getNewsStatus = GetNewsStatus.loading;
  GetNewsStatus get getNewsStatus => _getNewsStatus;

  GetNewsSingleStatus _getNewsSingleStatus = GetNewsSingleStatus.loading;
  GetNewsSingleStatus get getNewsSingleStatus => _getNewsSingleStatus;

  List<NewsData> _newsData = [];
  List<NewsData> get newsData => [..._newsData];

  List<SingleNewsData> _singleNewsData = [];
  List<SingleNewsData> get singleNewsData => [..._singleNewsData];

  void setStateGetNewsStatus(GetNewsStatus getNewsStatus) {
    _getNewsStatus = getNewsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateGetSingleNewsStatus(GetNewsSingleStatus getNewsSingleStatus) {
    _getNewsSingleStatus = getNewsSingleStatus;
    notifyListeners();
  }

  Future<void> getNews(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/content-service/article");
      Map<String, dynamic> data = json.decode(res.data);
      NewsModel newsModel = NewsModel.fromJson(data);
      List<NewsData> n = newsModel.data!;
      List<NewsData> nAssign = [];
      for (int i = 0; i < n.length; i++) {
        nAssign.add(NewsData(
          articleId: n[i].articleId,
          content: n[i].content,
          created: n[i].created,
          createdBy: n[i].createdBy,
          highlight: n[i].highlight,
          media: n[i].media,
          picture: n[i].picture,
          status: n[i].status,
          title: n[i].title,
          type: n[i].type,
          updated: n[i].updated
        )); 
      }
      _newsData = nAssign;
      setStateGetNewsStatus(GetNewsStatus.loaded);
      if(newsData.isEmpty) {
        setStateGetNewsStatus(GetNewsStatus.empty);
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateGetNewsStatus(GetNewsStatus.error);
    }
  }

  Future<void> getNewsSingle(BuildContext context, String contentId) async {
    try { 
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/content-service/article/$contentId");
      Map<String, dynamic> data = json.decode(res.data);
      SingleNewsModel singleNewsModel = SingleNewsModel.fromJson(data);
      _singleNewsData = [];
      _singleNewsData.addAll(singleNewsModel.body);
      setStateGetSingleNewsStatus(GetNewsSingleStatus.loaded);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateGetSingleNewsStatus(GetNewsSingleStatus.error);
    }
  }

}