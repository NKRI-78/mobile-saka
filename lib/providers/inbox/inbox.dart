import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/inbox/inbox.dart';
import 'package:saka/data/repository/inbox/inbox.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

enum InboxStatus { loading, loaded, error, empty}

class InboxProvider with ChangeNotifier {
  int readCount = 0;

  InboxStatus _inboxStatus = InboxStatus.loading;
  InboxStatus get inboxStatus => _inboxStatus;

  List<InboxData> _inboxes = [];
  List<InboxData> get inboxes => [..._inboxes];

  void setStateInboxStatus(InboxStatus inboxStatus) {
    _inboxStatus = inboxStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getInbox(BuildContext context, String type) async {
    setStateInboxStatus(InboxStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/data/inbox?type=$type");
      Map<String, dynamic> data = json.decode(res.data);
      _inboxes = [];
      InboxModel inboxModel = InboxModel.fromJson(json.decode(res.data));
      _inboxes.addAll(inboxModel.data!);
      readCount = inboxModel.data!.where((el) => el.read == false).length;
      setStateInboxStatus(InboxStatus.loaded);
      if(_inboxes.length == 0) {
        setStateInboxStatus(InboxStatus.empty);
      }
      return compute(parseInbox, data);
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 
      || e.response!.statusCode == 401 
      || e.response!.statusCode == 402
      || e.response!.statusCode == 403
      || e.response!.statusCode == 404 
      || e.response!.statusCode == 500 
      || e.response!.statusCode == 502) {
        ShowSnackbar.snackbar(context,"(${e.response!.statusCode}) Internal Server Error (${e.response!.data})", "", ColorResources.error);
      }
      setStateInboxStatus(InboxStatus.error);
    } catch(e) {
      print(e);
      setStateInboxStatus(InboxStatus.error);
    }
  }

  Future<void> updateInbox(BuildContext context, String inboxId, String type) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.put("${AppConstants.baseUrl}/data/inbox/$inboxId", data: {
        "read": true
      });
      Future.delayed(Duration.zero, () {
        getInbox(context, type);
      });
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 
      || e.response!.statusCode == 401 
      || e.response!.statusCode == 402
      || e.response!.statusCode == 403
      || e.response!.statusCode == 404 
      || e.response!.statusCode == 500 
      || e.response!.statusCode == 502) {
        ShowSnackbar.snackbar(context,"(${e.response!.statusCode}) Internal Server Error (${e.response!.data})", "", ColorResources.error);
      }
    } catch(e) {
      print(e);
    }
  }

}