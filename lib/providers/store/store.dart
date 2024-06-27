import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/data/models/store/review_product_detail.dart';
import 'package:saka/data/models/feed/mediakey.dart';
import 'package:saka/data/models/store/bank_payment_store.dart';
import 'package:saka/data/models/store/booking_courier.dart';
import 'package:saka/data/models/store/checkout_cart.dart';
import 'package:saka/data/models/store/ninja.dart';
import 'package:saka/data/models/store/review_product.dart';
import 'package:saka/data/models/store/shipping_couriers.dart';
import 'package:saka/data/models/store/shipping_tracking.dart';
import 'package:saka/data/models/store/transaction_paid.dart';
import 'package:saka/data/models/store/transaction_paid_single.dart';
import 'package:saka/data/models/store/transaction_unpaid.dart';
import 'package:saka/data/models/store/product_single.dart';
import 'package:saka/data/models/store/cart_add.dart' as ca;
import 'package:saka/data/models/store/seller_store.dart' as ss;
import 'package:saka/data/models/store/category_product.dart';
import 'package:saka/data/models/store/cart_add.dart';
import 'package:saka/data/models/store/product_store.dart';
import 'package:saka/data/models/store/couriers.dart';

import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dio.dart';
import 'package:saka/utils/exceptions.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';
import 'package:saka/views/screens/store/delivery_buylive.dart';
import 'package:saka/views/screens/store/checkout_product.dart';
import 'package:saka/views/screens/store/seller_transaction_order.dart';
import 'package:saka/views/screens/store/buyer_transaction_order.dart';

enum BookingCourierStatus { idle, loading, loaded, empty, error}
enum CategoryProductByCategoryConsumenStatus { idle, loading, loaded, refetch, empty, error }
enum CategoryProductByCategorySellerStatus { idle, loading, loaded, refetch, empty, error }
enum CategoryProductStatus { idle, loading, loaded, refetch, empty, error } 
enum CategoryProductByParentStatus { loading, loaded, empty, error }
enum CreateStoreStatus { idle, loading, loaded, error, empty }
enum EditStoreStatus { idle, loading, loaded, empty, error }
enum SellerStoreStatus { idle, loading, loaded, empty, error }
enum CartStatus { idle, loading, loaded, empty, error }
enum DeleteProductStatus { idle, loading, loaded, error, empty }
enum PostAddCartStatus { idle, loading, loaded, error, empty }
enum PostCartCheckoutStatus { idle, loading, loaded, error, empty }
enum PostAddLiveBuyStatus { idle, loading, loaded, error, empty}
enum SingleProductStatus { idle, loading, loaded, error, empty }
enum CourierStatus { idle, loading, loaded, error, empty }
enum PickupTimeslotsStatus { idle, loading, loaded, error, empty }
enum DeliveryTimeslotsStatus { idle, loading, loaded, error, empty }
enum DimenstionStatus { idle, loading, loaded, error, empty }
enum PostEditDataProductStoreStatus { idle, loading, loaded, error, empty }
enum PostAddDataProductStoreStatus { idle, loading, loaded, error, empty }
enum ApproximatelyStatus { idle, loading, loaded, error, empty }
enum PostOrderPickingStatus { idle, loading, loaded, error, empty }
enum TransactionPaidSingleStatus { idle, loading, loaded, error, empty }
enum TransactionBuyerPaidStatus { idle, loading, loaded, error, empty }
enum TransactionSellerPaidStatus { idle, loading, loaded, error, empty }
enum TransactionUnpaidStatus { idle, loading, loaded, error, empty }
enum AllCategorySellerDetailStatus { idle, loading, loaded, error, empty }
enum AllProductSellerSearchStatus { idle, loading, loaded, error, empty }
enum AllProductSellerByCategoryStatus { idle, loading, loaded, error, empty }
enum AllProductSellerDetailStatus { idle, loading, loaded, error, empty }
enum ReviewProductListStatus { idle, loading, loaded, error, empty }
enum ReviewProductStatus { idle, loading, loaded, error, empty }
enum PostOrderDoneStatus { idle, loading, loaded, error, empty }
enum PostDataReviewProductStatus { idle, loading, loaded, error, empty }

class StoreProvider with ChangeNotifier {

  String _idCategory = "all";
  String get idCategory => _idCategory;

  int _packingCount = 0;
  int get packingCount => _packingCount;
  int _pickupCount = 0;
  int get pickupCount => _pickupCount;
  int _shippingCount = 0;
  int get shippingCount => _shippingCount;
  int _deliveredCount = 0;
  int get deliveredCount => _deliveredCount;
  int _doneCount = 0;
  int get doneCount => _doneCount;

  int _pageProductConsumen = 0;
  int get pageProductConsumen => _pageProductConsumen;

  int _pageListProduct = 0;
  int get pageListProduct => _pageListProduct;

  String? _descStore = "";
  String? get descStore => _descStore;
   
  String? _descAddSellerStore = "";
  String? get descAddSellerStore => _descAddSellerStore;

  String? _descEditSellerStore = "";
  String? get descEditSellerStore => _descEditSellerStore;

  String? _categoryAddProductTitle = "";
  String? get categoryAddProductTitle => _categoryAddProductTitle!;

  String? _categoryAddProductId = "";
  String? get categoryAddProductId => _categoryAddProductId!;

  String? _categoryEditProductTitle = "";
  String? get categoryEditProductTitle => _categoryEditProductTitle!;

  String? _categoryEditProductId = "";
  String? get categoryEditProductId => _categoryEditProductId!;

  BookingCourierStatus _bookingCourierStatus = BookingCourierStatus.idle;
  BookingCourierStatus get bookingCourierStatus => _bookingCourierStatus;

  AllProductSellerSearchStatus _allProductSellerSearchStatus = AllProductSellerSearchStatus.empty;
  AllProductSellerSearchStatus get allProductSellerSearchStatus => _allProductSellerSearchStatus;

  AllProductSellerByCategoryStatus _allProductSellerByCategoryStatus = AllProductSellerByCategoryStatus.idle;
  AllProductSellerByCategoryStatus get allProductSellerByCategoryStatus => _allProductSellerByCategoryStatus;

  AllCategorySellerDetailStatus _allCategorySellerDetailStatus = AllCategorySellerDetailStatus.idle;
  AllCategorySellerDetailStatus get allCategorySellerDetailStatus => _allCategorySellerDetailStatus;

  AllProductSellerDetailStatus _allProductSellerDetailStatus = AllProductSellerDetailStatus.idle;
  AllProductSellerDetailStatus get allProductSellerDetailStatus => _allProductSellerDetailStatus;

  ReviewProductListStatus _reviewProductListStatus = ReviewProductListStatus.idle;
  ReviewProductListStatus get reviewProductListStatus => _reviewProductListStatus;

  ReviewProductStatus _reviewProductStatus = ReviewProductStatus.idle;
  ReviewProductStatus get reviewProductStatus => _reviewProductStatus;

  PostDataReviewProductStatus _postDataReviewProductStatus = PostDataReviewProductStatus.idle;
  PostDataReviewProductStatus get postDataReviewProductStatus => _postDataReviewProductStatus;

  EditStoreStatus _editStoreStatus = EditStoreStatus.idle;
  EditStoreStatus get editStoreStatus => _editStoreStatus;

  CategoryProductStatus _categoryProductStatus = CategoryProductStatus.loading;
  CategoryProductStatus get categoryProductStatus => _categoryProductStatus;

  CreateStoreStatus _createStoreStatus = CreateStoreStatus.idle;
  CreateStoreStatus get createStoreStatus => _createStoreStatus;

  CartStatus _cartStatus = CartStatus.loading;
  CartStatus get cartStatus => _cartStatus;

  PostCartCheckoutStatus _postCartCheckoutStatus = PostCartCheckoutStatus.idle;
  PostCartCheckoutStatus get postCartCheckoutStatus => _postCartCheckoutStatus;

  PostAddCartStatus _postAddCartStatus = PostAddCartStatus.idle;
  PostAddCartStatus get postAddCartStatus => _postAddCartStatus;

  PostAddLiveBuyStatus _postAddLiveBuyStatus = PostAddLiveBuyStatus.idle;
  PostAddLiveBuyStatus get postAddLiveBuyStatus => _postAddLiveBuyStatus;

  DeleteProductStatus _deleteProductStatus = DeleteProductStatus.idle;
  DeleteProductStatus get deleteProductStatus => _deleteProductStatus;

  SingleProductStatus _singleProductStatus = SingleProductStatus.idle;
  SingleProductStatus get singleProductStatus => _singleProductStatus;

  SellerStoreStatus _sellerStoreStatus = SellerStoreStatus.loading;
  SellerStoreStatus get sellerStoreStatus => _sellerStoreStatus; 
   
  CourierStatus _courierStatus = CourierStatus.loading;
  CourierStatus get courierStatus => _courierStatus;

  PickupTimeslotsStatus _pickupTimeslotsStatus = PickupTimeslotsStatus.loading;
  PickupTimeslotsStatus get pickupTimeslotsStatus => _pickupTimeslotsStatus; 

  PostEditDataProductStoreStatus _postEditDataProductStoreStatus = PostEditDataProductStoreStatus.idle;
  PostEditDataProductStoreStatus get postEditDataProductStoreStatus => _postEditDataProductStoreStatus;

  PostAddDataProductStoreStatus _postAddDataProductStoreStatus = PostAddDataProductStoreStatus.idle;
  PostAddDataProductStoreStatus get postAddDataProductStoreStatus => _postAddDataProductStoreStatus;

  PostOrderPickingStatus _postOrderPickingStatus = PostOrderPickingStatus.idle;
  PostOrderPickingStatus get postOrderPickingStatus => _postOrderPickingStatus;

  DeliveryTimeslotsStatus _deliveryTimeslotsStatus = DeliveryTimeslotsStatus.loading;
  DeliveryTimeslotsStatus get deliveryTimeslotsStatus => _deliveryTimeslotsStatus;

  DimenstionStatus _dimenstionStatus = DimenstionStatus.loading;
  DimenstionStatus get dimenstionStatus => _dimenstionStatus;

  ApproximatelyStatus _approximatelyStatus = ApproximatelyStatus.loading;
  ApproximatelyStatus get approximatelyStatus => _approximatelyStatus; 

  TransactionPaidSingleStatus _transactionPaidSingleStatus = TransactionPaidSingleStatus.loading;
  TransactionPaidSingleStatus get transactionPaidSingleStatus => _transactionPaidSingleStatus;

  TransactionUnpaidStatus _transactionUnpaidStatus = TransactionUnpaidStatus.loading;
  TransactionUnpaidStatus get transactionUnpaidStatus => _transactionUnpaidStatus;

  TransactionBuyerPaidStatus _transactionBuyerPaidStatus = TransactionBuyerPaidStatus.loading;
  TransactionBuyerPaidStatus get transactionBuyerPaidStatus => _transactionBuyerPaidStatus;

  TransactionSellerPaidStatus _transactionSellerPaidStatus = TransactionSellerPaidStatus.loading;
  TransactionSellerPaidStatus get transactionSellerPaidStatus => _transactionSellerPaidStatus;

  CategoryProductByParentStatus _categoryProductByParentStatus = CategoryProductByParentStatus.loading;
  CategoryProductByParentStatus get categoryProductByParentStatus => _categoryProductByParentStatus; 

  CategoryProductByCategoryConsumenStatus _categoryProductByCategoryConsumenStatus = CategoryProductByCategoryConsumenStatus.loading;
  CategoryProductByCategoryConsumenStatus get categoryProductByCategoryConsumenStatus => _categoryProductByCategoryConsumenStatus;

  CategoryProductByCategorySellerStatus _categoryProductByCategorySellerStatus = CategoryProductByCategorySellerStatus.loading;
  CategoryProductByCategorySellerStatus get categoryProductByCategorySellerStatus => _categoryProductByCategorySellerStatus;

  ProductSingleStoreModel _productSingleStoreModel = ProductSingleStoreModel();
  ProductSingleStoreModel get productSingleStoreModel => _productSingleStoreModel;

  PostOrderDoneStatus _postOrderDoneStatus = PostOrderDoneStatus.idle;
  PostOrderDoneStatus get postOrderDoneStatus => _postOrderDoneStatus;

  List<Map<String, Object>> assignCampaignListProduct = [];
  List<String> isCheckedKurir = [];

  List categoryHasManyProduct = []; 
  List<CategoryProductList> categoryProductList = [];

  List<CategoryProductList> _allCategorySellerDetail = [];
  List<CategoryProductList> get allCategorySellerDetail => [..._allCategorySellerDetail];
  
  List<ProductStoreList> _productStoreList = [];
  List<ProductStoreList> get productStoreList => [..._productStoreList];

  List<ProductStoreList> _allProductSearch = [];
  List<ProductStoreList> get allProductSearch => [..._allProductSearch];

  List<ProductStoreList> _allProductSellerDetail = [];
  List<ProductStoreList> get allProductSellerDetail => [..._allProductSellerDetail];

  List<ProductStoreList> _productStoreConsumenList = [];
  List<ProductStoreList> get productStoreConsumenList => [..._productStoreConsumenList];
  
  List<CategoryProductList> _categoryProductByParentList = [];
  List<CategoryProductList> get categoryProductByParentList => [..._categoryProductByParentList];
  
  List<ca.StoreElement> _cartStores = [];
  List<ca.StoreElement> get cartStores => [..._cartStores];

  List<CouriersModelList> _couriersModelList = [];
  List<CouriersModelList> get couriersModelList => [..._couriersModelList];

  List<ReviewProductList> _rpl = [];
  List<ReviewProductList> get rpl => [..._rpl];

  List _pickupTimeslots = [];
  List get pickupTimeslots => [..._pickupTimeslots];

  List _deliveryTimeslots = [];
  List get deliveryTimeslots => [..._deliveryTimeslots];

  List _approximatelyVolumes = [];
  List get approximatelyVolumes => [..._approximatelyVolumes];

  String? dataDatePickup = DateTime.now().toIso8601String();

  List _dimensionsSize = [];
  List get dimensionsSize => [..._dimensionsSize];

  String _dataPickupTimeslots = "";
  String get dataPickupTimeslots => _dataPickupTimeslots;

  String _dataDeliveryTimeslots = "";
  String get dataDeliveryTimeslots => _dataDeliveryTimeslots;

  String _dataDimensionsSize = "";
  String get dataDimensionsSize => _dataDimensionsSize;

  String _dataApproximatelyVolumes = "";
  String get dataApproximatelyVolumes => _dataApproximatelyVolumes;
  
  int _dataDimensionsHeight = 0;
  int get dataDimensionsHeight => _dataDimensionsHeight;

  int _dataDimensionsLength = 0;
  int get dataDimensionsLength => _dataDimensionsLength;

  int _dataDimensionsWidth = 0;
  int get dataDimensionsWidth => _dataDimensionsWidth;

  ca.CartData _cartData = ca.CartData();
  ca.CartData get cartData => _cartData;

  List<StoreElement> get cartProductStoresActive => cartData.stores!.where((el) => el.isActive == true).toList();

  ReviewProductDetailModel _rpdm = ReviewProductDetailModel();
  ReviewProductDetailModel get rpdm => _rpdm;

  TransactionStorePaidModel _tspmReceive = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmReceive => _tspmReceive;

  TransactionStorePaidModel _tspmPacking = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmPacking => _tspmPacking;

  TransactionStorePaidModel _tspmPickup = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmPickup => _tspmPickup;

  TransactionStorePaidModel _tspmPickupShipping = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmPickupShipping => _tspmPickupShipping;

  TransactionStorePaidModel _tspmDelivered = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmDelivered => _tspmDelivered;

  TransactionStorePaidModel _tspmDone = TransactionStorePaidModel();
  TransactionStorePaidModel get tspmDone => _tspmDone;

  TransactionStoreUnpaidModel _tsum = TransactionStoreUnpaidModel();
  TransactionStoreUnpaidModel get tsum => _tsum;

  TransactionPaidSingle _tps = TransactionPaidSingle();
  TransactionPaidSingle get tps => _tps;

  ss.SellerStoreModel _sellerStoreModel = ss.SellerStoreModel();
  ss.SellerStoreModel get sellerStoreModel => _sellerStoreModel;

  void setStateBookingCourierStatus(BookingCourierStatus bookingCourierStatus) {
    _bookingCourierStatus = bookingCourierStatus;
    Future.delayed(Duration.zero);
  }

  void setStateTransactionPaidSingleStatus(TransactionPaidSingleStatus transactionPaidSingleStatus) {
    _transactionPaidSingleStatus = transactionPaidSingleStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus transactionBuyerPaidStatus) {
    _transactionBuyerPaidStatus = transactionBuyerPaidStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus transactionSellerPaidStatus) {
    _transactionSellerPaidStatus = transactionSellerPaidStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateTransactionUnpaidStatus(TransactionUnpaidStatus transactionUnpaidStatus) {
    _transactionUnpaidStatus = transactionUnpaidStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostCartCheckoutStatus(PostCartCheckoutStatus postCartCheckoutStatus) {
    _postCartCheckoutStatus = postCartCheckoutStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostAddCartStatus(PostAddCartStatus postAddCartStatus) {
    _postAddCartStatus = postAddCartStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostAddLiveBuySttus(PostAddLiveBuyStatus postAddLiveBuyStatus) {
    _postAddLiveBuyStatus = postAddLiveBuyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus categoryProductByCategoryConsumenStatus) {
    _categoryProductByCategoryConsumenStatus = categoryProductByCategoryConsumenStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus categoryProductByCategorySellerStatus) {
    _categoryProductByCategorySellerStatus = categoryProductByCategorySellerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCategoryProductParentStatus(CategoryProductByParentStatus categoryProductByParentStatus) {
    _categoryProductByParentStatus = categoryProductByParentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  void setStateCategoryProductStatus(CategoryProductStatus categoryProductStatus) {
    _categoryProductStatus = categoryProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());  
  }

  void setStateDeleteProductStatus(DeleteProductStatus deleteProductStatus) {
    _deleteProductStatus = deleteProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());  
  }
 
  void setStateCartStatus(CartStatus cartStatus) {
    _cartStatus = cartStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCreateStoreStatus(CreateStoreStatus createStoreStatus) {
    _createStoreStatus = createStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleProductStatus(SingleProductStatus singleProductStatus) {
    _singleProductStatus = singleProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostDataReviewProductStatus(PostDataReviewProductStatus postDataReviewProductStatus) {
    _postDataReviewProductStatus = postDataReviewProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateReviewDataStatus(ReviewProductStatus reviewProductStatus) {
    _reviewProductStatus = reviewProductStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  void setStateSellerStoreStatus(SellerStoreStatus sellerStoreStatus) { 
    _sellerStoreStatus = sellerStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateCourierStatus(CourierStatus courierStatus) {
    _courierStatus = courierStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePickupTimeslotsStatus(PickupTimeslotsStatus pickupTimeslotsStatus) {
    _pickupTimeslotsStatus = pickupTimeslotsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus deliveryTimeslotsStatus) {
    _deliveryTimeslotsStatus = deliveryTimeslotsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostOrderPickingStatus(PostOrderPickingStatus postOrderPickingStatus) {
    _postOrderPickingStatus = postOrderPickingStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDimenstionStatus(DimenstionStatus dimenstionStatus) {
    _dimenstionStatus = dimenstionStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateApproximatelyVolumesStatus(ApproximatelyStatus approximatelyStatus) {
    _approximatelyStatus = approximatelyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEditStoreStatus(EditStoreStatus editStoreStatus) {
    _editStoreStatus = editStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostAddDataProductStore(PostAddDataProductStoreStatus postAddDataProductStoreStatus) {
    _postAddDataProductStoreStatus = postAddDataProductStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostEditDataProductStore(PostEditDataProductStoreStatus postEditDataProductStoreStatus) {
    _postEditDataProductStoreStatus = postEditDataProductStoreStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAllProductSellerSearchStatus(AllProductSellerSearchStatus allProductSellerSearchStatus) {
    _allProductSellerSearchStatus = allProductSellerSearchStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAllProductSellerByCategoryStatus(AllProductSellerByCategoryStatus allProductSellerByCategoryStatus) {
    _allProductSellerByCategoryStatus = allProductSellerByCategoryStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus allCategorySellerDetailStatus) {
    _allCategorySellerDetailStatus = allCategorySellerDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus allProductSellerDetailStatus) {
    _allProductSellerDetailStatus = allProductSellerDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateReviewProductListStatus(ReviewProductListStatus reviewProductListStatus) {
    _reviewProductListStatus = reviewProductListStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeIdCategory({required String val}) {
    _idCategory = val;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void resetPageListProduct() {
    _pageListProduct = 0;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostOrderDoneStatus(PostOrderDoneStatus postOrderDoneStatus) {
    _postOrderDoneStatus = postOrderDoneStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void cartDataIsActive(bool? isActive) {
    cartData.isActive = isActive;
    if(isActive!) {
      int qtyTemp = 0;
      int priceTemp = 0;
      for (ca.StoreElement storeElement in cartData.stores!) {  
        for (ca.StoreElementItem storeElementItem in storeElement.items!) {
          qtyTemp += storeElementItem.quantity!;
          priceTemp += storeElementItem.price!.toInt() * storeElementItem.quantity!;
          cartData.numOfItems = qtyTemp;
          cartData.totalProductPrice = (priceTemp).toDouble();
        }
      }
    } else {
      cartData.totalProductPrice = 0.0;
      cartData.numOfItems = 0;
    }
    for (ca.StoreElement storeElement in cartData.stores!) {  
      storeElement.isActive = isActive;
      for (ca.StoreElementItem storeElementItem in storeElement.items!) {
        storeElementItem.isActive = isActive;
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void cartStoreElementIsActive(bool? isActive, int idx) {
    cartData.isActive = isActive;
    if(isActive!) {
      int qtyTemp = 0;
      int priceTemp = 0;
      for (ca.StoreElement storeElement in cartData.stores!) {  
        for (ca.StoreElementItem storeElementItem in storeElement.items!) {
          qtyTemp += storeElementItem.quantity!;
          priceTemp += storeElementItem.price!.toInt() * storeElementItem.quantity!;
          cartData.numOfItems = qtyTemp;
          cartData.totalProductPrice = (priceTemp).toDouble();
        }
      }
    } else {
      cartData.totalProductPrice = 0.0;
      cartData.numOfItems = 0;
    }
    cartData.stores![idx].isActive = isActive;
    for (ca.StoreElementItem sei in cartData.stores![idx].items!) {
      sei.isActive = isActive;
    }
    int qtyTemp = 0;
    int priceTemp = 0;
    for (ca.StoreElement storeElement in cartData.stores!.where((el) => el.isActive == true)) {  
      for (ca.StoreElementItem storeElementItem in storeElement.items!.where((el) => el.isActive == true)) {
        qtyTemp += storeElementItem.quantity!;
        priceTemp += storeElementItem.price!.toInt() * storeElementItem.quantity!;
        cartData.numOfItems = qtyTemp;
        cartData.totalProductPrice = (priceTemp).toDouble();
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void cartStoreElementItemIsActive(bool? isActive, int storeElementIdx, int storeElementItemIdx) {
    if(cartData.stores![storeElementIdx].items!.where((el) => el.isActive == true).length == 1) {
      if(isActive!) {
        int qtyTemp = 0;
        int priceTemp = 0;
        for (ca.StoreElement storeElement in cartData.stores!) {  
          for (ca.StoreElementItem storeElementItem in storeElement.items!) {
            qtyTemp += storeElementItem.quantity!;
            priceTemp += storeElementItem.price!.toInt() * storeElementItem.quantity!;
            cartData.numOfItems = qtyTemp;
            cartData.totalProductPrice = (priceTemp).toDouble();
          }
        }
      } else {
        cartData.totalProductPrice = 0.0;
        cartData.numOfItems = 0;
      }
      cartData.isActive = isActive;
      cartData.stores![storeElementIdx].isActive = isActive;
      cartData.stores![storeElementIdx].items![storeElementItemIdx].isActive = isActive;
    } else {
      if(cartData.stores![storeElementIdx].items!.every((el) => el.isActive == false)) {
        cartData.stores![storeElementIdx].isActive = isActive;
        cartData.stores![storeElementIdx].items![storeElementItemIdx].isActive = isActive;
      } else {
        cartData.stores![storeElementIdx].items![storeElementItemIdx].isActive = isActive;
      }
    }
    int qtyTemp = 0;
    int priceTemp = 0;
    for (ca.StoreElement storeElement in cartData.stores!.where((el) => el.isActive == true)) {  
      for (ca.StoreElementItem storeElementItem in storeElement.items!.where((el) => el.isActive == true)) {
        qtyTemp += storeElementItem.quantity!;
        priceTemp += storeElementItem.price!.toInt() * storeElementItem.quantity!;
        cartData.numOfItems = qtyTemp;
        cartData.totalProductPrice = (priceTemp).toDouble();
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }
 
  Future<void> getDataStore(BuildContext context) async {
    setStateSellerStoreStatus(SellerStoreStatus.loading); 
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/seller/store/fetch");
      Map<String, dynamic> data = res.data;

      if(res.data["code"] == 404) {     
        setStateSellerStoreStatus(SellerStoreStatus.empty); 
        throw CustomException(404);
      } 
      if(res.data["code"] == 500) {
         setStateSellerStoreStatus(SellerStoreStatus.error); 
        throw CustomException(500);
      } 
      _sellerStoreModel = ss.SellerStoreModel.fromJson(data);
      _descStore = sellerStoreModel.body!.description;
      setStateSellerStoreStatus(SellerStoreStatus.loaded);
      return compute(parseGetDataStore, data);
    } on DioError catch(e) {
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Store)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateSellerStoreStatus(SellerStoreStatus.error);
    } on CustomException catch(e)  {
      if(int.parse(e.toString()) == 404) {
        _sellerStoreModel = ss.SellerStoreModel(
          code: 404,
          body: ss.ResultSingleStore(
            address: "",
            city: "",
            classId: "",
            description: "",
            email: "",
            id: "",
            name: "",
            open: false,
            owner: "",
            phone: "",
            picture: ss.Picture(),
            postalCode: "",
            province: "",
            status: 0,
            subDistrict: "",
            supportedCouriers: [],
            village: "",
            location: [],
          ),
          message: "Data Not Found"
        );
        setStateSellerStoreStatus(SellerStoreStatus.empty);
      }
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Get Data Store)");
        setStateSellerStoreStatus(SellerStoreStatus.error);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateSellerStoreStatus(SellerStoreStatus.error);
    }
  }

  Future<void> postCreateDataStore(
    BuildContext context,
    File file, 
    String nameStore, 
    String province, 
    String city, 
    String village, 
    String postalCode, 
    String address, 
    String subDistrict,
    String email, 
    String phone, 
    [String deskripsi = ""]
  ) async {
    setStateCreateStoreStatus(CreateStoreStatus.loading);
    Map<String, dynamic> dataObj = {
      "name": nameStore,
      "picture": {
        "originalName": basename(file.path),
        "fileLength": file.lengthSync(),
        "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(file.path)}",
        "contentType": lookupMimeType(basename(file.path))
      },
      "province": province,
      "city": city,
      "postalCode": postalCode,
      "village": village, 
      "address": address,
      "subdistrict": subDistrict,
      "email": email, 
      "phone": phone,
      "location": [context.read<LocationProvider>().getCurrentLng, context.read<LocationProvider>().getCurrentLat],
      "supportedCouriers": isCheckedKurir
    };
    if (deskripsi.trim().isNotEmpty) {
      dataObj.addAll({"description": deskripsi});
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/seller/store/create", data: dataObj);
      setStateCreateStoreStatus(CreateStoreStatus.loaded);
      ShowSnackbar.snackbar(context, "Selamat! Toko Anda berhasil dibuka", "", ColorResources.success);
      getDataStore(context);
      NS.push(context, DashboardScreen());
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Create Data Store)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateCreateStoreStatus(CreateStoreStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCreateStoreStatus(CreateStoreStatus.error);
    }
  }

  Future<void> postEditDataStore(
    BuildContext context,
    String idStore, 
    String nameStore, 
    String province, 
    String city, 
    String subDistrict,
    String village,
    String postalCode, 
    String address,  
    String email,
    String phone,
    bool statusToko, [File? file]) async {
    setStateEditStoreStatus(EditStoreStatus.loading);
    Map<String, dynamic> data = {
      "id": idStore,
      "name": nameStore,
      "description": descStore,
      "province": province,
      "city": city,
      "subdistrict": subDistrict,
      "village": village,
      "postalCode": postalCode,
      "email": email,
      "phone": phone,
      "address": address,
      "supportedCouriers": isCheckedKurir,
      "open": statusToko,
      "location": [
        context.read<LocationProvider>().getCurrentLng, 
        context.read<LocationProvider>().getCurrentLat
      ],
    };
    if (file != null) {
      data.addAll({
        "picture": {
          "originalName": basename(file.path),
          "fileLength": file.lengthSync(),
          "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(file.path)}",
          "contentType": lookupMimeType(basename(file.path)),
          "classId": "media"
        }
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/seller/store/update", data: data);
      NS.pop(context);
      setStateEditStoreStatus(EditStoreStatus.loaded);
      getDataStore(context);
      ShowSnackbar.snackbar(context, "Toko berhasil diubah", "", ColorResources.success);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Edit Data Store)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateEditStoreStatus(EditStoreStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEditStoreStatus(EditStoreStatus.error);
    }
  }

  Future<void> getDataCategoryProduct(BuildContext context, String typeProduct) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/$typeProduct/product/categories");
      Map<String, dynamic> data = res.data;
      CategoryProductModel cpm = CategoryProductModel.fromJson(data);
      
      if(res.data['code'] == 404) {
        throw CustomException(404);
      } 
      if(res.data['code'] == 500) {
        throw CustomException(500);
      } 

      if(cpm.body!.isEmpty) {
        setStateCategoryProductStatus(CategoryProductStatus.empty);
      }

      if(categoryHasManyProduct.length != cpm.body!.length || categoryProductStatus == CategoryProductStatus.refetch) {
        List<Map<String, dynamic>> categoryHasManyProductAssign = [];
        categoryProductList = [];
        categoryProductList.addAll(cpm.body!);
        for (CategoryProductList item in cpm.body!) {
          await getDataProductByCategoryConsumen(context, "", item.id!);
          categoryHasManyProductAssign.add({
            "id": item.id,
            "category": item.name,
            "items": productStoreConsumenList,    
          });
        }
        categoryHasManyProduct = categoryHasManyProductAssign;
        setStateCategoryProductStatus(CategoryProductStatus.loaded);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Category Product)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateCategoryProductStatus(CategoryProductStatus.error);
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 404) {
        setStateCategoryProductStatus(CategoryProductStatus.empty);
      }
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Get Data Category Product)");
        setStateCategoryProductStatus(CategoryProductStatus.error);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getDataCategoryProductByParent(BuildContext context, String typeProduct) async {
    setStateCategoryProductParentStatus(CategoryProductByParentStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/$typeProduct/product/categories?parentId=$idCategory");
      CategoryProductModel categoryProductModel = CategoryProductModel.fromJson(res.data);
      _categoryProductByParentList = [];
      List<CategoryProductList> categoryProductByParentList = categoryProductModel.body!;
      _categoryProductByParentList.addAll(categoryProductByParentList);
      setStateCategoryProductParentStatus(CategoryProductByParentStatus.loaded);
      if(categoryProductByParentList.isEmpty) {
        setStateCategoryProductParentStatus(CategoryProductByParentStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Category Product By Parent)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCategoryProductParentStatus(CategoryProductByParentStatus.error);
    }
  }

  Future<void> getAllProductByCategorySellerDetail(
    BuildContext context, 
    String categoryId,
    String storeId
  ) async {
    setStateAllProductSellerByCategoryStatus(AllProductSellerByCategoryStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=$categoryId&page=0&sort=created,desc");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _allProductSellerDetail = [];
      List<ProductStoreList> psl = psm.body!.where((el) => el.store!.id == storeId).toList();
      _allProductSellerDetail.addAll(psl);
      setStateAllProductSellerByCategoryStatus(AllProductSellerByCategoryStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get All Product By Category Seller Detail)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateAllProductSellerByCategoryStatus(AllProductSellerByCategoryStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateAllProductSellerByCategoryStatus(AllProductSellerByCategoryStatus.error);
    }
  }

  Future<void> getAllSearchProductSellerDetail(BuildContext context, 
    String nameProduct, int page, 
    String storeId
  ) async {
    ProgressDialog pr = ProgressDialog(context: context);
    pr.show(
      max: 2,
      msg: "Mohon Tunggu...",
      borderRadius: 10.0,
      backgroundColor: ColorResources.white,
    );
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=all&page=0&size=10&sort=created,desc&search=$nameProduct");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _allProductSearch = [];
      List<ProductStoreList> psl = psm.body!.where((el) => el.store!.id == storeId).toList();
      Future.delayed(const Duration(seconds: 2)).then((value) {
        pr.close();
        if(psl.isNotEmpty) {
          _allProductSearch.addAll(psl);
          setStateAllProductSellerSearchStatus(AllProductSellerSearchStatus.loaded);
        } else {
          _allProductSearch.clear();
          setStateAllProductSellerSearchStatus(AllProductSellerSearchStatus.empty);
        }
      });
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get All Search Product Seller Detail)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      pr.close();
      setStateAllProductSellerSearchStatus(AllProductSellerSearchStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      pr.close();
      setStateAllProductSellerSearchStatus(AllProductSellerSearchStatus.error);
    }
  }

  Future<void> getAllCategorySellerDetail(BuildContext context) async {
    setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/categories");
      Map<String, dynamic> data = res.data;
      CategoryProductModel cpm = CategoryProductModel.fromJson(data);
      _allCategorySellerDetail = [];
      List<CategoryProductList> cpl = cpm.body!;
      _allCategorySellerDetail.addAll(cpl);
      setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus.loaded);
      if(allCategorySellerDetail.isEmpty) {
        setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus.empty);
      }
     } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get All Category Seller Detail)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateAllCategorySellerDetailStatus(AllCategorySellerDetailStatus.error);
    }
  }

  Future<void> getAllProductSellerDetail(BuildContext context, String storeId) async {
    setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=all&page=0&sort=stock,desc");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _allProductSellerDetail = [];
      List<ProductStoreList> lpsl = psm.body!.where((el) => el.store!.id == storeId).toList();
      _allProductSellerDetail.addAll(lpsl);
      setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus.loaded);
      if(allProductSellerDetail.isEmpty) {
        setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get All Product Seller Detail)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateAllProductSellerDetailStatus(AllProductSellerDetailStatus.error);
    }
  }

  Future<void> getDataProductByCategoryConsumen(BuildContext context, String name, String idCategory) async {
    setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=$idCategory&search=$name&page=0&size=10&sort=stock,desc");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _productStoreConsumenList = [];
      List<ProductStoreList> psl = psm.body!;
      _productStoreConsumenList.addAll(psl);
      setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Product By Category Consumen)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus.error);
    }
  }

  Future<void> getDataProductByCategoryConsumenLoad(BuildContext context, String name, String idCategory) async {
    _pageProductConsumen++;
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=$idCategory&search=$name&page=$pageProductConsumen&size=10&sort=stock,desc");
      ProductStoreModel productStoreModel = ProductStoreModel.fromJson(res.data);
      _productStoreConsumenList.addAll(productStoreModel.body!);
      setStateCategoryProductByConsumenStatus(CategoryProductByCategoryConsumenStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Product By Category Consumen Load)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getDataSearchProduct(BuildContext context, String nameProduct, int page) async {
    ProgressDialog pr = ProgressDialog(context: context);
    pr.show(
      max: 2,
      msg: "Mohon Tunggu...",
      borderRadius: 10.0,
      backgroundColor: ColorResources.white,
    );
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/product/filter?categoryId=all&page=0&size=10&sort=created,desc&search=$nameProduct");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _allProductSearch = [];
      List<ProductStoreList> psl = psm.body!;
      Future.delayed(const Duration(seconds: 2)).then((value) {
        pr.close();
        if(psl.isNotEmpty) {
          _allProductSearch.addAll(psl);
          Future.delayed(Duration.zero, () => notifyListeners());
        } else {
          _allProductSearch.clear();
          Future.delayed(Duration.zero, () => notifyListeners());
        }
      });
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Search Product)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      pr.close();
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      pr.close();
    }
  }

  Future<void> getDataProductByCategorySeller(BuildContext context) async {
    setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/seller/product/filter?categoryId=$idCategory&page=$pageListProduct&size=10&sort=stock,desc");
      Map<String, dynamic> data = res.data;
      ProductStoreModel psm = ProductStoreModel.fromJson(data);
      _productStoreList = [];
      List<ProductStoreList> psl = psm.body!;
      _productStoreList.addAll(psl); 
      setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.loaded);
      if(productStoreList.isEmpty) {
        setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Product By Category Seller)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.error);
    }
  }

  Future<void> getDataProductByCategorySellerLoad(BuildContext context) async {
    _pageListProduct++;
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/seller/product/filter?categoryId=$idCategory&page=$pageListProduct&size=10&sort=stock,desc");
      ProductStoreModel psm = ProductStoreModel.fromJson(res.data);
      List<ProductStoreList> psl = psm.body!;
      _productStoreList.addAll(psl); 
      setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.loaded);
      if(productStoreList.isEmpty) {
        setStateCategoryProductBySellerStatus(CategoryProductByCategorySellerStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Product By Category Seller Load)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getDataSingleProduct(BuildContext context, String idProduct, String path, String typeProduct) async {
    setStateSingleProductStatus(SingleProductStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/$typeProduct/product$path/$idProduct");
      
      if(res.data['code'] == 404) {
        setStateSingleProductStatus(SingleProductStatus.empty);
        throw CustomException(404);
      }
      if(res.data['code'] == 500) {
        throw CustomException(500);
      }
      
      Map<String, dynamic> data = res.data;
      ProductSingleStoreModel pssm = ProductSingleStoreModel.fromJson(data);
      _productSingleStoreModel = pssm;
      setStateSingleProductStatus(SingleProductStatus.loaded);

      getDataProductByCategoryConsumen(context, productSingleStoreModel.body!.name!, productSingleStoreModel.body!.category!.id!);

      _descEditSellerStore = productSingleStoreModel.body?.description;

      _categoryEditProductId = productSingleStoreModel.body?.category?.id;
      _categoryEditProductTitle = productSingleStoreModel.body?.category?.name;

    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Single Product)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 404) {
        setStateSingleProductStatus(SingleProductStatus.empty);
      }
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Get Data Single Product)");
        getDataSingleProduct(context, idProduct, path, typeProduct);
        setStateSingleProductStatus(SingleProductStatus.error);
      } 
      setStateSingleProductStatus(SingleProductStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateSingleProductStatus(SingleProductStatus.error);
    }
  }

  Future<String?> getMediaKey(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("");
      final MediaKey mediaKey = MediaKey.fromJson(res.data);
      return mediaKey.body;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Media Key)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return "";
  }

  Future<Response?> uploadImageProduct(BuildContext context, String mediaKey, String base64, File file) async {
    try {
      Dio dio = Dio();
      String url = "-/$mediaKey/$base64?path=/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(file.path)}";
      Response res = await dio.post(url, data: file.readAsBytesSync());
      return res;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Upload Image Product)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  Future<void> postDataProductStore(BuildContext context, String nameProduct, int price, List<File> files, int weight, int stock, String condition, List<dynamic> kindStuffSelected, int minOrder, String idStore) async {
    List<Map<String, Object>> postsPictures = [];
    for (int i = 0; i < files.length; i++) {
      postsPictures.add({
        "originalName": basename(files[i].path),
        "fileLength": files[i].lengthSync(),
        "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(files[i].path)}",
        "contentType": lookupMimeType(basename(files[i].path))!
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/seller/product/create", data: {
        "name": nameProduct,
        "categoryId": categoryAddProductId,
        "price": price,
        "pictures": postsPictures,
        "weight": weight,
        "description": descAddSellerStore,
        "stock": stock,
        "condition": condition,
        "minOrder": minOrder,
        "harmful" : kindStuffSelected.contains(0),
        "flammable" : kindStuffSelected.contains(1),
        "liquid" : kindStuffSelected.contains(2),
        "fragile" : kindStuffSelected.contains(3),
      });
      _categoryAddProductId = "";
      _categoryAddProductTitle = "";
      _descAddSellerStore = "";
      
      setStatePostAddDataProductStore(PostAddDataProductStoreStatus.loaded);
      ShowSnackbar.snackbar(context, "Produk telah ditambahkan", "", ColorResources.success);
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 1;
      });
      getDataProductByCategorySeller(context);
      getDataCategoryProduct(context, "commerce");
      setStateCategoryProductStatus(CategoryProductStatus.refetch);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Data Product Store)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePostAddDataProductStore(PostAddDataProductStoreStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePostAddDataProductStore(PostAddDataProductStoreStatus.error);
    }
  }

  Future<void> postEditDataProductStore(BuildContext context, 
    String idProduct, String nameProduct, int price, List<File>? files,
    int weight, int stock, String condition, int minOrder, 
    List<dynamic> kindStuffSelected
  ) async {
    if (files != null || files!.isNotEmpty) {
      List<Map<String, Object>> postsPictures = [];
      for (int i = 0; i < files.length; i++) {
        if(files[i].path.split("/")[1] != "commerce") {
          postsPictures.add({
            "originalName": basename(files[i].path),
            "fileLength": files[i].lengthSync(),
            "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(files[i].path)}",
            "contentType": lookupMimeType(basename(files[i].path))!
          });
        } else {
          String imageUrl = "";
          http.Response responseData = await http.get(Uri.parse(imageUrl));
          Uint8List uint8list = responseData.bodyBytes;
          ByteBuffer buffer = uint8list.buffer;
          ByteData byteData = ByteData.view(buffer);
          var tempDir = await getTemporaryDirectory();
          File f = await File('${tempDir.path}/${basename(files[i].path)}').writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          postsPictures.add({
            "originalName": basename(f.path),
            "fileLength": f.lengthSync(),
            "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(f.path)}",
            "contentType": lookupMimeType(basename(f.path))!
          });
        }
      }
      try {
        Dio dio = await DioManager.shared.getClient(context);
        await dio.post("${AppConstants.baseUrlEcommerce}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": categoryEditProductId,
          "price": price,
          "pictures": postsPictures,
          "weight": weight,
          "description": descEditSellerStore,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder,
          "harmful" : kindStuffSelected.contains(0),
          "flammable" : kindStuffSelected.contains(1),
          "liquid" : kindStuffSelected.contains(2),
          "fragile" : kindStuffSelected.contains(3)
        });
        _descEditSellerStore = "";
        ShowSnackbar.snackbar(context, "Produk telah diubah", "", ColorResources.success);
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.loaded);
        NS.pop(context);
        getDataSingleProduct(context, idProduct, "", "commerce");
        getDataProductByCategorySeller(context);
        getDataCategoryProduct(context, "commerce");
        setStateCategoryProductStatus(CategoryProductStatus.refetch);
      } on DioError catch(e) {
        if(e.type == DioErrorType.connectTimeout) {
          ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
        } 
        if(e.type == DioErrorType.other) {
          ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
        } 
        if(e.type == DioErrorType.response) {
          if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
            debugPrint("Internal Server Error (Post Edit Data Product Store)");
          } 
          if(e.response!.statusCode == 404) {
            debugPrint("Internal Server Error (URL not found)");
          }
          if(e.response!.statusCode == 502) {
            debugPrint("Internal Server Error (Bad gateway)");
          }
        }
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.error);
      } catch (e, stacktrace) {
        debugPrint(stacktrace.toString());
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.error);
      }
    } else {
      try {
        Dio dio = await DioManager.shared.getClient(context);
        await dio.post("${AppConstants.baseUrlEcommerce}/seller/product/update", data: {
          "id": idProduct,
          "name": nameProduct,
          "categoryId": categoryEditProductId,
          "price": price,
          "weight": weight,
          "description": descEditSellerStore,
          "stock": stock,
          "condition": condition,
          "minOrder": minOrder,
          "harmful" : kindStuffSelected.contains(0),
          "flammable" : kindStuffSelected.contains(1),
          "liquid" : kindStuffSelected.contains(2),
          "fragile" : kindStuffSelected.contains(3)
        });
        _descEditSellerStore = "";
        ShowSnackbar.snackbar(context, "Produk telah diubah", "", ColorResources.success);
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.loaded);
        NS.pop(context);
        getDataSingleProduct(context, idProduct, "", "commerce");
        getDataProductByCategorySeller(context);
        getDataCategoryProduct(context, "commerce");
        setStateCategoryProductStatus(CategoryProductStatus.refetch);
      } on DioError catch(e) {
        if(e.type == DioErrorType.connectTimeout) {
          ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
        } 
        if(e.type == DioErrorType.other) {
          ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
        } 
        if(e.type == DioErrorType.response) {
          if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
            debugPrint("Internal Server Error (Post Edit Data Product Store)");
          } 
          if(e.response!.statusCode == 404) {
            debugPrint("Internal Server Error (URL not found)");
          }
          if(e.response!.statusCode == 502) {
            debugPrint("Internal Server Error (Bad gateway)");
          }
        }
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.error);
      } catch (e, stacktrace) {
        debugPrint(stacktrace.toString());
        setStatePostEditDataProductStore(PostEditDataProductStoreStatus.error);
      }
    }
  }

  Future<void> postDeleteProductStore(BuildContext context, String idProduct, int status, String idStore) async {
    setStateDeleteProductStatus(DeleteProductStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/seller/product/update", data: {
        "id": idProduct,
        "status": status,
      });
      NS.pop(context, rootNavigator: true);
      getDataProductByCategorySeller(context);
      getDataCategoryProduct(context, "commerce");
      setStateCategoryProductStatus(CategoryProductStatus.refetch);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Delete Product Store)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateDeleteProductStatus(DeleteProductStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateDeleteProductStatus(DeleteProductStatus.error);
    }
  }

  Future<void> buyNow(BuildContext context, ProductStoreSingle pss) async {
    _cartStores.add(ca.StoreElement(
      storeId: pss.store!.id,
      classId: "viewstore",
      invoiceNo: "-",
      isActive: true,
      isLiveBuy: true,
      shippingRate: null,
      store: ca.StoreStore(
        address: pss.store!.address,
        city: pss.store!.city,
        classId: pss.store!.classId,
        description: pss.store!.description, 
        name: pss.store!.name,
        email: pss.store!.email,
        phone: pss.store!.phone,
        open: pss.store!.open,
        village: pss.store!.village,
        owner: pss.store!.owner,
        province: pss.store!.province,
        postalCode: pss.store!.postalCode,
        status: pss.store!.status,
        location: [pss.store!.location!.first, pss.store!.location!.last],
        subdistrict: pss.store!.subdistrict,
        id: pss.store!.id,
        picture: ca.Picture(
          classId: "media",
          originalName: pss.pictures!.first.originalName,
          contentType: pss.pictures!.first.contentType,
          fileLength: pss.pictures!.first.fileLength,
          path: pss.pictures!.first.path
        ),
        supportedCouriers: [],
        level: "BASIC"
      ),
      items: [
        ca.StoreElementItem(
          storeId: pss.store!.id,
          quantity: 1,
          controller: TextEditingController(text: "1"),
          price: pss.price,
          note: "-",
          isActive: true,
          isLiveBuy: true,
          classId: "viewproductcart",
          productId: pss.id,
          product: ca.Product(
            classId: pss.classId,
            discount: null,
            flammable: pss.flammable,
            fragile: pss.fragile,
            harmful: pss.harmful,
            liquid: pss.liquid,
            minOrder: pss.minOrder,
            name: pss.name,
            stats: ca.Stats(
              classId: "stats",
              numOfReview: 0,
              numOfSold: 0,
              ratingAvg: 0.0,
              ratingMax: 0.0,
              ratings: []
            ),
            pictures: [
              ca.Picture(
                classId: "media",
                originalName: pss.pictures!.first.originalName,
                fileLength: pss.pictures!.first.fileLength,
                contentType: pss.pictures!.first.contentType,
                path: pss.pictures!.first.path
              )
            ],
            stock: pss.stock,
            weight: pss.weight,
            price: pss.price,
            id: pss.id,
          ),
        )
        ]
      ),
    );
    cartData.totalProductPrice = pss.price;
    cartData.totalDeliveryCost = 0.0;
    cartData.serviceCharge = 0.0;
    Future.delayed(Duration.zero, () => notifyListeners());
    NS.push(context, const DeliveryBuyLiveScreen());
  }

  Future<void> getCartInfo(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/cart/info");
      Map<String, dynamic> data = res.data;

      if(data['code'] == 404) {
        setStateCartStatus(CartStatus.empty);
        throw CustomException(404);
      }
      if(data['code'] == 500) {
        setStateCartStatus(CartStatus.error);
        throw CustomException(500);
      }

      ca.CartModel cartModel = ca.CartModel.fromJson(data);
      _cartData = cartModel.data!;

      _cartStores = [];     
      _cartStores.addAll(cartData.stores!);

      setStateCartStatus(CartStatus.loaded);   
    } on DioError catch(e) {
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Cart Info)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 404) {
        setStateCartStatus(CartStatus.empty);
      } 
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Get Cart Info)");
        setStateCartStatus(CartStatus.error);
      }
    } catch (e, stackrace) {
      debugPrint(stackrace.toString());
      setStateCartStatus(CartStatus.error);
    }
  }

  Future<void> postAddCart(BuildContext context, String productId, int qty, {bool fromCart = true, ProductStoreSingle? productStoreSingle}) async {
    if(fromCart) {
      setStatePostAddCartStatus(PostAddCartStatus.loading);
    } else {
      setStatePostAddLiveBuySttus(PostAddLiveBuyStatus.loading);
    }
    try {
      if(fromCart) {
        Dio dio = await DioManager.shared.getClient(context);
        await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/add",
          data: {
            "productId": productId, 
            "quantity": qty, 
            "note": ""
          },
          options: Options(contentType: Headers.formUrlEncodedContentType)
        );
        ShowSnackbar.snackbar(context, "Produk berhasil ditambahkan keranjang", "", ColorResources.success);
        getCartInfo(context);
      } else { 
        buyNow(context, productStoreSingle!);
      }
      if(fromCart) {
        setStatePostAddCartStatus(PostAddCartStatus.loaded);
      } else {
        setStatePostAddLiveBuySttus(PostAddLiveBuyStatus.loaded);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Add Cart)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      if(fromCart) {
        setStatePostAddCartStatus(PostAddCartStatus.error);
      } else {
        setStatePostAddLiveBuySttus(PostAddLiveBuyStatus.error);
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      if(fromCart) {
        setStatePostAddCartStatus(PostAddCartStatus.error);
      } else {
        setStatePostAddLiveBuySttus(PostAddLiveBuyStatus.error);
      }
    }
  }

  void resetQty({required String qty, required String storeId, required String productId }) {
    int storeIndex = cartStores.indexWhere((el) => el.storeId == storeId);
    int productIndex = cartStores[storeIndex].items!.indexWhere((el) => el.productId == productId);
    cartData.stores![storeIndex].items![productIndex].quantity = int.tryParse(qty);
    double totalProductPrice = 0;
    int totalNumOfItems = 0;
    for (ca.StoreElement storeEl in cartData.stores!.where((el) => el.isActive == true).toList()) {
      for (ca.StoreElementItem item in storeEl.items!.where((el) => el.isActive == true).toList()) {
        totalProductPrice += item.price!;
        totalNumOfItems += item.quantity!;
      }
    }
    cartData.totalProductPrice = totalProductPrice;
    cartData.numOfItems = totalNumOfItems;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void onChangeQty({required String qty, required double price, 
    required String storeId, required String productId
  }) {   
    int storeIndex = cartStores.indexWhere((el) => el.storeId == storeId);
    int productIndex = cartStores[storeIndex].items!.indexWhere((el) => el.productId == productId);
    if(qty != "") {
      cartStores[storeIndex].items![productIndex].quantity = int.tryParse(qty);
      double totalProductPrice = 0;
      int totalNumOfItems = 0;
      for (ca.StoreElement storeEl in cartData.stores!.where((el) => el.isActive == true).toList()) {
        for (ca.StoreElementItem item in storeEl.items!.where((el) => el.isActive == true).toList()) {
          totalProductPrice += item.price! * item.quantity!;
          totalNumOfItems += item.quantity!;
        }
      }
      cartData.totalProductPrice = totalProductPrice;
      cartData.numOfItems = totalNumOfItems;
    } else {
      double totalProductPrice = 0;
      int totalNumOfItems = 0;
      for (ca.StoreElement storeEl in cartData.stores!.where((el) => el.isActive == true).toList()) {
        for (ca.StoreElementItem item in storeEl.items!.where((el) => el.isActive == true).toList()) {
          totalProductPrice += item.price!;
          totalNumOfItems += item.quantity!;
        }
      }
      cartData.totalProductPrice = totalProductPrice;
      cartData.numOfItems = totalNumOfItems;
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postEditQuantityCart(BuildContext context, String storeId, String productId, int qty, String type) async { 
    int storeIndex = cartStores.indexWhere((el) => el.storeId == storeId);
    int productIndex = cartStores[storeIndex].items!.indexWhere((el) => el.productId == productId);
    cartStores[storeIndex].items![productIndex].quantity = qty;

    if(cartStores[storeIndex].isActive! && cartStores[storeIndex].items![productIndex].isActive!) {
      if(type == "increment") {
        cartData.totalProductPrice = cartData.totalProductPrice! + cartStores[storeIndex].items![productIndex].price!;
        cartData.numOfItems = cartData.numOfItems! + 1;
      } else if (type == "decrement") {
        cartData.totalProductPrice = cartData.totalProductPrice! - cartStores[storeIndex].items![productIndex].price!;
        cartData.numOfItems = cartData.numOfItems! - 1;
      }
    }
    Future.delayed(Duration.zero, () => notifyListeners());
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/updateQty",
        data: {
          "productId": productId,
          "quantity": qty,
        },
      options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Edit Quantity Cart)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> postEditNoteCart(BuildContext context, String idProduct, String note) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/updateNote",
      data: {
        "productId": idProduct,
        "note": note,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      getCartInfo(context);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Edit Note Cart)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> postDeleteProductCart(BuildContext context, String idProduct) async {
    ProgressDialog pr = ProgressDialog(context: context);
    pr.show(
      max: 2,
      borderRadius: 10.0,
      backgroundColor: ColorResources.white,
      msg: "Mohon Tunggu..."
    );
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/delete",
      data: {
        "productId": idProduct,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType));
      pr.close();  
      getCartInfo(context);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Delete Product Cart)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      pr.close();  
    } catch (e, stacktrace) {
      pr.close();  
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> postEmptyProductCart(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/empty");
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Empty Product Cart)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> postCartCheckout(BuildContext context, String nameBank,  String paymentChannel) async {
    setStatePostCartCheckoutStatus(PostCartCheckoutStatus.loading);
    List<String> excludes = [];
    for (StoreElement stores in cartData.stores!) {
      for (StoreElementItem item in stores.items!.where((el) => el.isActive == false)) {
        excludes.add(item.productId!);
      }
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/checkout",
        data: {
          "paymentChannel": paymentChannel,
          "excludes": excludes.join(",")
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        )
      );
      setStatePostCartCheckoutStatus(PostCartCheckoutStatus.loaded);
      Map<String, dynamic> data = res.data;
      if(data["code"] == 500) {
        throw CustomException(500);
      }
      if(data["code"] == 305) {
        throw CustomException(305);
      }
      CheckoutCartStoreModel ccsm = CheckoutCartStoreModel.fromJson(data);
      NS.push(context, CheckoutProductScreen(
        paymentChannel: ccsm.body!.paymentChannel!,
        paymentCode: ccsm.body!.paymentCode!,
        paymentRefId: "",
        paymentGuide: ccsm.body!.paymentGuide!,
        paymentAdminFee: ccsm.body!.paymentAdminFee!,
        paymentStatus: ccsm.body!.paymentStatus!,
        nameBank: nameBank,
        refNo: ccsm.body!.refNo!,
        billingUid: ccsm.body!.billingUid!,
        amount: ccsm.body!.amount!
      ));
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Cart Checkout)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePostCartCheckoutStatus(PostCartCheckoutStatus.error);
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 305) {
        ShowSnackbar.snackbar(context, "Courier(s) Not Set!", "", ColorResources.error);
      }
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Post Cart Checkout)");
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePostCartCheckoutStatus(PostCartCheckoutStatus.error);
    }
  }

  Future<ShippingCouriersModel?> getCourierShipping(BuildContext context, String storeId) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/shipping/couriers?storeId=$storeId");
      Map<String, dynamic> data = res.data;
      if(data["code"] == 404) {
        throw CustomException(404);
      }
      if(data["code"] == 500) {
        throw CustomException(500);
      }
      ShippingCouriersModel shippingCouriersModel = ShippingCouriersModel.fromJson(data);
      return shippingCouriersModel;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Courier Shipping)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 404) {
        debugPrint("Internal Server Error (Get Courier Shipping - Data not found)");
      }
      if(int.parse(e.toString()) == 500) {
        debugPrint("Internal Server Error (Get Courier Shipping");
      }
      NS.pop(context);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      NS.pop(context);
    }
    return null;
  }

  Future<void> postSetCouriers(BuildContext context, String idStore, String courierCostId) async {
    ProgressDialog pr = ProgressDialog(context: context);
    pr.show(
      max: 2,
      elevation: 10.0,
      msg: "Mohon Tunggu...",
      backgroundColor: ColorResources.white,
    );
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlEcommerce}/commerce/cart/courier",
      data: {
        "storeId": idStore,
        "courierCostId": courierCostId
      },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        )
      );
      pr.close();
      Map<String, dynamic> data = res.data;
      if(data["code"] == 411) {
        throw CustomException(411);
      } else {
        var stores = data["body"]["stores"];
        double totalDeliveryCost = 0;
        for (var item in stores) {
          var shippingRate = item["shippingRate"];
          if(shippingRate != null) {
            for (ca.StoreElement storeEl in cartData.stores!.where(
              (el) => el.storeId == item["storeId"] && el.isActive == true 
            ).toList()) {
              storeEl.shippingRate = ca.ShippingRate(
                rateId: shippingRate["rateId"],
                courierId: shippingRate["courierId"],
                courierName: shippingRate["courierName"],
                courierLogo: shippingRate["courierLogo"],
                serviceName: shippingRate["serviceName"],
                serviceDesc: shippingRate["serviceDesc"],
                serviceType: shippingRate["serviceType"],
                serviceLevel: shippingRate["serviceLevel"],
                price: shippingRate["price"],
                estimateDays:shippingRate["estimateDays"]
              ); 
              totalDeliveryCost += shippingRate["price"];
            }
            cartData.totalDeliveryCost = totalDeliveryCost;
          }
        }
      }
      NS.pop(context, rootNavigator: true);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Set Couriers)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      pr.close();
    } on CustomException catch(e) {
      if(int.parse(e.toString()) == 411) {
        debugPrint("Internal Server Error (Post Set Couriers)");
      }
      pr.close();
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      pr.close();
    }
  }

  Future<void> getTransactionUnpaid(BuildContext context) async {
    setStateTransactionUnpaidStatus(TransactionUnpaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/unpaids");
      Map<String, dynamic> data = res.data;
      TransactionStoreUnpaidModel tsumAssign = TransactionStoreUnpaidModel.fromJson(data);
      _tsum = tsumAssign;
      setStateTransactionUnpaidStatus(TransactionUnpaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Unpaid)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionUnpaidStatus(TransactionUnpaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionUnpaidStatus(TransactionUnpaidStatus.error);
    }
  }

  Future<void> getTransactionBuyerPaidPacking(BuildContext context) async {
    setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/orders?orderStatus=PACKING");
      Map<String, dynamic> data = res.data;
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmReceive = tspmAssign;
      _packingCount = tspmAssign.body!.length;
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Buyer Paid Packing)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    }
  }

  Future<void> getTransactionBuyerPaidPickup(BuildContext context) async {
    setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/orders?orderStatus=PICKUP");
      Map<String, dynamic> data = res.data;
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmPickup = tspmAssign;
      _pickupCount = tspmAssign.body!.length;
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Buyer Paid Pickup)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    }
  }

  Future<void> getTransactionBuyerPaidShipping(BuildContext context) async {
    setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/orders?orderStatus=SHIPPING");
      Map<String, dynamic> data = res.data;
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmPickupShipping = tspmAssign;
      _shippingCount = tspmAssign.body!.length;
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Buyer Paid Shipping)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    }
  }

  Future<void> getTransactionBuyerPaidDelivered(BuildContext context) async {
    setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/orders?orderStatus=DELIVERED");
      Map<String, dynamic> data = res.data;
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmDelivered = tspmAssign;
      _deliveredCount = tspmAssign.body!.length;
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Buyer Paid Delivered)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    }
  }

  Future<void> getTransactionBuyerPaidDone(BuildContext context) async {
    setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/orders?orderStatus=DONE");
      Map<String, dynamic> data = res.data;
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmDone = tspmAssign;
      _doneCount = tspmAssign.body!.length;
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Buyer Paid Done)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionBuyerPaidStoreStatus(TransactionBuyerPaidStatus.error);
    }
  }

  Future<void> getTransactionSellerPaidReceive(BuildContext context) async {
    setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/seller/orders?orderStatus=RECEIVED");
      Map<String, dynamic> data = res.data; 
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmReceive = tspmAssign;
      _packingCount = tspmAssign.body!.length;
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loaded);
      if(tspmReceive.body!.isEmpty) {
        setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Seller Paid Receive)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    }
  }

  Future<void> getTransactionSellerPaidPacking(BuildContext context) async {
    setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/seller/orders?orderStatus=PACKING");
      Map<String, dynamic> data = res.data; 
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmPacking = tspmAssign;
      _pickupCount = tspmAssign.body!.length;
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loaded);
      if(tspmPacking.body!.isEmpty) {
        setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Seller Paid Packing)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    }
  }

  Future<void> getTransactionSellerPaidPickupShipping(BuildContext context) async {
    setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/seller/orders?orderStatus=PICKUP,SHIPPING");
      Map<String, dynamic> data = res.data; 
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmPickupShipping = tspmAssign;
      _shippingCount = tspmAssign.body!.length;
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loaded);
      if(tspmPickupShipping.body!.isEmpty) {
        setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Seller Paid Pickup Shipping)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    }
  }

  Future<void> getTransactionSellerPaidDelivered(BuildContext context) async {
    setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/seller/orders?orderStatus=DELIVERED");
      Map<String, dynamic> data = res.data; 
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmDelivered = tspmAssign;
      _deliveredCount = tspmAssign.body!.length;
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loaded);
      if(tspmDelivered.body!.isEmpty) {
        setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Seller Paid Delivered)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    }
  }

  Future<void> getTransactionSellerPaidDone(BuildContext context) async {
    setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/seller/orders?orderStatus=DONE");
      Map<String, dynamic> data = res.data; 
      TransactionStorePaidModel tspmAssign = TransactionStorePaidModel.fromJson(data);
      _tspmDone = tspmAssign;
      _doneCount = tspmAssign.body!.length;
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.loaded);
      if(tspmDone.body!.isEmpty) {
        setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Seller Paid Done)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionSellerPaidStoreStatus(TransactionSellerPaidStatus.error);
    }
  }

  Future<void> getTransactionPaidSingle(BuildContext context, String idTrx, String typeUser) async {
    setStateTransactionPaidSingleStatus(TransactionPaidSingleStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/$typeUser/order/fetch/$idTrx");
      Map<String, dynamic> data = res.data;
      TransactionPaidSingleModel tpsm = TransactionPaidSingleModel.fromJson(data);
      TransactionPaidSingle tps = tpsm.body!;
      _tps = tps;
      setStateTransactionPaidSingleStatus(TransactionPaidSingleStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Transaction Paid Single)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateTransactionPaidSingleStatus(TransactionPaidSingleStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateTransactionPaidSingleStatus(TransactionPaidSingleStatus.error);
    }
  }

  Future<void> bookingCourier(BuildContext context, String orderId, String courierId, [String pickupInstruction = "", 
    String deliveryInstuction = "", String deliveryTimeSlot = ""]) async {
    setStateBookingCourierStatus(BookingCourierStatus.loading);
    Map<String, dynamic> data = {};
    
    if(courierId == "jne") {
      data.addAll({
        "orderId" : orderId,
        "pickupDate" : "",
        "pickupTimeSlot" : "",
        "pickupApproxVolume" : "",
        "pickupInstruction" : "",
        "deliveryInstruction" : "",
        "deliveryTimeSlot" : ""
      });
    } else if(courierId == "ninja") {
      data.addAll({
        "orderId" : orderId,
        "pickupDate" : dataDatePickup,
        "pickupTimeSlot" : dataPickupTimeslots,
        "deliveryTimeSlot" : dataDeliveryTimeslots,
        "pickupApproxVolume" : dataApproximatelyVolumes,
        "dimensionHeight": dataDimensionsHeight,
        "dimensionLength": dataDimensionsLength,
        "dimensionSize": dataDimensionsSize,
        "dimensionWidth": dataDimensionsWidth,
        "pickupInstruction" : "",
        "deliveryInstruction" : "",
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlEcommerce}/transaction/seller/order/booking",
        data: data
      );
      setStateBookingCourierStatus(BookingCourierStatus.loaded);
      if(res.data['code'] == 500) {
        throw CustomException(res.data['error']);
      }
      if(res.data['code'] == 305) {
        throw CustomException(res.data['error']);
      }
      BookingCourierModel bookingCourierModel = BookingCourierModel.fromJson(res.data);
      if(courierId == "jne") {
        showAnimatedDialog(
          context: context, 
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Nomor Resi Anda ${bookingCourierModel.body!.waybill}. Silahkan bawa paket anda ke Kurir / Agent JNE terdekat Anda.",
                    style: robotoRegular.copyWith(
                      fontSize: 15.0
                    )
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorResources.primaryOrange
                    ),
                    onPressed: () => Navigator.of(context).pop,
                    child: const Text("OK",
                      style: robotoRegular,
                    ),
                  )
                ],
              ),
            );          
          },
        );
      } else {
        showAnimatedDialog(
          context: context, 
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0, bottom: 15.0),
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: [
                  Text("Nomor Resi Anda ${bookingCourierModel.body!.waybill}. Kurir terdekat akan jemput paket Anda",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    )
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorResources.primaryOrange
                    ),
                    onPressed: () => Navigator.of(context).pop,
                    child: Text("OK",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    ),
                  )
                ],
              ),
            );          
          },
        );
      }
      dataDatePickup = null;
      _dataPickupTimeslots = "";
      _dataApproximatelyVolumes = "";
      _dataDimensionsHeight = 0;
      _dataDimensionsLength = 0;
      _dataDimensionsWidth = 0;
      NS.push(context, const SellerTransactionOrderScreen(index: 2));
    } on CustomException catch(e) {
      ShowSnackbar.snackbar(context, e.toString(), "", ColorResources.error);
      setStateBookingCourierStatus(BookingCourierStatus.error);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Booking Courier)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateBookingCourierStatus(BookingCourierStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateBookingCourierStatus(BookingCourierStatus.error);
    }
  }

  Future<void> postOrderPacking(BuildContext context, String orderId) async {
    setStatePostOrderPickingStatus(PostOrderPickingStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/transaction/seller/order/packing",
        data: {
          "orderId": orderId
        },
        options: Options(contentType: Headers.formUrlEncodedContentType)
      );
      setStatePostOrderPickingStatus(PostOrderPickingStatus.loaded);
      ShowSnackbar.snackbar(context, "Konfirmasi pesanan berhasil", "", ColorResources.success);
      NS.push(context, const SellerTransactionOrderScreen(index: 1));
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Order Packing)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePostOrderPickingStatus(PostOrderPickingStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePostOrderPickingStatus(PostOrderPickingStatus.error);
    }
  }

  Future<TransactionPaidSingleModel?> postInputResi(BuildContext context, String orderId, String wayBill) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlEcommerce}/transaction/seller/order/shipping",
      data: {
        "orderId": orderId, 
        "wayBill": wayBill
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType)
      );
      TransactionPaidSingleModel transactionWarungPaidSingleModel = TransactionPaidSingleModel.fromJson(res.data);
      return transactionWarungPaidSingleModel;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Input Resi)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  Future<void> postOrderDone(BuildContext context,
    String orderId
  ) async {
    setStatePostOrderDoneStatus(PostOrderDoneStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/transaction/buyer/order/done",
        data: {
          "orderId": orderId
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType
        )
      );
      setStatePostOrderDoneStatus(PostOrderDoneStatus.loaded);
      NS.pushReplacement(context, const TransactionOrderScreen(index: 5));
      // await showDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   builder: (BuildContext ctx) => AlertDialog(
      //     contentTextStyle: robotoRegular,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0.0,
      //     content: Stack(
      //       clipBehavior: Clip.none,
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.all(10.0),
      //           margin: const EdgeInsets.all(10.0),
      //           decoration: BoxDecoration(
      //             shape: BoxShape.rectangle,
      //             color: ColorResources.white,
      //             borderRadius: BorderRadius.circular(10.0),
      //           ),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Text("Terima kasih telah berbelanja di Toko kami, Uang akan diteruskan ke Penjual",
      //                 style: robotoRegular.copyWith(
      //                   fontSize: Dimensions.fontSizeDefault, 
      //                   color: ColorResources.black
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(
      //                 height: 25.0,
      //               ),
      //               Align(
      //                 alignment: Alignment.bottomCenter,
      //                 child: CustomButton(
      //                   btnColor: ColorResources.primaryOrange,
      //                   isBoxShadow: false,
      //                   isBorderRadius: true,
      //                   isBorder: false,
      //                   onTap: () {
                        
      //                   },
      //                   btnTxt: "Kasih Ulasan Produk",
      //                 )
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    } on DioError catch(e) { 
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Order Done)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }  
      setStatePostOrderDoneStatus(PostOrderDoneStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePostOrderDoneStatus(PostOrderDoneStatus.error);
    }
  }

  Future<void> getReviewProductList(BuildContext context) async {
    setStateReviewProductListStatus(ReviewProductListStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/transaction/buyer/review/list");
      Map<String, dynamic> data = res.data;
      ReviewProductModel rpm = ReviewProductModel.fromJson(data);
      _rpl = [];
      List<ReviewProductList> r = rpm.body!;
      _rpl.addAll(r);
      setStateReviewProductListStatus(ReviewProductListStatus.loaded);
      if(rpl.isEmpty) {
        setStateReviewProductListStatus(ReviewProductListStatus.empty);
      }
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Review Product List)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateReviewProductListStatus(ReviewProductListStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateReviewProductListStatus(ReviewProductListStatus.error);
    }
  }

  Future<void> getReviewProductDetail(BuildContext context, {required String productId}) async {
    setStateReviewDataStatus(ReviewProductStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/review/$productId");
      Map<String, dynamic> data = res.data;
      ReviewProductDetailModel rpdmAssign = ReviewProductDetailModel.fromJson(data);
      _rpdm = rpdmAssign;
      setStateReviewDataStatus(ReviewProductStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Review Product Detail)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateReviewDataStatus(ReviewProductStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateReviewDataStatus(ReviewProductStatus.error);
    }
  }

  Future<void> postDataReviewProduct(BuildContext context, String idProduct, double star, String review, List<File> files) async {
    setStatePostDataReviewProductStatus(PostDataReviewProductStatus.loading);
    List<Map<String, Object>> postsPictures = [];
    for (int i = 0; i < files.length; i++) {
      postsPictures.add({
        "originalName": basename(files[i].path),
        "fileLength": files[i].lengthSync(),
        "path": "/commerce/saka/${context.read<ProfileProvider>().getUserPhoneNumber}/${basename(files[i].path)}",
        "contentType": lookupMimeType(basename(files[i].path))!
      });
    }
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlEcommerce}/transaction/buyer/review/add", data: {
        "productId": idProduct,
        "star": star,
        "text": review,
        "photos": postsPictures,
      });
      ShowSnackbar.snackbar(context, "Terima Kasih sudah memberikan ulasan!", "", ColorResources.success);
      NS.pushReplacement(context, DashboardScreen());
      setStatePostDataReviewProductStatus(PostDataReviewProductStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Post Data Review Product)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePostDataReviewProductStatus(PostDataReviewProductStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePostDataReviewProductStatus(PostDataReviewProductStatus.error);
    }
  }

  Future<ShippingTrackingModel?> getShippingTracking(BuildContext context, String idOrder) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/order/status?orderId=$idOrder");
      ShippingTrackingModel shippingTrackingModel = ShippingTrackingModel.fromJson(res.data);
      return shippingTrackingModel;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Shipping Tracking)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return null;
  }

  Future<void> getDataCouriers(BuildContext context) async {
    setStateCourierStatus(CourierStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/seller/store/couriers");
      CouriersModel couriersModel = CouriersModel.fromJson(res.data);
      _couriersModelList = [];
      List<CouriersModelList> couriersModelList = couriersModel.body!;
      _couriersModelList.addAll(couriersModelList);
      setStateCourierStatus(CourierStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Couriers)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<BankPaymentStore?> getDataBank(BuildContext context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlEcommerce}/commerce/payments");
      BankPaymentStore bankPaymentStore = BankPaymentStore.fromJson(res.data);
      return bankPaymentStore;
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Data Bank)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString()); 
    }
    return null;
  }

  Future<void> getPickupTimeslots(BuildContext context) async {
    setStatePickupTimeslotsStatus(PickupTimeslotsStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlEcommercePickupTimeslots);
      Map<String, dynamic> data = res.data;
      NinjaModel ninjaModel = NinjaModel.fromJson(data);
      _pickupTimeslots = [];
      for (int i = 0; i < ninjaModel.body!.length; i++) {
        _pickupTimeslots.add({
          "id": i.toString(),
          "name": ninjaModel.body![i]
        });
      }
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Pickup Timeslots)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePickupTimeslotsStatus(PickupTimeslotsStatus.error);
    }
  }

  Future<void> getDeliveryTimeslots(BuildContext context) async {
    setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlEcommerceDeliveryTimeslots);
      Map<String, dynamic> data = res.data;
      NinjaModel nm = NinjaModel.fromJson(data);
      _deliveryTimeslots = [];
      List<String> nd = nm.body!;
      for (var item in nd) {
        int i = item.indexOf(item);
        _deliveryTimeslots.add({
          "id": i.toString(),
          "name": item
        });
      }
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Delivery Timeslots)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateDeliveryTimeslotsStatus(DeliveryTimeslotsStatus.error);
    }
  }

  Future<void> getDimenstionSize(BuildContext context) async {
    setStateDimenstionStatus(DimenstionStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlEcommerceDimensionSize);
      Map<String, dynamic> data = res.data;
      NinjaModel ninjaModel = NinjaModel.fromJson(data);
      _dimensionsSize = [];
      for (int i = 0; i < ninjaModel.body!.length; i++) {
        _dimensionsSize.add({
          "id": i.toString(),
          "name": ninjaModel.body![i]
        });
      }
      setStateDimenstionStatus(DimenstionStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Dimensions Size)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateDimenstionStatus(DimenstionStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateDimenstionStatus(DimenstionStatus.error);
    }
  }

  Future<void> getApproximatelyVolumes(BuildContext context) async { 
    setStateApproximatelyVolumesStatus(ApproximatelyStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlEcommerceApproximatelyVolumes);
      Map<String, dynamic> data = res.data;
      NinjaModel ninjaModel = NinjaModel.fromJson(data);
      _approximatelyVolumes = [];
      for (int i = 0; i < ninjaModel.body!.length; i++) {
        _approximatelyVolumes.add({
          "id": i.toString(),
          "name": ninjaModel.body![i]
        });
      }
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          debugPrint("Internal Server Error (Get Approximately Volumes)");
        } 
        if(e.response!.statusCode == 404) {
          debugPrint("Internal Server Error (URL not found)");
        }
        if(e.response!.statusCode == 502) {
          debugPrint("Internal Server Error (Bad gateway)");
        }
      }
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateApproximatelyVolumesStatus(ApproximatelyStatus.error);
    }
  }

  void changeCourier(bool val, String courierId) {
    if(val) {
      isCheckedKurir.add(courierId);
    } else {
      isCheckedKurir.remove(courierId);
    }
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDescStore(String descStore) {
    _descStore = descStore;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDescAddSellerStore(String descAddSellerStore) {
    _descAddSellerStore = descAddSellerStore;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDescEditSellerStore(String descEditSellerStore) {
    _descEditSellerStore = descEditSellerStore;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeCategoryAddProductTitle(String categoryAddProductTitle, String categoryAddProductId) {
    _categoryAddProductId = categoryAddProductId;
    _categoryAddProductTitle = categoryAddProductTitle;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeCategoryEditProductTitle(String categoryEditProductTitle, String categoryEditProductId) {
    _categoryEditProductId = categoryEditProductId;
    _categoryEditProductTitle = categoryEditProductTitle;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changePickupTimeSlots(String timeSlots) {
    _dataPickupTimeslots = timeSlots;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDeliveryTimeSlots(String deliveryTimeSlots) {
    _dataDeliveryTimeslots = deliveryTimeSlots;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDimensionsSize(String dimensionsSize) {
    _dataDimensionsSize = dimensionsSize;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDatePickup(String datePickup) {
    dataDatePickup = datePickup;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDimensionsHeight(int dimensionsHeight) {
    _dataDimensionsHeight = dimensionsHeight;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeDimensionsLength(int dimensionsLength) {
    _dataDimensionsLength = dimensionsLength;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
  
  void changeDimensionsWidth(int dimensionsWidth) {
    _dataDimensionsWidth = dimensionsWidth;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void changeApproximatelyVolumes(String approximatelyVolumes) {
    _dataApproximatelyVolumes = approximatelyVolumes;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

}

ss.SellerStoreModel parseGetDataStore(dynamic data) {
  ss.SellerStoreModel ssm = ss.SellerStoreModel.fromJson(data);
  return ssm;
}