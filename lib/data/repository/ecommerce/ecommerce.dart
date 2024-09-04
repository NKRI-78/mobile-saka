import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

}