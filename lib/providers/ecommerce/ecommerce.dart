import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:saka/data/models/ecommerce/cart/cart.dart';
import 'package:saka/data/models/ecommerce/checkout/list.dart';
import 'package:saka/data/models/ecommerce/googlemaps/googlemaps.dart';
import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/data/models/ecommerce/product/detail.dart';
import 'package:saka/data/models/ecommerce/region/city.dart';
import 'package:saka/data/models/ecommerce/region/district.dart';
import 'package:saka/data/models/ecommerce/region/province.dart';
import 'package:saka/data/models/ecommerce/region/subdistrict.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_default.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_detail.dart';

import 'package:saka/data/repository/ecommerce/ecommerce.dart';

enum ListProductStatus { idle, loading, loaded, empty, error }
enum DetailProductStatus { idle, loading, loaded, empty, error }
enum GetCartStatus { idle, loading, loaded, empty, error }

enum GetShippingAddressListStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressSingleStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressDefaultStatus { idle, loading, loaded, empty, error }

enum GetCheckoutStatus { idle, loading, loaded ,empty, error }

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

  GetCheckoutStatus _getCheckoutStatus = GetCheckoutStatus.loading;
  GetCheckoutStatus get getCheckoutStatus => _getCheckoutStatus;

  GetShippingAddressListStatus _getShippingAddressListStatus = GetShippingAddressListStatus.loading;
  GetShippingAddressListStatus get getShippingAddressListStatus => _getShippingAddressListStatus;

  GetShippingAddressSingleStatus _getShippingAddressSingleStatus = GetShippingAddressSingleStatus.loading;
  GetShippingAddressSingleStatus get getShippingAddressSingleStatus => _getShippingAddressSingleStatus;

  GetShippingAddressDefaultStatus _getShippingAddressDefaultStatus = GetShippingAddressDefaultStatus.loading;
  GetShippingAddressDefaultStatus get getShippingAddressDefaultStatus => _getShippingAddressDefaultStatus;

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

  CheckoutListData _checkoutListData = CheckoutListData();
  CheckoutListData get checkoutListData => _checkoutListData;

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

  ShippingAddressDataDefault _shippingAddressDataDefault = ShippingAddressDataDefault();
  ShippingAddressDataDefault get shippingAddressDataDefault => _shippingAddressDataDefault;

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

  void setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus param) {
    _getShippingAddressDefaultStatus = param;

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

  void setStateCheckoutStatus(GetCheckoutStatus param) {
    _getCheckoutStatus = param;

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

  Future<void> getShippingAddressDefault() async {
    setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus.loading);
    try {

      ShippingAddressModelDefault shippingAddressModelDefault = await er.getShippingAddressDefault();
      _shippingAddressDataDefault = shippingAddressModelDefault.data[0];

      setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus.loaded);
    } catch(e) {
      setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus.error);
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

  Future<void> getCheckoutList() async {
    setStateCheckoutStatus(GetCheckoutStatus.loading);
    try {

      CheckoutListModel checkoutListModel = await er.getCheckoutList();
      _checkoutListData = checkoutListModel.data;

      setStateCheckoutStatus(GetCheckoutStatus.loaded);
    } catch(e) {
      setStateCheckoutStatus(GetCheckoutStatus.error);
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

  Future<List<ProvinceData>> getProvince() async {
    setStateProvinceStatus(GetProvinceStatus.loading);

    try {

      ProvinceModel provinceModel = await er.getProvince();
      _provinces = [];
      _provinces.addAll(provinceModel.data);

      return provinceModel.data;

    } catch(e) {
      setStateProvinceStatus(GetProvinceStatus.error);
      throw [];    
    }
  }

  Future<List<CityData>> getCity({required String provinceName}) async {
    setStateCityStatus(GetCityStatus.loading);
    try {

      CityModel cityModel = await er.getCity(provinceName: provinceName);
      _city = [];
      _city.addAll(cityModel.data);

      return cityModel.data;

    } catch(e) {
      setStateCityStatus(GetCityStatus.error);
      throw [];
    }
  }

  Future<List<DistrictData>> getDistrict({required String cityName}) async {
    setStateDistrictStatus(GetDistrictStatus.loading);
    try {

      DistrictModel districtModel = await er.getDistrict(cityName: cityName);
      _district = [];
      _district.addAll(districtModel.data);

      return districtModel.data;

    } catch(e) {  
      setStateDistrictStatus(GetDistrictStatus.error);
      throw [];
    } 
  }

  Future<List<SubdistrictData>> getSubdistrict({required String districtName}) async {
    setStateSubdistrictStatus(GetSubdistrictStatus.loading);
    try {

      SubdistrictModel subdistrictModel = await er.getSubdistrict(districtName: districtName);
      _subdistrict = [];
      _subdistrict.addAll(subdistrictModel.data);
      
      return subdistrictModel.data;

    } catch(e) {
      setStateSubdistrictStatus(GetSubdistrictStatus.error);
      throw [];
    }
  }

  Future<List<PredictionModel>> getAutocomplete(String query) async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyCJD7w_-wHs4Pe5rWMf0ubYQFpAt2QF2RA");
      Map<String, dynamic> data = res.data;
      AutocompleteModel autocompleteModel = AutocompleteModel.fromJson(data);
      return autocompleteModel.predictions;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
    }
    return [];
  }


}