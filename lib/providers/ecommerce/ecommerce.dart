import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:saka/data/models/ecommerce/cart/cart.dart';
import 'package:saka/data/models/ecommerce/checkout/list.dart';
import 'package:saka/data/models/ecommerce/courier/courier.dart';
import 'package:saka/data/models/ecommerce/googlemaps/googlemaps.dart';
import 'package:saka/data/models/ecommerce/payment/payment.dart';
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
import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';
import 'package:saka/views/screens/ecommerce/payment/receipt_va.dart';

enum ListProductStatus { idle, loading, loaded, empty, error }
enum DetailProductStatus { idle, loading, loaded, empty, error }

enum AddCartStatus { idle, loading, loaded, empty, error }
enum GetCartStatus { idle, loading, loaded, empty, error }
enum DeleteCartStatus { idle, loading, loaded ,empty, error }

enum GetCourierStatus { idle, loading, loaded, empty, error }
enum AddCourierStatus { idle, loading, loaded, empty, error }

enum GetShippingAddressListStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressSingleStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressDefaultStatus { idle, loading, loaded, empty, error }
enum CreateShippingAddressStatus { idle, loading, loaded, empty, error }
enum UpdateShippingAddressStatus { idle, loading, loaded, empty, error }
enum SelectPrimaryShippingAddressStatus { idle, loading, loaded, empty, error }

enum GetCheckoutStatus { idle, loading, loaded ,empty, error }

enum GetProvinceStatus { idle, loading, loaded, empty, error }
enum GetCityStatus { idle, loading, loaded, empty, error }
enum GetDistrictStatus { idle, loading, loaded, empty, error }
enum GetSubdistrictStatus { idle, loading, loaded, empty, error }

enum PayStatus { idle, loading, loaded, empty, error }

class EcommerceProvider extends ChangeNotifier {
  final EcommerceRepo er;

  EcommerceProvider({
    required this.er
  });

  int channelId = -1;
  int amount = -1;
  String paymentName = "";
  String paymentCode = "";

  ListProductStatus _listProductStatus = ListProductStatus.loading;
  ListProductStatus get listProductStatus => _listProductStatus;

  DetailProductStatus _detailProductStatus = DetailProductStatus.loading;
  DetailProductStatus get detailProductStatus => _detailProductStatus;

  PayStatus _payStatus = PayStatus.idle;
  PayStatus get payStatus => _payStatus;

  GetCartStatus _getCartStatus = GetCartStatus.loading; 
  GetCartStatus get getCartStatus => _getCartStatus;

  AddCartStatus _addCartStatus = AddCartStatus.idle;
  AddCartStatus get addCartStatus => _addCartStatus;

  DeleteCartStatus _deleteCartStatus = DeleteCartStatus.idle;
  DeleteCartStatus get deleteCartStatus => _deleteCartStatus;

  GetCourierStatus _getCourierStatus = GetCourierStatus.loading;
  GetCourierStatus get getCourierStatus => _getCourierStatus;

  AddCourierStatus _addCourierStatus = AddCourierStatus.loading;
  AddCourierStatus get addCourierStatus => _addCourierStatus;

  GetCheckoutStatus _getCheckoutStatus = GetCheckoutStatus.loading;
  GetCheckoutStatus get getCheckoutStatus => _getCheckoutStatus;

  GetShippingAddressListStatus _getShippingAddressListStatus = GetShippingAddressListStatus.loading;
  GetShippingAddressListStatus get getShippingAddressListStatus => _getShippingAddressListStatus;

  GetShippingAddressSingleStatus _getShippingAddressSingleStatus = GetShippingAddressSingleStatus.loading;
  GetShippingAddressSingleStatus get getShippingAddressSingleStatus => _getShippingAddressSingleStatus;

  GetShippingAddressDefaultStatus _getShippingAddressDefaultStatus = GetShippingAddressDefaultStatus.loading;
  GetShippingAddressDefaultStatus get getShippingAddressDefaultStatus => _getShippingAddressDefaultStatus;

  CreateShippingAddressStatus _createShippingAddressStatus = CreateShippingAddressStatus.idle; 
  CreateShippingAddressStatus get createShippingAddressStatus => _createShippingAddressStatus;

  UpdateShippingAddressStatus _updateShippingAddressStatus = UpdateShippingAddressStatus.idle; 
  UpdateShippingAddressStatus get updateShippingAddressStatus => _updateShippingAddressStatus;

  SelectPrimaryShippingAddressStatus _selectPrimaryShippingAddressStatus = SelectPrimaryShippingAddressStatus.idle;
  SelectPrimaryShippingAddressStatus get  selectPrimaryShippingAddressStatus => _selectPrimaryShippingAddressStatus;

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

  List<ShippingAddressData> _shippingAddress = [];
  List<ShippingAddressData> get shippingAddress => [..._shippingAddress];

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

  void setStateAddCartStatus(AddCartStatus param) {
    _addCartStatus = param;

    notifyListeners();
  }

  void setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus param) {
    _selectPrimaryShippingAddressStatus = param;

    notifyListeners();
  }

  void setStateCreateShippingAddress(CreateShippingAddressStatus param) {
    _createShippingAddressStatus = param;

    notifyListeners();
  }

  void setStateUpdateShippingAddress(UpdateShippingAddressStatus param) {
    _updateShippingAddressStatus = param;

    notifyListeners();
  }

  void setStateDeleteCartStatus(DeleteCartStatus param) {
    _deleteCartStatus = param;

    notifyListeners();
  }

  void setStateGetCourierStatus(GetCourierStatus param) {
    _getCourierStatus = param;

    notifyListeners();
  }

  void setStateAddCourierStatus(AddCourierStatus param) {
    _addCourierStatus = param;

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

  void setStatePayStatus(PayStatus param) {
    _payStatus = param;

    notifyListeners();
  }

  Future<void> fetchAllProduct({required String search}) async {
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
      _shippingAddress = [];
      _shippingAddress.addAll(shippingAddressModel.data);
      setStateGetShippingAddressList(GetShippingAddressListStatus.loaded);

      if(shippingAddress.isEmpty) {
        setStateGetShippingAddressList(GetShippingAddressListStatus.empty);
      }

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

      if(shippingAddressDataDefault.name == null) {
        setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus.empty);
      }

    } catch(e) {
      setStateGetShippingAddressDefault(GetShippingAddressDefaultStatus.error);
    }
  }

  Future<void> createShippingAddress({
    required String label,
    required String address,
    required String province,
    required String city,
    required String district,
    required String postalCode,
    required String subdistrict
  }) async {
    setStateCreateShippingAddress(CreateShippingAddressStatus.loading);
    try {

      await er.createShippingAddress(
        label: label,
        address: address,
        province: province,
        city: city,
        district: district,
        postalCode: postalCode,
        subdistrict: subdistrict
      );

      Future.delayed(Duration.zero, () {
        getShippingAddressList();
        getShippingAddressDefault();
      });

      setStateCreateShippingAddress(CreateShippingAddressStatus.loaded);
    } catch(e) {
      setStateCreateShippingAddress(CreateShippingAddressStatus.error);
    }
  }

  Future<void> updateShippingAddress({
    required String id,
    required String label,
    required String address,
    required String province,
    required String city,
    required String district,
    required String postalCode,
    required String subdistrict
  }) async {
    setStateUpdateShippingAddress(UpdateShippingAddressStatus.loading);
    try {

      await er.updateShippingAddress(
        id: id,
        label: label,
        address: address,
        province: province,
        city: city,
        district: district,
        postalCode: postalCode,
        subdistrict: subdistrict
      );

      Future.delayed(Duration.zero, () {
        getShippingAddressList();
        getShippingAddressDefault();
      });

      setStateUpdateShippingAddress(UpdateShippingAddressStatus.loaded);
    } catch(e) {
      setStateUpdateShippingAddress(UpdateShippingAddressStatus.error);
    }
  }

  Future<void> selectPrimaryShippingAddress({
    required String id
  }) async {  
    setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.loading);
    try {

      await er.selectPrimaryAddress(id: id);

      Future.delayed(Duration.zero, () {
        getShippingAddressList();
        getShippingAddressDefault();
        getCheckoutList();
      });

      setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.loaded);
    } catch(e) {
      setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.error);
    }
  }

  Future<void> getCart() async {
    setStateGetCartStatus(GetCartStatus.loading);

    try {

      CartModel cartModel = await er.getCart();
      _cartData = cartModel.data;
      setStateGetCartStatus(GetCartStatus.loaded);

      if(cartData.stores!.isEmpty) {
           setStateGetCartStatus(GetCartStatus.empty);
      }
       
    } catch(e) {
      setStateGetCartStatus(GetCartStatus.error);
    } 
  }

  Future<void> addToCart({
    required String productId,
    required int qty,
    required String note
  }) async {
    setStateAddCartStatus(AddCartStatus.loading);
    try {
      await er.addToCart(note: note, qty: qty, productId: productId);
      setStateAddCartStatus(AddCartStatus.loaded);

      Future.delayed(Duration.zero,() {
        getCart();
      });
    } catch(e) {
      setStateAddCartStatus(AddCartStatus.error);
    }
  }


  Future<void> deleteCart({required String cartId}) async {
    setStateDeleteCartStatus(DeleteCartStatus.loading);
    try {
      await er.deleteCart(cartId: cartId);  
      setStateDeleteCartStatus(DeleteCartStatus.loaded);

      Future.delayed(Duration.zero,() {
        getCart();
      });
    } catch(e) {
      setStateDeleteCartStatus(DeleteCartStatus.error);
    }
  }

  Future<void> getCourierList({
    required BuildContext context,
    required String storeId
  }) async {
    setStateGetCourierStatus(GetCourierStatus.loading);
    try {

      CourierListModel courierListModel = await er.getCourier(
        storeId: storeId
      );

      showModalBottomSheet(
        context: context, 
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)
          )
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Text("Pilih Pengiriman",
                      style: robotoRegular.copyWith(
                        color: ColorResources.black,
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ),
                ],
              ),
                                        
              ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return const Divider(
                    thickness: 2.0,
                    color: Color(0xffF0F0F0),
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: courierListModel.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: courierListModel.data[i].costs.length,
                    itemBuilder: (BuildContext context, int z) {
                      final courierData = courierListModel.data[i].costs[z];

                      return InkWell(
                        onTap: () async {
                          String courierCode = courierListModel.data[i].code.toString();
                          String courierService = courierListModel.data[i].costs[z].service.toString();
                          String courierName = courierListModel.data[i].name.toString();
                          String courierDesc = courierListModel.data[i].costs[z].description.toString();
                          String costValue = courierListModel.data[i].costs[z].cost[0].value.toString();
                          String costNote =  courierListModel.data[i].costs[z].cost[0].note.toString();
                          String costEtd = courierListModel.data[i].costs[z].cost[0].etd.toString();

                          await er.addCourier(
                            courierCode: courierCode, 
                            courierService: courierService,
                            courierName: courierName, courierDesc: courierDesc, 
                            costValue: costValue, costNote: costNote, 
                            costEtd: costEtd, storeId: storeId
                          );

                          Future.delayed(Duration.zero, () {
                            getCheckoutList();
                          });

                          NS.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10.0, 
                              right: 10.0
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${courierData.service} (${Helper.formatCurrency(double.parse(courierListModel.data[i].costs[z].cost[0].value.toString()))})",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.black
                                      ),
                                    ),
                                    Container(
                                      width: 60.0,
                                      height: 30.0,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: AssetImage('assets/images/logo/jne.png')
                                        )
                                      ),
                                    )
                                  ],
                                ),
                                Text("${courierListModel.data[i].costs[z].cost[0].etd} hari",
                                  style: TextStyle(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: ColorResources.black
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      );

      setStateGetCourierStatus(GetCourierStatus.loaded);

    } catch(e) {
      setStateGetCourierStatus(GetCourierStatus.error);
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

    await er.updateQty(cartId:  _cartData.stores![i].items[z].cart.id, qty: cartData.stores![i].items[z].cart.qty);
  
    Future.delayed(Duration.zero, () {
      getCart();
    });

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

    await er.updateQty(cartId:  _cartData.stores![i].items[z].cart.id, qty: cartData.stores![i].items[z].cart.qty);

    Future.delayed(Duration.zero, () {
      getCart();
    });

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

  Future<void> getPaymentChannel({
    required BuildContext context,
    required int totalPrice
  }) async {
    try {

      PaymentChannelModel paymentChannelModel = await er.getPaymentChannel();
      
      showModalBottomSheet(
        context: context, 
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)
          )
        ),
        builder: (BuildContext context) {
          return Container(
            height: 280.0,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
            
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
            
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Text("Pilih Pembayaran",
                        style: robotoRegular.copyWith(
                          color: ColorResources.black,
                          fontSize: Dimensions.fontSizeLarge,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
            
                  ],
                ),
                                        
                ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return const Divider(
                      thickness: 2.0,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: paymentChannelModel.data.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    PaymentChannelItem payment = paymentChannelModel.data.data[i];
            
                    return Bouncing(
                      onPress: () async {
                        channelId = payment.id;
                        paymentName = payment.name;
                        paymentCode = payment.nameCode;
                        amount = totalPrice;

                        notifyListeners();

                        NS.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10.0, 
                            right: 10.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(payment.name,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.black
                                ),
                              ),
                              Text("Pilih",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.black
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    );
                    
                  },
                )
            
              ],
            ),
          );
        }
      );

    } catch(e) {

    }
  }

  Future<void> pay() async {
    setStatePayStatus(PayStatus.loading);
    try {

      // await er.pay(
      //   amount: amount, 
      //   app: "saka", 
      //   channelId: channelId, 
      //   paymentCode: paymentCode
      // );

      debugPrint(amount.toString());
      debugPrint(channelId.toString());
      debugPrint(paymentCode.toString());

      NS.pushReplacement(
        navigatorKey.currentContext!, 
        PaymentReceiptVaScreen()
      );

      setStatePayStatus(PayStatus.loaded);
    } catch(e) {
      setStatePayStatus(PayStatus.error);
    }
  }

}