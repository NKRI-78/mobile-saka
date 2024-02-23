import 'dart:collection';

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

  List _events = [];
  List get events => [..._events];
  Map<DateTime, List> createEvent = HashMap();

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  EventCheckStatus _eventCheckStatus = EventCheckStatus.loading;
  EventCheckStatus get eventCheckStatus => _eventCheckStatus;

  EventSearchStatus _eventSearchStatus = EventSearchStatus.idle;
  EventSearchStatus get eventSearchStatus => _eventSearchStatus;

  EventJoinStatus _eventJoinStatus = EventJoinStatus.idle;
  EventJoinStatus get eventJoinStatus => _eventJoinStatus;
  
  List<EventData> _eventData = [];
  List<EventData> get eventData => [..._eventData];

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

  Future<void> getEvent(BuildContext context) async {
    setStateEventStatus(EventStatus.loading);
    try {
      _eventData = [];
      List<EventData>? eventData = await er.getEvent(context);
      _eventData.addAll(eventData);
      setStateEventStatus(EventStatus.loaded);
      if(eventData.isEmpty) {
        setStateEventStatus(EventStatus.empty);
      }
      // if(eventData.isEmpty) {
      //   setStateEventStatus(EventStatus.empty);
      // } else {
      //   _eventData.addAll(eventData);
      //   setStateEventStatus(EventStatus.loaded);
      //   for (int i = 0; i < _eventData.length; i++) {
      //     createEvent[DateFormat("yyyy-MM-dd").parse(_eventData[i].eventDate.toString())] = [
      //       [{
      //         "event_id": _eventData[i].eventId,
      //         "user_joined": _eventData[i].userJoined,
      //         "description": _eventData[i].description,
      //         "location": _eventData[i].location,
      //         "summary": _eventData[i].summary,
      //         "start": _eventData[i].start,
      //         "end": _eventData[i].end,
      //         "path": _eventData[i].path
      //       }]
      //     ];
      //     DateTime dateNow = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
      //     _events = createEvent[dateNow] ?? [];
      //   }
      // }
      // if(_eventData.isEmpty) {
      //   setStateEventStatus(EventStatus.empty);
      // }
    } catch(e) {
      print(e);
    }
  }

  void changeEvent(BuildContext context, List events) {
    _events = events;
    Future.delayed(Duration.zero, () => notifyListeners());
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

  Future<void> joinEvent(BuildContext context, {required int eventId}) async {
    setStateEventJoinStatus(EventJoinStatus.loading);
    try {
      await er.joinEvent(context, eventId: eventId.toString());
      setStateEventJoinStatus(EventJoinStatus.loaded);   
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEventJoinStatus(EventJoinStatus.error);   
    }
  } 

}