import 'dart:collection';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/event/event.dart';

import 'package:saka/data/models/event/event.dart';
import 'package:saka/data/models/event/event_search.dart';

enum EventStatus { idle, loading, loaded, error, empty }
enum EventCheckStatus { idle, loading, loaded, error, empty }
enum EventJoinStatus { idle, loading, loaded, error, empty }
enum EventSearchStatus { idle, loading, loaded, error, empty }

class DateRangeModel {
  DateTime startDate;
  DateTime endDate;
  List<Map<String, dynamic>> dataArray;

  DateRangeModel({required this.startDate, required this.endDate, required this.dataArray});
}

Map<DateTime, List<Map<String, dynamic>>> groupDataByDate(List<DateRangeModel> data) {
  Map<DateTime, List<Map<String, dynamic>>> groupedData = {};

  for (var dateModel in data) {
    DateTime currentDate = dateModel.startDate;

    while (currentDate.isBefore(dateModel.endDate) || currentDate.isAtSameMomentAs(dateModel.endDate)) {
      groupedData.putIfAbsent(currentDate, () => []);
      groupedData[currentDate]!.addAll(dateModel.dataArray);
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  return groupedData;
}

 
class EventProvider with ChangeNotifier {
  final AuthRepo ar;
  final SharedPreferences sp;
  final EventRepo er;

  EventProvider({
    required this.ar,
    required this.er,
    required this.sp
  });

  bool checkEventExist = true;

  DateTime selectedDate = DateTime.now();

  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  Map<DateTime, List<Map<String, dynamic>>> get events => {..._events};

  Map<DateTime, List> createEvent = HashMap();

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  EventCheckStatus _eventCheckStatus = EventCheckStatus.loading;
  EventCheckStatus get eventCheckStatus => _eventCheckStatus;

  EventSearchStatus _eventSearchStatus = EventSearchStatus.idle;
  EventSearchStatus get eventSearchStatus => _eventSearchStatus;

  EventJoinStatus _eventJoinStatus = EventJoinStatus.idle;
  EventJoinStatus get eventJoinStatus => _eventJoinStatus;

  List<DateRangeModel> _data = [];
  List<DateRangeModel> get data => [..._data];
  
  List<EventData> _eventData = [];
  List<EventData> get eventData => [..._eventData];

  List<Map<String, dynamic>> _selectedEvents = [];
  List<Map<String, dynamic>> get selectedEvents => [..._selectedEvents];

  List<EventSearchData> _eventSearchData = [];
  List<EventSearchData> get eventSearchData => [..._eventSearchData];

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventJoinStatus(EventJoinStatus eventJoinStatus) {
    _eventJoinStatus = eventJoinStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventSearchStatus(EventSearchStatus eventSearchStatus) {
    _eventSearchStatus = _eventSearchStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventCheckStatus(EventCheckStatus eventCheckStatus) {
    _eventCheckStatus = eventCheckStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void updateSelectedDate(DateTime selectedDateParam) {
    selectedDate = selectedDateParam;

    notifyListeners();
  }

  void addSelectedEvents(List<Map<String, dynamic>> events) {
    _selectedEvents = events;

    notifyListeners();
  }

  Future<void> getEvent() async {
    setStateEventStatus(EventStatus.loading);

    try {
      List<EventData>? eventData = await er.getEvent();

      _data = [];
      
      _eventData = [];
      _eventData.addAll(eventData);

      setStateEventStatus(EventStatus.loaded);

      for (EventData ed in eventData) {  
        _data.add(DateRangeModel(
          startDate: DateTime(ed.startDate.year, ed.startDate.month, ed.startDate.day),
          endDate: DateTime(ed.endDate.year, ed.endDate.month,  ed.endDate.day),
          dataArray: [{
            "id": ed.eventId,
            "name": ed.summary,
            "content": ed.description,
            "join": ed.join,
            "joins": ed.joins,
            "attachment": ed.path,
            "createdAt": ed.created,
            "memberName": ed.createdBy,
          }]
        ));

      }

      Map<DateTime, List<Map<String, dynamic>>> groupedData = groupDataByDate(data);

      groupedData.forEach((date, dataArray) {
        _events[date] = dataArray;
      });

      if(groupedData.isNotEmpty) {
        for (var el in groupedData.entries) {
          if(DateFormat('dd/MM/yyyy').format(el.key) == DateFormat('dd/MM/yyyy').format(DateTime.now())) {
            _selectedEvents = el.value;
          }
        }
      }

      setStateEventStatus(EventStatus.loaded);

    } catch(e) {
      print(e);
    }
  }

  Future<void> getEventSearch(BuildContext context, {required String query}) async {
    try {
      setStateEventSearchStatus(EventSearchStatus.loading);
      List<EventSearchData>? eventSearchData = await er.getEventSearchData(context, query);
      _eventSearchData = eventSearchData!;
      setStateEventSearchStatus(EventSearchStatus.loaded);
      if(_eventSearchData.isEmpty) {
        setStateEventSearchStatus(EventSearchStatus.empty);
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEventSearchStatus(EventSearchStatus.error);
    }
  }

  Future<void> checkEvent(BuildContext context) async {
    setStateEventCheckStatus(EventCheckStatus.loading);
    try {
      bool? isEventExist = await er.checkEvent(context);
      checkEventExist = isEventExist!;
      setStateEventCheckStatus(EventCheckStatus.loaded);   
    } catch(e, stacktrace) {
      checkEventExist = true;
      debugPrint(stacktrace.toString());  
      setStateEventCheckStatus(EventCheckStatus.loaded);   
    }
  } 

  Future<void> joinEvent({required int eventId}) async {
    setStateEventJoinStatus(EventJoinStatus.loading);
    try {
      await er.joinEvent(eventId: eventId);
      await getEvent();
      setStateEventJoinStatus(EventJoinStatus.loaded);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEventJoinStatus(EventJoinStatus.error);
    }
  } 

}