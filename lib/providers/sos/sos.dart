import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:saka/data/models/sos/sos.dart';

import 'package:saka/data/repository/auth/auth.dart';
import 'package:saka/data/repository/sos/sos.dart';

import 'package:saka/providers/location/location.dart';
 
import 'package:saka/utils/constant.dart';
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
    sosStatus = sosStatus;
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
  }) async {
    setStateSosStatus(SosStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrl}/data/sos", data: {
        "userId": ar.getUserId(),
        "geoPosition": "${lp.getCurrentLat}, ${lp.getCurrentLng}",
        "address": lp.getCurrentNameAddress,
        "sosType": "sos.${label.toLowerCase()}",
        "Message": "$content ${lp.getCurrentNameAddress.replaceAll("\n", " ")}",
        "sender": ar.getUserfullname(),
        "phoneNumber": ar.getUserPhoneNumber()
      });
      Navigator.of(context).pop();
      setStateSosStatus(SosStatus.loaded);
    } on DioError catch(_) {
      Navigator.of(context).pop();
      setStateSosStatus(SosStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      Navigator.of(context).pop();
      setStateSosStatus(SosStatus.error);
    }
  }

}
