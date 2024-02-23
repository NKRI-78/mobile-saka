import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saka/providers/location/location.dart';
import 'package:saka/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/repository/membernear/membernear.dart';
import 'package:saka/data/models/nearme/nearme.dart';

import 'package:saka/maps/google_maps_place_picker.dart';

enum MembernearStatus { loading, loaded, empty, error }

class MembernearProvider with ChangeNotifier {
  final SharedPreferences sp;
  final MembernearRepo mr;
  final LocationProvider lp;
  MembernearProvider({ 
    required this.sp,
    required this.mr, 
    required this.lp
  });

  late GoogleMapController googleMapC;

  List<Marker> _markers = [];
  List<Marker> get markers => [..._markers];

  List<MembernearData> _membernearData = [];
  List<MembernearData> get membernearData => [..._membernearData];

  MembernearStatus _membernearStatus = MembernearStatus.loading;
  MembernearStatus get membernearStatus => _membernearStatus;

  void setStateMembernearStatus(MembernearStatus membernearStatus) {
    _membernearStatus = membernearStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  Future<void> getMembernear(BuildContext context) async {
    setStateMembernearStatus(MembernearStatus.loading);
    try { 
   
      List<MembernearData> md = await mr.membernear(context);
      _membernearData = [];
      _membernearData.addAll(md);
      setStateMembernearStatus(MembernearStatus.loaded);
       _markers.add(
        Marker(
          markerId: MarkerId("currentPosition"),
          position: LatLng(
            double.tryParse(Helper.prefs!.getString('lat').toString()) ?? 0.0, 
            double.tryParse(Helper.prefs!.getString('lng').toString()) ?? 0.0
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
      );
      if(membernearData.isEmpty) {
        setStateMembernearStatus(MembernearStatus.empty);
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateMembernearStatus(MembernearStatus.error);
    }
  }

  Future<void> updateMembernear(BuildContext context, PickResult position) async {
    sp.setDouble("lat", position.geometry!.location.lat);
    sp.setDouble("lng", position.geometry!.location.lng);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.geometry!.location.lat, position.geometry!.location.lng);
    Placemark place = placemarks[0]; 
    sp.setString("membernearAddress", "${place.thoroughfare} ${place.subThoroughfare} ${place.locality} ${place.postalCode}");
    googleMapC.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.geometry!.location.lat, position.geometry!.location.lng),
          zoom: 15.0
        )
      )
    );
    getMembernear(context);
  }

  String get membernearAddress => sp.getString("membernearAddress") ?? "Lokasi belum dipilih";
}