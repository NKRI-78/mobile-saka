import 'package:flutter/material.dart';
import 'package:saka/data/models/ecommerce/cart/cart.dart';

import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/data/models/ecommerce/product/detail.dart';

import 'package:saka/data/repository/ecommerce/ecommerce.dart';

enum ListProductStatus { idle, loading, loaded, empty, error }
enum DetailProductStatus { idle, loading, loaded, empty, error }
enum GetCartStatus { idle, loading, loaded, empty, error }

class EcommerceProvider extends ChangeNotifier {
  final EcommerceRepo er;

  EcommerceProvider({
    required this.er
  });

  ListProductStatus _listProductStatus = ListProductStatus.loading;
  ListProductStatus get listProductStatus => _listProductStatus;

  DetailProductStatus _detailProductStatus = DetailProductStatus.loading;
  DetailProductStatus get detailProductStatus => _detailProductStatus;

  GetCartStatus _getCartStatus = GetCartStatus.loading; 
  GetCartStatus get getCartStatus => _getCartStatus;

  CartData _cartData = CartData();
  CartData get cartData => _cartData;

  List<Product> _products = [];
  List<Product> get products => [..._products];

  ProductDetailData _productDetailData = ProductDetailData();
  ProductDetailData get productDetailData => _productDetailData;

  void setStateListProductStatus(ListProductStatus param) {
    _listProductStatus = param;
    
    notifyListeners();
  }

  void setStateDetailProductStatus(DetailProductStatus param) {
    _detailProductStatus = param;

    notifyListeners();
  }

  void setStateGetCartStatus(GetCartStatus param) {
    _getCartStatus = param;

    notifyListeners();
  }
 
  Future<void> fetchAllProducts({required String search}) async {
    setStateListProductStatus(ListProductStatus.loading);

    try {
      ProductModel productModel = await er.getAllProduct(search);
      _products = [];
      _products.addAll(productModel.data.products);
      setStateListProductStatus(ListProductStatus.loaded);

      if(products.isEmpty) {
        setStateListProductStatus(ListProductStatus.empty);
      }

    } catch (e) {
      setStateListProductStatus(ListProductStatus.error);
    } 
  }
  
  Future<void> fetchProduct({required String productId}) async {
    setStateDetailProductStatus(DetailProductStatus.loading);
    try {
      ProductDetailModel productDetailModel = await er.getProduct(productId: productId);
      _productDetailData = productDetailModel.data;
      
      setStateDetailProductStatus(DetailProductStatus.loaded);
    } catch(e) {  
      setStateDetailProductStatus(DetailProductStatus.error);
    }
  }

  Future<void> getCart() async {
    setStateGetCartStatus(GetCartStatus.loading);

    try {

      CartModel cartModel = await er.getCart();
      _cartData = cartModel.data;
      setStateGetCartStatus(GetCartStatus.loaded);
       
    } catch(e) {
      setStateGetCartStatus(GetCartStatus.error);
    } 

  }

}