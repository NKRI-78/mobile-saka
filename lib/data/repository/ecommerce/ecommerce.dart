import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:saka/data/models/ecommerce/checkout/list.dart';
import 'package:saka/data/models/ecommerce/courier/courier.dart';
import 'package:saka/data/models/ecommerce/region/subdistrict.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_default.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_detail.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/data/models/ecommerce/region/district.dart';
import 'package:saka/data/models/ecommerce/region/city.dart';
import 'package:saka/data/models/ecommerce/region/province.dart';import 'package:saka/data/models/ecommerce/shipping_address/shipping_address.dart';

import 'package:saka/data/models/ecommerce/cart/cart.dart';
import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/data/models/ecommerce/product/detail.dart';

import 'package:saka/utils/dio.dart';

class EcommerceRepo {
  final SharedPreferences sp;
  
  EcommerceRepo({
    required this.sp
  });

  Future<ProductModel> getAllProduct(String search) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/all?page=1&limit=10&search=${search}&app_name=saka");
      Map<String, dynamic> data = response.data;
      ProductModel productModel = ProductModel.fromJson(data);
      return productModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load products');
    }
  }

  Future<ProductDetailModel> getProduct({required String productId}) async {
    try {   
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/detail/$productId");
      Map<String, dynamic> data = response.data;
      ProductDetailModel productDetailModel = ProductDetailModel.fromJson(data);
      return productDetailModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load product");
    }
  }

  Future<CartModel> getCart() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts",
        data: {
          "user_id": sp.getString("userId")
        }
      );
      Map<String, dynamic> data = response.data;
      CartModel cartModel = CartModel.fromJson(data);
      return cartModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load carts');
    }
  }

  Future<CheckoutListModel> getCheckoutList() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/checkout/list",
        data: {
          "user_id": sp.getString("userId")
        }
      );
      Map<String, dynamic> data = response.data;
      CheckoutListModel checkoutListModel = CheckoutListModel.fromJson(data);
      return checkoutListModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load checkout list');
    }
  }

  Future<CourierListModel> getCourier({
    required String storeId
  }) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/couriers/cost/list",
        data: {
          "store_id": storeId,
          "user_id": sp.getString("userId")
        }
      );
      Map<String, dynamic> data = response.data;
      CourierListModel courierListModel = CourierListModel.fromJson(data);
      return courierListModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load get get courier');
    }
  }

  Future<void> addCourier({
    required String courierCode,
    required String courierService,
    required String courierName,
    required String courierDesc,
    required String costValue,
    required String costNote,
    required String costEtd,
    required String storeId
  }) async {
    try { 
      Dio dio = await DioManager.shared.getClient();

      final data = {
        "courier_code": courierCode,
        "courier_service": courierService,
        "courier_name": courierName,
        "courier_description": courierDesc,
        "cost_value": costValue,
        "cost_note": costNote,
        "cost_etd": costEtd,
        "user_id": sp.getString("userId"),
        "store_id": storeId
      };

      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/couriers/add",
        data: data
      );

    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load add courier');
    }
  } 

  Future<ShippingAddressModel> getShippingAddressList() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address",
        data: {
          "user_id": sp.getString("userId"),
          "default_location": false
        }
      );
      Map<String, dynamic> data = response.data;
      ShippingAddressModel shippingAddressModel = ShippingAddressModel.fromJson(data);
      return shippingAddressModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load shipping address');
    }
  }

  Future<ShippingAddressModelDefault> getShippingAddressDefault() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/default",
        data: {
          "user_id": sp.getString("userId"),
        }
      );
      Map<String, dynamic> data = response.data;
      ShippingAddressModelDefault shippingAddressModelDefault = ShippingAddressModelDefault.fromJson(data);
      return shippingAddressModelDefault;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load shipping address default');
    }
  }

  Future<ShippingAddressModelDetail> getShippingAddressDetail({required String id}) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/$id");
      Map<String, dynamic> data = response.data;
      ShippingAddressModelDetail shippingAddressModelDetail = ShippingAddressModelDetail.fromJson(data);
      return shippingAddressModelDetail;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load shipping address detail');
    }
  }
  
  Future<ProvinceModel> getProvince() async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/province");
      Map<String, dynamic> data = response.data;
      ProvinceModel provinceModel = ProvinceModel.fromJson(data);
      return provinceModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load province");
    }
  }

  Future<CityModel> getCity({required String provinceName}) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/city/${provinceName}");
      Map<String, dynamic> data = response.data;
      CityModel cityModel = CityModel.fromJson(data);
      return cityModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load city");
    }
  }

  Future<DistrictModel> getDistrict({required String cityName}) async {
    try { 
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/district/$cityName");
      Map<String, dynamic> data = response.data;
      DistrictModel districtModel = DistrictModel.fromJson(data);
      return districtModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load district");
    }
  }  

  Future<SubdistrictModel> getSubdistrict({required String districtName}) async {
    try {
      Dio dio = await DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/subdistrict/$districtName");
      Map<String, dynamic> data = response.data;
      SubdistrictModel subdistrictModel = SubdistrictModel.fromJson(data);
      return subdistrictModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load subdistrict");
    }
  }

}