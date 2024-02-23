import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/models/inbox/count.dart';
import 'package:saka/data/models/inbox/inbox.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class InboxRepo {
  final SharedPreferences sharedPreferences;
  InboxRepo({
    required this.sharedPreferences
  });

  Future<List<InboxData>> getInbox(BuildContext context, {required String type}) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/data/inbox?type=$type");
      Map<String, dynamic> data = res.data;
      return compute(parseInbox, data);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }

  Future<int> countInbox(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrl}/data/inbox-count");
      Map<String, dynamic> data = res.data;
      return compute(parseInboxCount, data);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }     
    return 0;
  }

  Future<void> updateInbox(BuildContext context, {required String inboxId}) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.put("${AppConstants.baseUrl}/data/inbox/$inboxId",
        data: {
          "read": true
        }
      );
    } on DioError catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}

int parseInboxCount(dynamic data) {
  InboxCountModel inboxModel = InboxCountModel.fromJson(data);
  return inboxModel.data!.count;
}

List<InboxData> parseInbox(dynamic data) {
  InboxModel inboxModel = InboxModel.fromJson(data);
  List<InboxData> inboxData = inboxModel.data!;
  return inboxData;
}