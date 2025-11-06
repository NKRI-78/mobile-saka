import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:image_picker/image_picker.dart';
import 'package:saka/data/models/ecommerce/balance/balance.dart';

import 'package:saka/data/models/ecommerce/cart/cart.dart';
import 'package:saka/data/models/ecommerce/checkout/list.dart';
import 'package:saka/data/models/ecommerce/courier/courier.dart';
import 'package:saka/data/models/ecommerce/googlemaps/googlemaps.dart';
import 'package:saka/data/models/ecommerce/order/detail.dart';
import 'package:saka/data/models/ecommerce/order/list.dart';
import 'package:saka/data/models/ecommerce/order/tracking.dart';
import 'package:saka/data/models/ecommerce/payment/how_to.dart';
import 'package:saka/data/models/ecommerce/payment/payment.dart';
import 'package:saka/data/models/ecommerce/payment/response_emoney.dart';
import 'package:saka/data/models/ecommerce/payment/response_va.dart';
import 'package:saka/data/models/ecommerce/product/all.dart';
import 'package:saka/data/models/ecommerce/product/category.dart';
import 'package:saka/data/models/ecommerce/product/detail.dart';
import 'package:saka/data/models/ecommerce/product/transaction.dart';
import 'package:saka/data/models/ecommerce/region/city.dart';
import 'package:saka/data/models/ecommerce/region/district.dart';
import 'package:saka/data/models/ecommerce/region/province.dart';
import 'package:saka/data/models/ecommerce/region/subdistrict.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_default.dart';
import 'package:saka/data/models/ecommerce/shipping_address/shipping_address_detail.dart';

import 'package:saka/data/repository/ecommerce/ecommerce.dart';
import 'package:saka/data/repository/media/media.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/services/services.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/views/basewidgets/button/bounce.dart';
import 'package:saka/views/screens/ecommerce/payment/receipt_emoney.dart';
import 'package:saka/views/screens/ecommerce/payment/receipt_va.dart';

enum ListProductStatus { idle, loading, loaded, empty, error }
enum ListProductTransactionStatus { idle, loading, loaded, empty, error }
enum DetailProductStatus { idle, loading, loaded, empty, error }

enum BalanceStatus { idle, loading, loaded, empty, error }

enum CancelOrderStatus { idle, loading, loaded, empty, error }

enum GetProductCategoryStatus { idle, loading, loaded, empty, error }

enum ListOrderStatus { idle, loading, loaded, empty, error }
enum DetailOrderStatus { idle, loading, loaded, empty, error }

enum TrackingStatus { idle, loading, loaded, empty, error }

enum AddCartStatus { idle, loading, loaded, empty, error }
enum AddCartLiveStatus { idle, loading, loaded, empty, error }
enum GetCartStatus { idle, loading, loaded, empty, error }
enum DeleteCartStatus { idle, loading, loaded ,empty, error }

enum GetCourierStatus { idle, loading, loaded, empty, error }
enum AddCourierStatus { idle, loading, loaded, empty, error }

enum GetPaymentChannelStatus { idle, loading, loaded, empty, error }

enum GetShippingAddressListStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressSingleStatus { idle, loading, loaded, empty, error }
enum GetShippingAddressDefaultStatus { idle, loading, loaded, empty, error }

enum DeleteShippingAddressStatus { idle, loading, loaded, empty, error }
enum CreateShippingAddressStatus { idle, loading, loaded, empty, error }
enum UpdateShippingAddressStatus { idle, loading, loaded, empty, error }

enum SelectPrimaryShippingAddressStatus { idle, loading, loaded, empty, error }

enum HowToPaymentStatus { idle, loading, loaded, empty, error }

enum GetCheckoutStatus { idle, loading, loaded ,empty, error }

enum PayStatus { idle, loading, loaded, empty, error }

class EcommerceProvider extends ChangeNotifier {
  final EcommerceRepo er;
  final MediaRepo mr;

  EcommerceProvider({
    required this.er,
    required this.mr
  });

  late AnimationController controller;
  late Animation<double> animation;

  int balance = 0;

  int selectedTopupId = 0;
  int selectedTopupPrice = 0;

  List<Asset> images = [];

  Future<void> pickImage({
    required BuildContext context, 
    required int i
  }) async {
    ImageSource? imageSource = await showDialog<ImageSource>(context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Pilih sumber gambar",
          style: TextStyle(
            color: ColorResources.purple
          ),
        ),
        actions: [
          MaterialButton(
            child: const Text("Kamera",
              style: TextStyle(
                color: ColorResources.purple
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            onPressed: () => uploadImg(i: i),
            child: const Text( "Galeri",
              style: TextStyle(
                color: ColorResources.purple
              ),
            ),
          )
        ],
      )
    );

    if(imageSource != null) {
      XFile? filePath = await ImagePicker().pickImage(source: imageSource);
      File tempFile= File(filePath!.path);

      _productTransactions[i].befores.add(tempFile);
      _productTransactions[i].files = productTransactions[i].befores.toSet().toList();

      notifyListeners();
    }

  }

  void uploadImg({
    required int i
  }) async {

    if(productTransactions[i].files.isEmpty) {
    } else if(productTransactions[i].files.length == 4) { 
    } else if(productTransactions[i].files.length == 3) { 
    } else if(productTransactions[i].files.length == 2) { 
    } else { 
    } 

    Future.delayed(Duration.zero, () {
      NS.pop(rootNavigator: true);
    });

    // for (Asset imageAsset in resultList) {
    //   final filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
    //   File tempFile = File(filePath!);

    //   images = resultList;

    //   _productTransactions[i].befores.add(tempFile);
    //   _productTransactions[i].files = productTransactions[i].befores.toSet().toList();

    //   notifyListeners();
    // }
  }

  void removeFile({
    required int i,
    required int z
  }) {
    _productTransactions[i].files.removeAt(z);
    _productTransactions[i].befores.removeAt(z);

    notifyListeners();
  }

  void onChangeRating({required int i, required double rating}) {
    _productTransactions[i].rating = rating;

    notifyListeners();
  }

  bool selectedAll = true;
  bool reached = false;
  bool hasMore = false;
  int page = 1;

  int listenQty = -1;

  int submitLoadingReview = -1;

  int channelId = -1;
  int paymentFee = 0;

  String cat = "";
  String cartId = "";

  String paymentLogo = "";
  String paymentName = "";
  String paymentCode = "";
  String platform = "";

  String courierNameSelect = "";

  TextEditingController amountC = TextEditingController();

  BalanceStatus _balanceStatus = BalanceStatus.idle;
  BalanceStatus get balanceStatus => _balanceStatus;

  HowToPaymentStatus _howToPaymentStatus = HowToPaymentStatus.idle;
  HowToPaymentStatus get howToPaymentStatus => _howToPaymentStatus;

  CancelOrderStatus _cancelOrderStatus = CancelOrderStatus.idle;
  CancelOrderStatus get cancelOrderStatus => _cancelOrderStatus;

  ListProductStatus _listProductStatus = ListProductStatus.loading;
  ListProductStatus get listProductStatus => _listProductStatus;

  ListProductTransactionStatus _listProductTransactionStatus = ListProductTransactionStatus.loading;
  ListProductTransactionStatus get listProductTransactionStatus => _listProductTransactionStatus;

  GetProductCategoryStatus _getProductCategoryStatus = GetProductCategoryStatus.loading;
  GetProductCategoryStatus get getProductCategoryStatus => _getProductCategoryStatus;

  DetailProductStatus _detailProductStatus = DetailProductStatus.loading;
  DetailProductStatus get detailProductStatus => _detailProductStatus;

  ListOrderStatus _listOrderStatus = ListOrderStatus.loading;
  ListOrderStatus get listOrderStatus => _listOrderStatus;

  DetailOrderStatus _detailOrderStatus = DetailOrderStatus.loading;
  DetailOrderStatus get detailOrderStatus => _detailOrderStatus;

  PayStatus _payStatus = PayStatus.idle;
  PayStatus get payStatus => _payStatus;

  GetCartStatus _getCartStatus = GetCartStatus.loading; 
  GetCartStatus get getCartStatus => _getCartStatus;

  TrackingStatus _trackingStatus = TrackingStatus.loading;
  TrackingStatus get trackingStatus => _trackingStatus;

  AddCartStatus _addCartStatus = AddCartStatus.idle;
  AddCartStatus get addCartStatus => _addCartStatus;

  AddCartLiveStatus _addCartLiveStatus = AddCartLiveStatus.idle;
  AddCartLiveStatus get addCartLiveStatus => _addCartLiveStatus;

  DeleteCartStatus _deleteCartStatus = DeleteCartStatus.idle;
  DeleteCartStatus get deleteCartStatus => _deleteCartStatus;

  GetCourierStatus _getCourierStatus = GetCourierStatus.loading;
  GetCourierStatus get getCourierStatus => _getCourierStatus;

  AddCourierStatus _addCourierStatus = AddCourierStatus.loading;
  AddCourierStatus get addCourierStatus => _addCourierStatus;

  GetCheckoutStatus _getCheckoutStatus = GetCheckoutStatus.loading;
  GetCheckoutStatus get getCheckoutStatus => _getCheckoutStatus;

  GetPaymentChannelStatus _getPaymentChannelStatus = GetPaymentChannelStatus.idle;
  GetPaymentChannelStatus get getPaymentChannelStatus => _getPaymentChannelStatus;

  GetShippingAddressListStatus _getShippingAddressListStatus = GetShippingAddressListStatus.loading;
  GetShippingAddressListStatus get getShippingAddressListStatus => _getShippingAddressListStatus;

  GetShippingAddressSingleStatus _getShippingAddressSingleStatus = GetShippingAddressSingleStatus.loading;
  GetShippingAddressSingleStatus get getShippingAddressSingleStatus => _getShippingAddressSingleStatus;

  GetShippingAddressDefaultStatus _getShippingAddressDefaultStatus = GetShippingAddressDefaultStatus.loading;
  GetShippingAddressDefaultStatus get getShippingAddressDefaultStatus => _getShippingAddressDefaultStatus;

  CreateShippingAddressStatus _createShippingAddressStatus = CreateShippingAddressStatus.idle; 
  CreateShippingAddressStatus get createShippingAddressStatus => _createShippingAddressStatus;

  DeleteShippingAddressStatus _deleteShippingAddressStatus = DeleteShippingAddressStatus.idle;
  DeleteShippingAddressStatus get deleteShippingAddressStatus => _deleteShippingAddressStatus;

  UpdateShippingAddressStatus _updateShippingAddressStatus = UpdateShippingAddressStatus.idle; 
  UpdateShippingAddressStatus get updateShippingAddressStatus => _updateShippingAddressStatus;

  SelectPrimaryShippingAddressStatus _selectPrimaryShippingAddressStatus = SelectPrimaryShippingAddressStatus.idle;
  SelectPrimaryShippingAddressStatus get  selectPrimaryShippingAddressStatus => _selectPrimaryShippingAddressStatus;

  CartData _cartData = CartData();
  CartData get cartData => _cartData;

  CheckoutListData _checkoutListData = CheckoutListData();
  CheckoutListData get checkoutListData => _checkoutListData;

  List<DataHowToPayment> _mbank = [];
  List<DataHowToPayment> get mbank => [..._mbank];

  List<DataHowToPayment> _atm = [];
  List<DataHowToPayment> get atm => [..._atm];

  List<DataHowToPayment> _emoney = [];
  List<DataHowToPayment> get emoney => [..._emoney]; 

  List<Product> _products = [];
  List<Product> get products => [..._products];
  
  List<ProductTransactionData> _productTransactions = [];
  List<ProductTransactionData> get productTransactions => [..._productTransactions];

  List<ProductCategoryData> _productCategories = [];
  List<ProductCategoryData> get productCategories => [..._productCategories];

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

  List<ListOrderData> _orders = [];
  List<ListOrderData> get orders => [..._orders];

  List<DetailOrderData> _detailOrders = [];
  List<DetailOrderData> get detailOrders => [..._detailOrders];

  ShippingAddressDetailData _shippingAddressDetailData = ShippingAddressDetailData();
  ShippingAddressDetailData get shippingAddressDetailData => _shippingAddressDetailData;

  ShippingAddressDataDefault _shippingAddressDataDefault = ShippingAddressDataDefault();
  ShippingAddressDataDefault get shippingAddressDataDefault => _shippingAddressDataDefault;

  ProductDetailData _productDetailData = ProductDetailData();
  ProductDetailData get productDetailData => _productDetailData;

  TrackingData _trackingData = TrackingData();
  TrackingData get trackingData => _trackingData;

  void setStateCancelOrderStatus(param) {
    _cancelOrderStatus = param;

    notifyListeners();
  }

  void setStateHowToPayment(HowToPaymentStatus param) {
    _howToPaymentStatus = param;

    notifyListeners();
  }

  void setStateBalanceStatus(BalanceStatus param) {
    _balanceStatus = param;

    notifyListeners();
  }

  void setStateListProductStatus(ListProductStatus param) {
    _listProductStatus = param;
    
    notifyListeners();
  }

  void setStateGetProductCategoryStatus(GetProductCategoryStatus param) {
    _getProductCategoryStatus = param;

    notifyListeners();
  }

  void setStateDetailProductStatus(DetailProductStatus param) {
    _detailProductStatus = param;

    notifyListeners();
  }

  void setStateTrackingStatus(TrackingStatus param) {
    _trackingStatus = param;

    notifyListeners();
  }

  void setStateListOrderStatus(ListOrderStatus param) {
    _listOrderStatus = param;

    notifyListeners();
  }

  void setStateListProductTransactionStatus(ListProductTransactionStatus param) {
    _listProductTransactionStatus = param;

    notifyListeners();
  }

  void setStateDetailOrderStatus(DetailOrderStatus param) {
    _detailOrderStatus = param;

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

  void setStateAddCartLiveStatus(AddCartLiveStatus param) {
    _addCartLiveStatus = param;

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

  void setStateDeleteShippingAddress(DeleteShippingAddressStatus param) {
    _deleteShippingAddressStatus = param;

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

  void setStateCheckoutStatus(GetCheckoutStatus param) {
    _getCheckoutStatus = param;

    notifyListeners();
  }

  void setStatePayStatus(PayStatus param) {
    _payStatus = param;

    notifyListeners();
  }

  void setStateGetPaymentChannelStatus(GetPaymentChannelStatus param) {
    _getPaymentChannelStatus = param;

    notifyListeners();
  }

  void selectTopup({
    required int id,
    required int price   
  }) {
    selectedTopupId = id;
    selectedTopupPrice = price;
    amountC.text = "";

    notifyListeners();
  } 

  void onManualTopup({
    required int price
  }) {
    selectedTopupId = 0;
    selectedTopupPrice = price; 

    notifyListeners();
  }

  void selectCat({required String param}) {
    page = 1;
    cat = param;

    if(param == "Semua") {
      cat = "";
    }

    Future.delayed(Duration(seconds: 1), () async {
      await fetchAllProduct(search: "");
    });

    notifyListeners();
  }

  void onSubmitLoadingReview({required int i}) {
    submitLoadingReview = i;

    notifyListeners();
  }

  Future<void> storeItemSelectedAll({
    required int i
  }) async {

    selectedAll = !selectedAll;
    notifyListeners();

    int totalPrice = 0;
    
    for (StoreItem cis in cartData.stores!) {

      for (StoreData cii in cis.items) {
        cii.cart.selected = selectedAll;

        await er.updateSelectedAll(selected: selectedAll);
      }

      for (StoreData cii in cis.items.where((el) => el.cart.selected == true)) {
        totalPrice += cii.price * cii.cart.qty;
      }

    }

    cartData.totalPrice = totalPrice;

    notifyListeners();

  }

  Future<void> storeItemSelected({
    required int i,
    required int z,
    required String cartIdParam
  }) async {
    if(cartData.stores![i].items[z].cart.selected)  {

      cartData.stores![i].items[z].cart.selected = false;

      selectedAll = false;

      if(cartData.stores![i].items.where((el) => el.cart.selected == true).toList().isEmpty) {
        cartData.stores![i].selected = false;
      }

      int totalPrice = 0;
      
      for (StoreItem cis in cartData.stores!.where((el) => el.selected == true)) {
        for (StoreData cii in cis.items.where((el) => el.cart.selected == true)) {
          totalPrice += cii.price * cii.cart.qty;
        }
      }

      cartData.totalPrice = totalPrice;

      await er.updateSelected(selected: false, cartId: cartIdParam);

    }  else {
      
      cartData.stores![i].selected = true;
      cartData.stores![i].items[z].cart.selected = true;

      int totalPrice = 0;
      
      for (StoreItem cis in cartData.stores!.where((el) => el.selected == true)) {
        for (StoreData cii in cis.items.where((el) => el.cart.selected == true)) {
          totalPrice += cii.price * cii.cart.qty;
        }

        if(cis.items.every((el) => el.cart.selected == true)) {
          selectedAll = true;
        }
      }

      cartData.totalPrice = totalPrice;

      await er.updateSelected(selected: true, cartId: cartIdParam);
    }

    notifyListeners();
  } 

  Future<void> getBalance() async {
    try { 
      BalanceModel balanceModel = await er.getBalance();
      
      balance = balanceModel.data.balance;

      setStateBalanceStatus(BalanceStatus.loaded);
    } catch(e) {
      setStateBalanceStatus(BalanceStatus.error);
    }
  }

  Future<void> listOrder({required String orderStatus}) async {
    setStateListOrderStatus(ListOrderStatus.loading);
    try {

      ListOrderModel listOrderModel = await er.getOrderList(orderStatus: orderStatus);
      
      _orders = [];
      _orders.addAll(listOrderModel.data);
      setStateListOrderStatus(ListOrderStatus.loaded);

      if(orders.isEmpty) {
        setStateListOrderStatus(ListOrderStatus.empty);
      }

    } catch(e) {
      setStateListOrderStatus(ListOrderStatus.error);
    }
  }

  Future<void> detailOrder({required String transactionId}) async {
    setStateDetailOrderStatus(DetailOrderStatus.loading);
    try {

      DetailOrderModel detailOrderModel = await er.getOrderDetail(transactionId: transactionId);
      
      _detailOrders = [];
      _detailOrders.addAll(detailOrderModel.data);

      setStateDetailOrderStatus(DetailOrderStatus.loaded);
    } catch(e) {
      setStateDetailOrderStatus(DetailOrderStatus.error);
    }
  }

  Future<void> cancelOrder({required String transactionId}) async {
    setStateCancelOrderStatus(CancelOrderStatus.loading);
    try {
      await er.cancelOrder(transactionId: transactionId);
      setStateCancelOrderStatus(CancelOrderStatus.loaded);

      Future.delayed(Duration(seconds: 1), () {
        NS.pop();
        NS.pop();

        listOrder(orderStatus: "WAITING_PAYMENT");
      });
    } catch(e) {
      setStateCancelOrderStatus(CancelOrderStatus.error);
    }
  }
  
  Future<TrackingModel> trackingOrder({required String waybill}) async {
    return er.getTracking(waybill: waybill);
  }

  Future<void> fetchAllProduct({required String search}) async {
    setStateListProductStatus(ListProductStatus.loading);

    page = 1;
    reached = false;

    try {
      
      ProductModel productModel = await er.fetchAllProduct(
        search: search, 
        page: page,
        cat: cat
      );

      hasMore = productModel.data.pageDetail.hasMore;

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

  Future<void> fetchAllProductCategory() async {
    try {

      ProductCategoryModel productCategoryModel = await er.fetchProductCategory();

      _productCategories = [];
      _productCategories.add(
        ProductCategoryData(
          id: "30a58b87-4157-44fd-b840-f5b3d6691820",
          name: "Semua"
        )
      );
      _productCategories.addAll(productCategoryModel.data);
      setStateGetProductCategoryStatus(GetProductCategoryStatus.loaded);

      if(productCategories.isEmpty) {
        setStateGetProductCategoryStatus(GetProductCategoryStatus.empty);
      }

    } catch(e) {
      setStateGetProductCategoryStatus(GetProductCategoryStatus.error);
    }
  }

  Future<void> fetchAllProductTransaction({
    required String transactionId
  }) async {
    setStateListProductTransactionStatus(ListProductTransactionStatus.loading);
    try {

      ProductTransactionModel productTransactionModel = await er.fetchProductTransaction(transactionId: transactionId); 

      _productTransactions = [];
      _productTransactions.addAll(productTransactionModel.data);
      setStateListProductTransactionStatus(ListProductTransactionStatus.loaded);

      if(productTransactions.isEmpty) {
        setStateListProductTransactionStatus(ListProductTransactionStatus.empty);
      }

    } catch(e) {
      setStateListProductTransactionStatus(ListProductTransactionStatus.error);
    } 
  }

  Future<void> loadMoreProduct() async {

    page++;

    notifyListeners();

    ProductModel productModel = await er.fetchAllProduct(
      cat: cat, 
      page: page, 
      search: ""
    );

    hasMore = productModel.data.pageDetail.hasMore;

    _products.addAll(productModel.data.products);

    notifyListeners();
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

  Future<void> productReview({
    required BuildContext context,
    required String productId, 
    required String transactionId,
    required String caption,
    required double rating,
    required List<File> files,   
  }) async {
    try {

      if(files.isNotEmpty) {
        for (File file in files) {
          Response? res = await mr.postMedia(context, file);
          Map map = json.decode(res.data);
          await er.productReviewMedia(
            productId: productId,
            path: map['data']['path'],
          );
        }
      }

      await er.productReview(
        productId: productId,
        transactionId: transactionId,
        caption: caption, 
        rating: rating
      );

      Future.delayed(Duration.zero, () {
        fetchAllProductTransaction(transactionId: transactionId);
      });

    } catch(e) {
      
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
      
      Future.delayed(Duration(seconds: 1), () {
        getShippingAddressList();
        getShippingAddressDefault();
      });

      NS.pop();

      setStateCreateShippingAddress(CreateShippingAddressStatus.loaded);
    } catch(e) {
      setStateCreateShippingAddress(CreateShippingAddressStatus.error);
    }
  }

  Future<void> deleteShippingAddress({
    required String id
  }) async {
    setStateDeleteShippingAddress(DeleteShippingAddressStatus.loading);
    try {

      await er.deleteShippingAddress(id: id);

      Future.delayed(Duration(seconds: 1), () {
        getShippingAddressList();
        getShippingAddressDefault();
      });

      setStateDeleteShippingAddress(DeleteShippingAddressStatus.loaded);
    } catch(e) {
      setStateDeleteShippingAddress(DeleteShippingAddressStatus.error);
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

      Future.delayed(Duration(seconds: 1), () {
        getShippingAddressList();
        getShippingAddressDefault();
      });

      NS.pop();

      setStateUpdateShippingAddress(UpdateShippingAddressStatus.loaded);
    } catch(e) {
      setStateUpdateShippingAddress(UpdateShippingAddressStatus.error);
    }
  }

  Future<void> selectPrimaryShippingAddress({
    required String id,
    required String from
  }) async {  
    setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.loading);
    try {

      await er.selectPrimaryAddress(id: id);

      Future.delayed(Duration(seconds: 1), () {
        getShippingAddressList();
        getShippingAddressDefault();
        getCheckoutList(from: from);
      });

      setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.loaded);
    } catch(e) {
      setStateSelectPrimaryAddressStatus(SelectPrimaryShippingAddressStatus.error);
    }
  }

  Future<void> getCart() async {
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
    controller.forward();
    setStateAddCartStatus(AddCartStatus.loading);
    try {
      String dataCartId = await er.addToCart(note: note, qty: qty, productId: productId);
      setStateAddCartStatus(AddCartStatus.loaded);

      cartId = dataCartId;

      Future.delayed(Duration(seconds: 2),() {
        getCart();
        controller.stop();
        notifyListeners();
      });
    } catch(e) {
      setStateAddCartStatus(AddCartStatus.error);
    }
  }

  Future<void> addToCartLive({
    required String productId,
    required String note
  }) async {
    controller.forward();
    setStateAddCartLiveStatus(AddCartLiveStatus.loading);
    try {
      String dataCartId = await er.addToCartLive(note: note, productId: productId);
      setStateAddCartLiveStatus(AddCartLiveStatus.loaded);

      cartId = dataCartId;

      Future.delayed(Duration(seconds: 2),() {
        getCart();
        controller.stop();
        notifyListeners();
      });
    } catch(e) {
      setStateAddCartLiveStatus(AddCartLiveStatus.error);
    }
  }

  Future<void> deleteCart({required String cartId}) async {
    setStateDeleteCartStatus(DeleteCartStatus.loading);
    try {
      await er.deleteCart(cartId: cartId);  
      setStateDeleteCartStatus(DeleteCartStatus.loaded);

      Future.delayed(Duration(seconds: 1),() {
        getCart();
      });
    } catch(e) {
      setStateDeleteCartStatus(DeleteCartStatus.error);
    }
  }

  Future<void> deleteCartLiveAll() async {
    try {
      await er.deleteCartLiveAll();
    } catch(_) {}
  }

  Future<void> getCourierList({
    required BuildContext context,
    required String storeId,
    required String from
  }) async {
    setStateGetCourierStatus(GetCourierStatus.loading);
    try {

      CourierListModel courierList = await er.getCourier(
        storeId: storeId,
        from: from
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
                        fontWeight: FontWeight.bold
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
                itemCount: courierList.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: courierList.data[i].costs.length,
                    itemBuilder: (BuildContext context, int z) {
                      final courierData = courierList.data[i].costs[z];

                      return InkWell(
                        onTap: () async {
                          String courierCode = courierList.data[i].code.toString();
                          String courierService = courierList.data[i].costs[z].service.toString();
                          String courierName = courierList.data[i].name.toString();
                          String courierDesc = courierList.data[i].costs[z].description.toString();
                          String costValue = courierList.data[i].costs[z].cost[0].value.toString();
                          String costNote =  courierList.data[i].costs[z].cost[0].note.toString();
                          String costEtd = courierList.data[i].costs[z].cost[0].etd.toString();

                          courierNameSelect = courierName;

                          await er.addCourier(
                            courierCode: courierCode, 
                            courierService: courierService,
                            courierName: courierName, courierDesc: courierDesc, 
                            costValue: costValue, costNote: costNote, 
                            costEtd: costEtd, storeId: storeId
                          );

                          Future.delayed(Duration(seconds: 1), () {
                            getCheckoutList(from: from);
                          });

                          NS.pop();
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
                                    Text("${courierData.service} (${Helper.formatCurrency(courierList.data[i].costs[z].cost[0].value)})",
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.bold,
                                        color: ColorResources.black
                                      ),
                                    ),
                                    Container(
                                      width: 60.0,
                                      height: 30.0,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: AssetImage('assets/images/logo/jne.jpg')
                                        )
                                      ),
                                    )
                                  ],
                                ),
                                Text("${courierList.data[i].costs[z].cost[0].etd} hari",
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

  Future<void> clearCourier() async {
    await er.clearCourier();
  }

  void clearPayment() {
    channelId = -1;
    paymentFee = 0;

    notifyListeners();
  } 

  Future<void> getCheckoutList({required String from}) async {
    setStateCheckoutStatus(GetCheckoutStatus.loading);
    try {

      CheckoutListModel checkoutListModel = await er.getCheckoutList(
         from: from
      );
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

    listenQty = qty;

    for (StoreItem stores in cartData.stores!.where((el) => el.selected == true)) {
      for (StoreData cii in stores.items.where((el) => el.cart.selected == true)) {
        totalPriceQty += cii.price * cii.cart.qty; 
      }
    }

    _cartData.totalPrice = totalPriceQty;

    await er.updateQty(cartId:  _cartData.stores![i].items[z].cart.id, qty: cartData.stores![i].items[z].cart.qty);

    notifyListeners();
  }

  Future<void> incrementQty({required int i, required int z, required int qty}) async {
    _cartData.stores![i].selected = true;
    _cartData.stores![i].items[z].cart.selected = true;
    _cartData.stores![i].items[z].cart.qty = qty;

    int totalPriceQty = 0;

    listenQty = qty;

    for (StoreItem stores in cartData.stores!.where((el) => el.selected == true)) {
      for (StoreData cii in stores.items.where((el) => el.cart.selected == true)) {
        totalPriceQty += cii.price * cii.cart.qty; 
      }
    }

    _cartData.totalPrice = totalPriceQty;

    await er.updateQty(cartId:  _cartData.stores![i].items[z].cart.id, qty: cartData.stores![i].items[z].cart.qty);

    notifyListeners();
  }

  void incrementTotalProduct(int i, int z, String cartId, String val) {
    var qty = int.parse(val.toString());

    _cartData.stores![i].items[z].cart.qty = qty;

    int totalPrice = 0;
      
    for (StoreItem cis in cartData.stores!.where((el) => el.selected == true).toList()) {
      for (StoreData cii in cis.items.where((el) => el.cart.selected == true).toList()) {
        totalPrice += cii.price * cii.cart.qty;
      }
    }

    _cartData.totalPrice = totalPrice;
   
    notifyListeners();
  }

  Future<void> updateQty({
    required String cartId, 
    required int qty
  }) async {
    await er.updateQty( 
      cartId: cartId, 
      qty: qty
    );
  }

  Future<void> updateNote({required String cartId, required String note}) async {
    try {

      await er.updateNote(
        cartId: cartId, 
        note: note
      );

      notifyListeners();

    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<List<ProvinceData>> getProvince({required String search}) async {
    try {

      ProvinceModel provinceModel = await er.getProvince(search: search);
      _provinces = [];
      _provinces.addAll(provinceModel.data);

      notifyListeners();

      return provinceModel.data;

    } catch(e) {
      throw [];    
    }
  }

  Future<List<CityData>> getCity({
    required String provinceName,
    required String search
  }) async {
    try {

      CityModel cityModel = await er.getCity(
        provinceName: provinceName,
        search: search
      );
      
      _city = [];
      _city.addAll(cityModel.data);

      notifyListeners();

      return cityModel.data;

    } catch(e) {
      throw [];
    }
  }

  Future<List<DistrictData>> getDistrict({
    required String cityName,
    required String search  
  }) async {
    try {

      DistrictModel districtModel = await er.getDistrict(
        cityName: cityName,
        search: search
      );
      _district = [];
      _district.addAll(districtModel.data);

      notifyListeners();

      return districtModel.data;

    } catch(e) {  
      throw [];
    } 
  }

  Future<List<SubdistrictData>> getSubdistrict({
    required String districtName,
    required String search
  }) async {
    try {

      SubdistrictModel subdistrictModel = await er.getSubdistrict(
        districtName: districtName,
        search: search,
      );
      _subdistrict = [];
      _subdistrict.addAll(subdistrictModel.data);

      notifyListeners();
      
      return subdistrictModel.data;

    } catch(e) {
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
    } catch(e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> getPaymentChannel({
    required BuildContext context
  }) async {
    setStateGetPaymentChannelStatus(GetPaymentChannelStatus.loading);
    try {

      // BalanceModel balanceModel = await er.getBalance();

      PaymentChannelModel paymentChannelModel = await er.getPaymentChannel();

      setStateGetPaymentChannelStatus(GetPaymentChannelStatus.loaded);
      
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
            height: 560.0,
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
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
            
                  ],
                ),

                // Bouncing(
                //   onPress: () async {
                //     channelId = 99;

                //     paymentName = "Saldo";

                //     notifyListeners();

                //     NS.pop();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Container(
                //       margin: const EdgeInsets.only(
                //         left: 10.0, 
                //         right: 10.0
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         mainAxisSize: MainAxisSize.max,
                //         children: [
                //           Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             mainAxisSize: MainAxisSize.max,
                //             children: [

                //               Icon(
                //                 Icons.payment,
                //                 color: ColorResources.purple,
                //                 size: 30.0,
                //               ),

                //               const SizedBox(width: 10.0),

                //               Text(Helper.formatCurrency(balanceModel.data.balance),
                //                 style: robotoRegular.copyWith(
                //                   fontSize: Dimensions.fontSizeDefault,
                //                   color: ColorResources.black
                //                 ),
                //               ),

                //             ],
                //           ),
                //           Text("Pilih",
                //             style: robotoRegular.copyWith(
                //               fontSize: Dimensions.fontSizeDefault,
                //               fontWeight: FontWeight.bold,
                //               color: ColorResources.black
                //             ),
                //           )
                //         ],
                //       )
                //     ),
                //   ),
                // ),

                // const Divider(
                //   thickness: 2.0,
                // ),
                                    
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

                        paymentLogo = payment.logo;
                        paymentName = payment.name;
                        paymentCode = payment.nameCode;
                        platform = payment.platform;
                        paymentFee = payment.fee;

                        notifyListeners();

                        NS.pop();
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  CachedNetworkImage(
                                    imageUrl: payment.logo,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fitHeight,
                                            image: imageProvider
                                          )
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(width: 10.0),

                                  Text(payment.name,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black
                                    ),
                                  ),

                                ],
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
      
      setStateGetPaymentChannelStatus(GetPaymentChannelStatus.error);

    }
  }

  Future<void> pay({
    required int amount,
    required int cost,
    required String from
  }) async {
    setStatePayStatus(PayStatus.loading);
    
    try {
      
      if(paymentCode == "gopay" || paymentCode == "shopee" || paymentCode == "ovo" || paymentCode == "dana") {

        ResponseMidtransEmoney responseMidtransEmoney = await er.EmoneyPay(
          amount: amount, 
          app: "saka", 
          from: from,
          channelId: channelId, 
          platform: platform,
          paymentCode: paymentCode
        );

        NS.pushReplacement(
          navigatorKey.currentContext!, 
          PaymentReceiptEmoney(
            amount: amount,
            cost: cost,
            type: paymentName,
            responseMidtransEmoneyData: responseMidtransEmoney.data,
          )
        );

      } else {
       
        ResponseMidtransVa responseMidtransVa = await er.pay(
          amount: amount, 
          app: "saka", 
          from: from,
          channelId: channelId, 
          platform: platform,
          paymentCode: paymentCode
        );

        NS.pushReplacement(
          navigatorKey.currentContext!, 
          PaymentReceiptVaScreen(
            responseMidtransVaData: responseMidtransVa.data,
            amount: amount,
            cost: cost,
          )
        );

      }

      channelId = -1;

      setStatePayStatus(PayStatus.loaded);
    } catch(e) {
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> howToPayment({required String channelId}) async {
    setStateHowToPayment(HowToPaymentStatus.loading);
    try {
      HowToPaymentModel howToPayment = await er.howToPayment(channelId: channelId);

      _atm = [];
      _atm.addAll(howToPayment.data.atm);

      _mbank = [];
      _mbank.addAll(howToPayment.data.mbank);

      _emoney = [];
      _emoney.addAll(howToPayment.data.emoney);

      setStateHowToPayment(HowToPaymentStatus.loaded);
    } catch(e) {
      setStateHowToPayment(HowToPaymentStatus.error);
    }
  }
 
  Future<void> payTopup() async {
     setStatePayStatus(PayStatus.loading);
    
    try {

      if(paymentCode == "gopay" || paymentCode == "shopee" || paymentCode == "ovo" || paymentCode == "dana") {

        ResponseMidtransEmoney responseMidtransEmoney = await er.EmoneyPayTopup(
          amount: selectedTopupPrice, 
          app: "saka", 
          channelId: channelId, 
          platform: platform,
          paymentCode: paymentCode
        );

        NS.pushReplacement(
          navigatorKey.currentContext!, 
          PaymentReceiptEmoney(
            amount: selectedTopupPrice,
            cost: 0,
            responseMidtransEmoneyData: responseMidtransEmoney.data,
            type: paymentName,
          )
        );

      } else {
       
        ResponseMidtransVa responseMidtransVa = await er.payTopup(
          amount: selectedTopupPrice, 
          app: "saka", 
          channelId: channelId, 
          platform: platform,
          paymentCode: paymentCode
        );

        NS.pushReplacement(
          navigatorKey.currentContext!, 
          PaymentReceiptVaScreen(
            amount: selectedTopupPrice,
            cost: 0,
            responseMidtransVaData: responseMidtransVa.data,
          )
        );

      }

      channelId = -1;

      setStatePayStatus(PayStatus.loaded);
    } catch(e) {
      setStatePayStatus(PayStatus.error);
    }
  } 

}