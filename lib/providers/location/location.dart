import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:saka/utils/helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/maps/google_maps_place_picker.dart';

class LocationProvider extends ChangeNotifier {
  final SharedPreferences sp;
  LocationProvider({
    required this.sp
  });

  Future<void> getCurrentPosition({required double latitude, required double longitude}) async {
    try {
      sp.setDouble("lat", latitude);
      sp.setDouble("lng", longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude
      );
      Placemark place = placemarks[0];
      sp.setString("currentNameAddress", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
      sp.setString("membernearAddress", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    } 
  }

  Future<void> updateCurrentPosition(BuildContext context, PickResult position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry!.location.lat, position.geometry!.location.lng);
      Placemark place = placemarks[0]; 
      sp.setDouble("lat", position.geometry!.location.lat);
      sp.setDouble("lng", position.geometry!.location.lng);
      sp.setString("currentNameAddress","${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
      sp.setString("membernearAddress", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  String get getCurrentNameAddress => sp.getString("currentNameAddress") ?? "Location no Selected"; 

  double get getCurrentLat => double.parse(Helper.prefs!.getString("lat") ?? '0.0');
  
  double get getCurrentLng => double.parse(Helper.prefs!.getString("lng") ?? '0.0') ;
}
