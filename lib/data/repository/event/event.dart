import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saka/data/models/event/event_search.dart';
import 'package:saka/services/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:saka/data/repository/auth/auth.dart';

import 'package:saka/data/models/event/event.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';

class EventRepo {
  final AuthRepo ar;
  final SharedPreferences sp;
  EventRepo({required this.ar, required this.sp});

  bool isCheckEvent = true;

  List<EventData> _eventData = [];
  List<EventData> get eventData => [..._eventData];

  List<EventSearchData> _eventSearchData = [];
  List<EventSearchData> get eventSearchData => [..._eventSearchData];

  Future<List<EventData>> getEvent() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("${AppConstants.baseUrl}/content-service/event");

      final dynamic raw = response.data;
      final Map<String, dynamic> data = raw is Map<String, dynamic>
          ? raw
          : raw is String
              ? json.decode(raw)
              : <String, dynamic>{};

      final List<dynamic> body = (data["body"] as List?) ?? <dynamic>[];

      return body.map((item) {
        final map = item as Map<String, dynamic>;

        return EventData(
          eventId: map["event_id"] ?? 0,
          description: map["description"]?.toString() ?? "",
          startDate: DateTime.tryParse(map["start_date"]?.toString() ?? "") ?? DateTime.now(),
          endDate: DateTime.tryParse(map["end_date"]?.toString() ?? "") ?? DateTime.now(),
          status: (map["status"] == true) ? 1 : 0,
          location: map["location"]?.toString() ?? "",
          start: map["start"]?.toString() ?? "",
          end: map["end"]?.toString() ?? "",
          summary: map["summary"]?.toString() ?? "",
          path: map["path"]?.toString() ?? "",
          shareNews: (map["share_news"] == true) ? 1 : 0,
          createdBy: map["created_by"]?.toString() ?? "",
          created: DateTime.tryParse(map["created"]?.toString() ?? "") ?? DateTime.now(),
          updated: DateTime.tryParse(map["updated"]?.toString() ?? "") ?? DateTime.now(),
          joins: <Join>[],
          join: false,
        );
      }).toList();
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar("Gagal memuat data kegiatan", "", ColorResources.error);
    }
    return [];
  }

  Future<List<EventSearchData>?> getEventSearchData(BuildContext context, String query) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.get(
        "${AppConstants.baseUrl}/content-service/event/search?event=$query",
      );
      Map<String, dynamic> data = json.decode(res.data);
      EventSearchModel eventSearchModel = EventSearchModel.fromJson(data);
      List<EventSearchData> esd = eventSearchModel.data!;
      _eventSearchData = esd;
      return eventSearchData;
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }

  Future<void> joinEvent({required int eventId}) async {
    try {
      Dio dio = await DioManager.shared.getClient();

      await dio.post(
        "${AppConstants.baseUrl}/content-service/event-join/add",
        data: {"event_id": eventId, "user_id": ar.getUserId()},
      );
      ShowSnackbar.snackbar("Anda berhasil gabung", "", ColorResources.success);
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        ShowSnackbar.snackbar("Anda sudah bergabung", "", ColorResources.error);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<bool?> checkEvent(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response res = await dio.get("${AppConstants.baseUrl}/content-service/scanner-joins/check");
      if (json.decode(res.data)["code"] == 0) {
        isCheckEvent = false;
      } else {
        isCheckEvent = true;
      }
      return isCheckEvent;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        isCheckEvent = true;
      } else {
        isCheckEvent = false;
      }
      return isCheckEvent;
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return isCheckEvent;
  }

  Future<void> presentEvent(BuildContext context, {required String eventId}) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      await dio.post(
        "${AppConstants.baseUrl}/content-service/event/present",
        data: {"event_id": eventId, "user_id": ar.getUserId()},
      );
      ShowSnackbar.snackbar("Anda berhasil hadir", "", ColorResources.success);
      NS.pop();
    } on DioError catch (_) {
      NS.pop();
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }
}

List<EventData> parseEvent(dynamic data) {
  EventModel eventModel = EventModel.fromJson(data);
  return eventModel.data;
}
