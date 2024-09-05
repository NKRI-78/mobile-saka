import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:saka/data/models/ecommerce/cart/cart.dart';
import 'package:saka/data/models/ecommerce/googlemaps/googlemaps.dart';
import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/data/models/ecommerce/product/detail.dart';
import 'package:saka/data/models/ecommerce/region/city.dart';
import 'package:saka/data/models/ecommerce/region/district.dart';
import 'package:saka/data/models/ecommerce/region/province.dart';
import 'package:saka/data/models/ecommerce/region/subdistrict.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_detail.dart';

import 'package:saka/data/repository/ecommerce/ecommerce.dart';

enum ListProductStatus { idle, loading, loaded, empty, error }
enum DetailProductStatus { idle, loading, loaded, empty, error }
enum GetCartStatus { idle, loading, loaded, empty, error }

enum GetShippingAddressListStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressSingleStatus { idle, loading, loaded, empty, error }

enum GetProvinceStatus { idle, loading, loaded, empty, error }
enum GetCityStatus { idle, loading, loaded, empty, error }
enum GetDistrictStatus { idle, loading, loaded, empty, error }
enum GetSubdistrictStatus { idle, loading, loaded, empty, error }

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

  GetShippingAddressListStatus _getShippingAddressListStatus = GetShippingAddressListStatus.loading;
  GetShippingAddressListStatus get getShippingAddressListStatus => _getShippingAddressListStatus;

  GetShippingAddressSingleStatus _getShippingAddressSingleStatus = GetShippingAddressSingleStatus.loading;
  GetShippingAddressSingleStatus get getShippingAddressSingleStatus => _getShippingAddressSingleStatus;

  GetProvinceStatus _getProvinceStatus = GetProvinceStatus.loading;
  GetProvinceStatus get getProvinceStatus => _getProvinceStatus;

  GetCityStatus _getCityStatus = GetCityStatus.loading;
  GetCityStatus get getCityStatus => _getCityStatus;

  GetDistrictStatus _getDistrictStatus = GetDistrictStatus.loading;
  GetDistrictStatus get getDistrictStatus => _getDistrictStatus;

  GetSubdistrictStatus _getSubdistrictStatus = GetSubdistrictStatus.loading;
  GetSubdistrictStatus get getSubdistrictStatus => _getSubdistrictStatus;

  CartData _cartData = CartData();
  CartData get cartData => _cartData;

  List<Product> _products = [];
  List<Product> get products => [..._products];

  List<ProvinceData> _provinces = [];
  List<ProvinceData> get provinces => [..._provinces];

  List<CityData> _city = [];
  List<CityData> get city => [..._city];

  List<DistrictData> _district = [];
  List<DistrictData> get district => [..._district];

  List<SubdistrictData> _subdistrict = [];
  List<SubdistrictData> get subdistrict => [..._subdistrict];

  List<ShippingAddressData> _shippingAddressList = [];
  List<ShippingAddressData> get shippingAddress => [..._shippingAddressList];

  ShippingAddressDetailData _shippingAddressDetailData = ShippingAddressDetailData();
  ShippingAddressDetailData get shippingAddressDetailData => _shippingAddressDetailData;

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

  void setStateGetShippingAddressList(GetShippingAddressListStatus param) {
    _getShippingAddressListStatus = param;

    notifyListeners();
  }

  void setStateGetShippingAddressSingle(GetShippingAddressSingleStatus param) {
    _getShippingAddressSingleStatus = param;

    notifyListeners();
  }

  void setStateProvinceStatus(GetProvinceStatus param) {
    _getProvinceStatus = param;

    notifyListeners();
  }

  void setStateCityStatus(GetCityStatus param) {
    _getCityStatus = param;

    notifyListeners();
  }

  void setStateDistrictStatus(GetDistrictStatus param) {
    _getDistrictStatus = param;

    notifyListeners();
  }

  void setStateSubdistrictStatus(GetSubdistrictStatus param) {
    _getSubdistrictStatus = param;

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

  Future<void> getShippingAddressList() async {
    setStateGetShippingAddressList(GetShippingAddressListStatus.loading);
    try { 
      
      ShippingAddressModel shippingAddressModel = await er.getShippingAddressList();
      _shippingAddressList = [];
      _shippingAddressList.addAll(shippingAddressModel.data);

      setStateGetShippingAddressList(GetShippingAddressListStatus.loaded);
    } catch(e) {
      setStateGetShippingAddressList(GetShippingAddressListStatus.error);
    }
  }

  Future<void> getShippingAddressSingle({required String id}) async {
    setStateGetShippingAddressSingle(GetShippingAddressSingleStatus.loading);
    try {

      ShippingAddressModelDetail shippingAddressModelDetail = await er.getShippingAddressDetail(id: id);
      _shippingAddressDetailData = shippingAddressModelDetail.data;

      setStateGetShippingAddressSingle(GetShippingAddressSingleStatus.loaded);
    } catch(e) {
      setStateGetShippingAddressSingle(GetShippingAddressSingleStatus.error);
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

  Future<void> decrementQty({required int i, required int z, required int qty}) async {
    _cartData.stores![i].selected = true;
    _cartData.stores![i].items[z].cart.selected = true;
    _cartData.stores![i].items[z].cart.qty = qty;

    int totalPriceQty = 0;

    for (StoreItem stores in cartData.stores!.where((el) => el.selected == true)) {
      for (StoreData cii in stores.items.where((el) => el.cart.selected == true)) {
        totalPriceQty += cii.price * cii.cart.qty; 
      }
    }

    _cartData.totalPrice = totalPriceQty;
    
    // await Future.wait([
    //   updateQty(cartId: cartId, qty: cartInfoData.stores![i].items[z].cart.quantity.toString()),
    //   pr.updateCartSelected(selected: true, cartId: cartId)
    // ]);

    Future.delayed(Duration.zero, () => notifyListeners());

    notifyListeners();
  }

  Future<void> incrementQty({required int i, required int z, required int qty}) async {
    _cartData.stores![i].selected = true;
    _cartData.stores![i].items[z].cart.selected = true;
    _cartData.stores![i].items[z].cart.qty = qty;

    int totalPriceQty = 0;

    for (StoreItem stores in cartData.stores!.where((el) => el.selected == true)) {
      for (StoreData cii in stores.items.where((el) => el.cart.selected == true)) {
        totalPriceQty += cii.price * cii.cart.qty; 
      }
    }

    _cartData.totalPrice = totalPriceQty;

    notifyListeners();
  }

  Future<void> getProvince() async {
    setStateProvinceStatus(GetProvinceStatus.loading);

    try {

      ProvinceModel provinceModel = await er.getProvince();
      _provinces = [];
      _provinces.addAll(provinceModel.data);

      setStateCityStatus(GetCityStatus.loaded);
    } catch(e) {
      setStateProvinceStatus(GetProvinceStatus.error);
    }
  }

  Future<void> getCity({required String provinceName}) async {
    setStateCityStatus(GetCityStatus.loading);
    try {

      CityModel cityModel = await er.getCity(provinceName: provinceName);
      _city = [];
      _city.addAll(cityModel.data);

      setStateCityStatus(GetCityStatus.loaded);
    } catch(e) {
      setStateCityStatus(GetCityStatus.error);
    }
  }

  Future<void> getDistrict({required String cityName}) async {
    setStateDistrictStatus(GetDistrictStatus.loading);
    try {

      DistrictModel districtModel = await er.getDistrict(cityName: cityName);
      _district = [];
      _district.addAll(districtModel.data);

      setStateDistrictStatus(GetDistrictStatus.loaded);
    } catch(e) {  
      setStateDistrictStatus(GetDistrictStatus.error);
    } 
  }

  Future<void> getSubdistrict({required String districtName}) async {
    setStateSubdistrictStatus(GetSubdistrictStatus.loading);
    try {

      SubdistrictModel subdistrictModel = await er.getSubdistrict(districtName: districtName);
      _subdistrict = [];
      _subdistrict.addAll(subdistrictModel.data);

      setStateSubdistrictStatus(GetSubdistrictStatus.loaded);
    } catch(e) {
      setStateSubdistrictStatus(GetSubdistrictStatus.error);
    }
  }

  Future<List<PredictionModel>> getAutocomplete(String query) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyBFRpXPf8BXaR22nDvvx2ghBfbUbGGX8N8");
      Map<String, dynamic> data = res.data;
      AutocompleteModel autocompleteModel = AutocompleteModel.fromJson(data);
      return autocompleteModel.predictions;
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return [];
  }


}