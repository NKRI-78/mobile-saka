import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/inbox/inbox.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

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
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrl}/data/inbox?type=$type");
      InboxModel inboxModel = InboxModel.fromJson(json.decode(res.data));
      _inboxes = [];
      _inboxes.addAll(inboxModel.data!);
      setStateInboxStatus(InboxStatus.loaded);

      readCount = inboxes.where((el) => el.read == false).length;
      
      if(inboxes.length == 0) {
        setStateInboxStatus(InboxStatus.empty);
      }
    } catch(e) {
      debugPrint(e.toString());
      setStateInboxStatus(InboxStatus.error);
    }
  }

  Future<void> updateInbox(BuildContext context, String inboxId, String type) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      await dio.put("${AppConstants.baseUrl}/data/inbox/$inboxId", data: {
        "read": true
      });
      Future.delayed(Duration.zero, () {
        getInbox(context, type);
      });
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}