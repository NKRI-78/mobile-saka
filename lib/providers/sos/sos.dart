import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/sos/sos.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/sos/sos.dart';
import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/location/location.dart';
 
import 'package:saka/utils/dio.dart';

enum SosStatus { idle, loading, loaded, error } 

class SosProvider extends ChangeNotifier {
  final AuthRepo ar;
  final SosRepo sr;
  final LocationProvider lp;

  SosProvider({
    required this.ar,
    required this.sr,
    required this.lp
  });

  SosStatus _sosStatus = SosStatus.idle;
  SosStatus get sosStatus => _sosStatus;

  List<SosModel> _sosList = [];
  List<SosModel> get sosList => [..._sosList];

  void setStateSosStatus(SosStatus sosStatus) {
    _sosStatus = sosStatus;
    
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void initSosList() {
    _sosList = [];

    sr.getSosList().forEach((category) => _sosList.add(category));
    Future.delayed(Duration.zero, () => notifyListeners());    
  }

  Future<void> sendSos(BuildContext context, {
    required String label,
    required String content,
    required String obj
  }) async {
    setStateSosStatus(SosStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient();
      
      String userId = ar.getUserId().toString();
      String fullname = ar.getUserfullname().toString();
      String phone = ar.getUserPhoneNumber().toString();
      String location = lp.getCurrentNameAddress.toString();

      var data = {
        "userId": userId,
        "geoPosition": "${lp.getCurrentLat.toString()}, ${lp.getCurrentLng.toString()}",
        "address": location,
        "sosType": "sos.${label.toLowerCase()}",
        "txt1": "${fullname} sedang membutuhkan bantuan cepat, ${fullname} sedang ${label.toLowerCase() == "ambulance" ? "membutuhkan" : "mengalami"} ${getTranslated(label.toUpperCase(), context)} di ${location}",
        "Message": "${fullname} sedang membutuhkan bantuan cepat, ${fullname} sedang ${label.toLowerCase() == "ambulance" ? "membutuhkan" : "mengalami"} ${getTranslated(label.toUpperCase(), context)} di ${location}",
        "sender": fullname,
        "phoneNumber": phone
      };

      await dio.post("https://api-saka.inovatiftujuh8.com/data/sos", data: data);

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      setStateSosStatus(SosStatus.loaded);
    } on DioError catch(e) {
      debugPrint(e.toString());
      debugPrint(e.response.toString());
      Navigator.of(context).pop();
      setStateSosStatus(SosStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      Navigator.of(context).pop();
      setStateSosStatus(SosStatus.error);
    }
  }

}
