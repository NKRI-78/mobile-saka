// import "package:dio/dio.dart";
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';

// import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

// import 'package:saka/providers/location/location.dart';
// import 'package:saka/providers/profile/profile.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/constant.dart';
// import 'package:saka/utils/dio.dart';
// import 'package:saka/utils/exceptions.dart';

// import 'package:saka/data/models/store/address_single.dart';
// import 'package:saka/data/models/store/region_subdistrict.dart';
// import 'package:saka/data/models/store/address.dart';
// import 'package:saka/data/models/store/region.dart';

// enum GetAddressStatus { loading, loaded, idle, empty, error, }

// class RegionProvider with ChangeNotifier {

//   GetAddressStatus _getAddressStatus = GetAddressStatus.loading;
//   GetAddressStatus get getAddressStatus => _getAddressStatus;

//   List<AddressList> _addressList = [];
//   List<AddressList> get addressList => [..._addressList];

//   void setStateGetAddressStatus(GetAddressStatus getAddressStatus) {
//     _getAddressStatus = getAddressStatus;
//     Future.delayed(Duration.zero, () => notifyListeners());
//   }

//   Future<RegionModel?> getRegion(BuildContext context, String nameType) async {
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.get("${AppConstants.baseUrlEcommerce}/region/$nameType");
//       RegionModel regionModel = RegionModel.fromJson(res.data);
//       return regionModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//         }
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//     }
//     return null;
//   }

//   Future<RegionModel?> getCity(BuildContext context, String idProvince) async {
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.get("${AppConstants.baseUrlEcommerce}/region/city?provinceId=$idProvince");
//       RegionModel regionModel = RegionModel.fromJson(res.data);
//       return regionModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//         }
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//     }
//     return null;
//   }

//   Future<RegionSubdistrictModel?> getSubdistrict(BuildContext context, String idCity) async {
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.get("${AppConstants.baseUrlEcommerce}/region/subdistrict?cityId=$idCity");
//       RegionSubdistrictModel regionSubdistrictModel = RegionSubdistrictModel.fromJson(res.data);
//       return regionSubdistrictModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//         }
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//     }
//     return null;
//   }

//   Future<AddressModel?> getDataAddress(BuildContext context) async {
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/shipping/addresses");
//       AddressModel addressModel = AddressModel.fromJson(res.data);
//       _addressList = [];
//       _addressList.addAll(addressModel.body!);
//       setStateGetAddressStatus(GetAddressStatus.loaded);
//       if(_addressList.isEmpty) {
//         setStateGetAddressStatus(GetAddressStatus.empty);
//       }
//       return addressModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//           setStateGetAddressStatus(GetAddressStatus.error);
//         }
//       setStateGetAddressStatus(GetAddressStatus.error);
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//       setStateGetAddressStatus(GetAddressStatus.error);
//     }
//     return null;
//   }

//   Future<AddressSingleModel?> postDataAddress(
//     BuildContext context,
//     String typeAddress,
//     String address,
//     String province,
//     String city,
//     String subdistrict,
//     String village,
//     String postalCode,
//   ) async {
//     ProgressDialog pr = ProgressDialog(context: context);
//     pr.show(
//       max: 2,
//       msg: "Mohon Tunggu...",
//       elevation: 10.0,
//       borderRadius: 10.0,
//       backgroundColor: ColorResources.white,
//       progressBgColor: ColorResources.primaryOrange
//     );
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.post("${AppConstants.baseUrlEcommerce}/commerce/shipping/add",
//       data: {
//         "name": typeAddress,
//         "phoneNumber": context.read<ProfileProvider>().getUserPhoneNumber,
//         "address": address,
//         "postalCode": postalCode,
//         "province": province,
//         "city": city,
//         "village": village,
//         "subdistrict": subdistrict,
//         "defaultLocation": true,
//         "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLng, Provider.of<LocationProvider>(context, listen: false).getCurrentLat] 
//       });
//       if(res.data["code"] == 411) {
//         throw CustomException(411);
//       }
//       pr.close();
//       ShowSnackbar.snackbar(context, "Alamat berhasil ditambah", "", ColorResources.success);
//       Navigator.of(context).pop();
//       Future.delayed(Duration.zero, () {
//         getDataAddress(context);
//       });
//       final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(res.data);
//       return addressSingleModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//           pr.close();
//         }
//       pr.close();
//     } on CustomException catch(e) {
//       // ignore: unrelated_type_equality_checks
//       if(e == 411) {
//         ShowSnackbar.snackbar(context, "(${e.toString()}) : Internal Server Error", "", ColorResources.error);
//       }
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//       pr.close();
//     }
//     return null;
//   }

//   Future<AddressSingleModel?> postEditDataAddress(
//     BuildContext context,
//     String idAddress,
//     String typeAddress,
//     String address,
//     String province,
//     String city,
//     String subdistrict,
//     String village,
//     String postalCode,
//     bool defaultLocation,
//   ) async {
//     ProgressDialog pr = ProgressDialog(context: context);
//     pr.show(
//       max: 2,
//       msg: "Mohon Tunggu...",
//       backgroundColor: ColorResources.white,
//       progressBgColor: ColorResources.primaryOrange
//     );
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response _res = await dio.post("${AppConstants.baseUrlEcommerce}/commerce/shipping/update",
//       data: {
//         "id": idAddress,
//         "name": typeAddress,
//         "phoneNumber": context.read<ProfileProvider>().getUserPhoneNumber,
//         "address": address,
//         "postalCode": postalCode,
//         "province": province,
//         "city": city,
//         "village": village,
//         "subdistrict": subdistrict,
//         "defaultLocation": defaultLocation,
//         "location": [Provider.of<LocationProvider>(context, listen: false).getCurrentLng, Provider.of<LocationProvider>(context, listen: false).getCurrentLat] 
//       });
//       pr.close();
//       Navigator.of(context).pop();
//       Future.delayed(Duration.zero, () {
//         getDataAddress(context);
//       });
//       ShowSnackbar.snackbar(context, "Alamat berhasil diubah", "", ColorResources.success);
//       final AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(_res.data);
//       return addressSingleModel;
//     } on DioError catch(e) {
//       if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//           pr.close();
//         }
//         pr.close();
//     } catch (e, stacktrace) {
//       debugPrint(stacktrace.toString());
//       pr.close();
//     }
//     return null;
//   }

//   Future<AddressSingleModel?> selectedAddress(BuildContext context, List<AddressList> addressList, int i) async {
//     try {
//       Dio dio = await DioManager.shared.getClient();
//       Response res = await dio.post("${AppConstants.baseUrlEcommerce}/commerce/shipping/update",
//       data: {
//         "id": addressList[i].id, 
//         "defaultLocation": true
//       });
//       Future.delayed(Duration.zero, () {
//         getDataAddress(context);
//       });
//       AddressSingleModel addressSingleModel = AddressSingleModel.fromJson(res.data);
//       return addressSingleModel;
//     } on DioError catch (e) {
//        if(
//         e.response!.statusCode == 401
//         || e.response!.statusCode == 402 
//         || e.response!.statusCode == 403
//         || e.response!.statusCode == 404 
//         || e.response!.statusCode == 405 
//         || e.response!.statusCode == 500 
//         || e.response!.statusCode == 501
//         || e.response!.statusCode == 502
//         || e.response!.statusCode == 503
//         || e.response!.statusCode == 504
//         || e.response!.statusCode == 505
//       ) {
//           ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error (${e.response!.data})", "", ColorResources.error);
//         }
//     } catch(e, stacktrace) {
//       debugPrint(stacktrace.toString());
//     }
//     return null;
//   }
// }
