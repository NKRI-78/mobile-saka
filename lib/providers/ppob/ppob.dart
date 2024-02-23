import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:saka/providers/auth/auth.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/views/basewidgets/separator/separator.dart';
import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/data/models/ppob/cashout/bank.dart';
import 'package:saka/data/models/ppob/cashout/denom.dart';
import 'package:saka/data/models/ppob/cashout/emoney.dart';
import 'package:saka/data/models/ppob/cashout/inquiry.dart';
import 'package:saka/data/models/ppob/pln/inquiry_pasca.dart';
import 'package:saka/data/models/ppob/pln/inquiry_pra.dart';
import 'package:saka/data/models/ppob/pln/list_price_pra.dart';
import 'package:saka/data/models/ppob/registration/pay.dart';
import 'package:saka/data/models/ppob/wallet/balance.dart';
import 'package:saka/data/models/ppob/wallet/history.dart';
import 'package:saka/data/models/ppob/wallet_denom.dart';
import 'package:saka/data/models/ppob/wallet/inquiry_topup.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/dio.dart';
import 'package:saka/utils/helper.dart';

import 'package:saka/data/models/ppob/list_product_denom.dart';
import 'package:saka/data/models/ppob/va.dart';

import 'package:saka/views/screens/ppob/checkout/register.dart';
import 'package:saka/views/screens/ppob/cashout/confirmation.dart';
import 'package:saka/views/screens/ppob/cashout/success.dart';
import 'package:saka/views/screens/ppob/confirm_payment.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';
 
enum PayStatus { idle, loading, loaded, empty, error }
enum PayPLNPrabayarStatus { idle, loading, loaded, empty, error }
enum InquiryPLNPrabayarStatus  { loading, loaded, empty, error }
enum ListPricePLNPrabayarStatus { idle, loading, loaded, empty, error }
enum InquiryPLNPascabayarStatus { loading, loaded, empty, error }
enum ListVoucherPulsaByPrefixStatus { idle, loading, loaded, empty, error }
enum ListTopUpEmoneyStatus { loading, loaded, empty, error }
enum VaStatus { loading, loaded, empty, error }
enum BalanceStatus { loading, loaded, empty, error }
enum HistoryBalanceStatus { loading, loaded, empty, error }
enum InquiryDisbursementStatus { idle, loading, loaded, empty, error }
enum DenomDisbursementStatus { idle, loading, loaded, empty, error }
enum BankDisbursementStatus { loading, loaded, empty, error }
enum EmoneyDisbursementStatus { loading, loaded, empty, error }
enum SubmitDisbursementStatus { idle, loading, loaded, empty, error }

class PPOBProvider with ChangeNotifier {
  final AuthProvider ap;
  final SharedPreferences sp;

  PPOBProvider({
    required this.ap,
    required this.sp,
  });

  late double? balance;

  late InquiryPLNPrabayarData? inquiryPLNPrabayarData;
  late InquiryPLNPascaBayarData? inquiryPLNPascaBayarData; 
  late InquiryTopUpData? inquiryTopUpData;

  List<ListPricePraBayarData> _listPricePLNPrabayarData = [];
  List<ListPricePraBayarData> get listPricePLNPrabayarData => _listPricePLNPrabayarData;

  List<WalletDenomData> _wdd = [];
  List<WalletDenomData> get wdd => [..._wdd];

  List<ListProductDenomData> _listTopUpEmoney = [];
  List<ListProductDenomData> get  listTopUpEmoney => _listTopUpEmoney;

  List<ListProductDenomData> _listVoucherPulsaByPrefixData = [];
  List<ListProductDenomData> get listVoucherPulsaByPrefixData => _listVoucherPulsaByPrefixData;

  List<VAData> _listVa = [];
  List<VAData> get listVa => _listVa;

  List<HistoryBalanceData> _historyBalanceData = [];
  List<HistoryBalanceData> get historyBalanceData => _historyBalanceData;

  PayStatus _payStatus = PayStatus.idle;
  PayStatus get payStatus => _payStatus;

  PayPLNPrabayarStatus _payPLNPrabayarStatus = PayPLNPrabayarStatus.idle;
  PayPLNPrabayarStatus get payPLNPrabayarStatus => _payPLNPrabayarStatus;

  ListPricePLNPrabayarStatus _listPricePLNPrabayarStatus = ListPricePLNPrabayarStatus.idle;
  ListPricePLNPrabayarStatus get listPricePLNPrabayarStatus => _listPricePLNPrabayarStatus;

  InquiryPLNPrabayarStatus _inquiryPLNPrabayarStatus = InquiryPLNPrabayarStatus.loading; 
  InquiryPLNPrabayarStatus get inquiryPLNPrabayarStatus => _inquiryPLNPrabayarStatus;

  InquiryPLNPascabayarStatus _inquiryPLNPascaBayarStatus = InquiryPLNPascabayarStatus.empty;
  InquiryPLNPascabayarStatus get inquiryPLNPascabayarStatus => _inquiryPLNPascaBayarStatus;

  ListVoucherPulsaByPrefixStatus _listVoucherPulsaByPrefixStatus = ListVoucherPulsaByPrefixStatus.idle;
  ListVoucherPulsaByPrefixStatus get listVoucherPulsaByPrefixStatus => _listVoucherPulsaByPrefixStatus;

  void setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus payPLNPrabayarStatus) {
    _payPLNPrabayarStatus = payPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePayStatus(PayStatus payStatus) {
    _payStatus = payStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }
   
  void setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus listPricePLNPrabayarStatus) {
    _listPricePLNPrabayarStatus = listPricePLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus inquiryPLNPrabayarStatus) {
    _inquiryPLNPrabayarStatus = inquiryPLNPrabayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus inquiryPLNPascaBayarStatus) {
    _inquiryPLNPascaBayarStatus = inquiryPLNPascaBayarStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus listVoucherPulsaByPrefixStatus) {
    _listVoucherPulsaByPrefixStatus = listVoucherPulsaByPrefixStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  ListTopUpEmoneyStatus _listTopUpEmoneyStatus = ListTopUpEmoneyStatus.empty;
  ListTopUpEmoneyStatus get listTopUpEmoneyStatus => _listTopUpEmoneyStatus;

  void setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus listTopUpEmoneyStatus) {
    _listTopUpEmoneyStatus = listTopUpEmoneyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  VaStatus _vaStatus = VaStatus.loading;
  VaStatus get vaStatus => _vaStatus;

  void setStateVAStatus(VaStatus vaStatus) {
    _vaStatus = vaStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  BalanceStatus _balanceStatus = BalanceStatus.loading;
  BalanceStatus get balanceStatus => _balanceStatus;

  HistoryBalanceStatus _historyBalanceStatus = HistoryBalanceStatus.loading;
  HistoryBalanceStatus get historyBalanceStatus => _historyBalanceStatus;

  void setStateHistoryBalanceStatus(HistoryBalanceStatus historyBalanceStatus) {
    _historyBalanceStatus = historyBalanceStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBalanceStatus(BalanceStatus walletStatus) {
    _balanceStatus = walletStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  InquiryDisbursementStatus _inquirydisbursementStatus = InquiryDisbursementStatus.idle;
  InquiryDisbursementStatus get disbursementStatus => _inquirydisbursementStatus;

  List<DenomDisbursementBody> _denomDisbursement = [];
  List<DenomDisbursementBody> get denomDisbursement => _denomDisbursement;

  List<BankDisbursementBody> _bankDisbursement = [];
  List<BankDisbursementBody> get bankDisbursement => _bankDisbursement;

  DenomDisbursementStatus _denomDisbursementStatus = DenomDisbursementStatus.loading;
  DenomDisbursementStatus get denomDisbursementStatus => _denomDisbursementStatus;

  BankDisbursementStatus _bankDisbursementStatus = BankDisbursementStatus.loading;
  BankDisbursementStatus get bankDisbursementStatus => _bankDisbursementStatus; 

  List<EmoneyDisbursementBody> _emoneyDisbursement = [];
  List<EmoneyDisbursementBody> get emoneyDisbursement => _emoneyDisbursement;

  EmoneyDisbursementStatus _emoneyDisbursementStatus = EmoneyDisbursementStatus.loading;
  EmoneyDisbursementStatus get emoneyDisbursementStatus => _emoneyDisbursementStatus;

  SubmitDisbursementStatus _submitDisbursementStatus = SubmitDisbursementStatus.idle;
  SubmitDisbursementStatus get submitDisbursementStatus => _submitDisbursementStatus;

  void setStateDisbursementStatus(InquiryDisbursementStatus inquirydisbursementStatus) {
    _inquirydisbursementStatus = inquirydisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateDenomDisbursementStatus(DenomDisbursementStatus denomDisbursementStatus) {
    _denomDisbursementStatus = denomDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateBankDisbursementStatus(BankDisbursementStatus bankDisbursementStatus) {
    _bankDisbursementStatus = bankDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus emoneyDisbursementStatus) {
    _emoneyDisbursementStatus = emoneyDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSubmitDisbursementStatus(SubmitDisbursementStatus submitDisbursementStatus) {
    _submitDisbursementStatus = submitDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future setAccountPaymentMethod(String account) async {
    sp.setString("global_payment_method_account", account);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future changePaymentMethod(String name, String code) async {
    sp.setString("global_payment_method_name", name);
    sp.setString("global_payment_method_code", code);
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  Future removePaymentMethod() async {
    sp.remove("global_payment_method_name");
    sp.remove("global_payment_method_code");
    sp.remove("global_payment_method_account");
    Future.delayed(Duration.zero,() => notifyListeners());
  }

  String get getGlobalPaymentAccount => sp.getString("global_payment_method_account") ?? "";
  String get getGlobalPaymentMethodName => sp.getString("global_payment_method_name") ?? "";
  String get getGlobalPaymentMethodCode => sp.getString("global_payment_method_code") ?? "";

  Future<void> payRegister(BuildContext context, String productId, String paymentChannel, String transactionId) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = Dio();
      Response res =  await dio.post("${AppConstants.baseUrlPpob}/registration/pay", data: {
        "productId": productId,
        "paymentChannel" : paymentChannel,
        "paymentMethod": "BANK_TRANSFER",
        "transactionId" : transactionId
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${sp.getString("pay_register_token")}",
          "X-Context-ID": AppConstants.xContextId
        }
      ));
      Map<String, dynamic> data = res.data;
      PayRegisterModel payRegisterModel = PayRegisterModel.fromJson(data);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => CheckoutRegistrasiScreen(
          adminFee: double.parse(payRegisterModel.body!.data!.paymentAdminFee.toString()),
          guide: payRegisterModel.body!.data!.paymentGuide!,
          nameBank: payRegisterModel.body!.data!.paymentChannel,
          noVa: payRegisterModel.body!.data!.paymentCode,
          productPrice: double.parse(payRegisterModel.body!.productPrice.toString()),
          transactionId: payRegisterModel.body!.transactionId!,
        )),
      );
      setStatePayStatus(PayStatus.loaded);
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Pay Register )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> payPLNPrabayar(BuildContext context, {
    required String productId, 
    required String accountNumber,
    required String nominal
  }) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/pln/prabayar/pay", data: {
        "idpel": accountNumber,
        "ref2": productId,
        "nominal": nominal,
        "user_id": sp.getString("userId")
      });
      setStatePayStatus(PayStatus.loaded);
      showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0
                ),
                child: CustomDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  minWidth: 180.0,
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: 56.5,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 25.0,
                                    right: 25.0,
                                    bottom: 25.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Image.asset("assets/imagesv2/payment.png",
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                      
                                      const SizedBox(height: 15.0),

                                      Text(getTranslated("PAYMENT_SUCCESSFUL", context),
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        ),
                                      ),

                                      const SizedBox(height: 20.0),

                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                            
                                              CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                btnColor: ColorResources.success,
                                                onTap: () {
                                                  NS.pushReplacement(context, DashboardScreen(key: UniqueKey()));
                                                }, 
                                                btnTxt: getTranslated("CONTINUE", context)
                                              )
                            
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ) 
                    ),
                  ),
                ),
              );
            },
          ); 
        },
      );
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Pay PLN Pra Bayar )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> payPLNPascabayar(BuildContext context, String accountNumber, String transactionId) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/pln/pascabayar/pay", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber,
        "paymentMethod": "WALLET",
        "transactionId": transactionId
      });
      setStatePayStatus(PayStatus.loaded);
      showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0
                ),
                child: CustomDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  minWidth: 180.0,
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: 56.5,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 25.0,
                                    right: 25.0,
                                    bottom: 25.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Image.asset("assets/imagesv2/payment.png",
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                      
                                      const SizedBox(height: 15.0),

                                      Text(getTranslated("PAYMENT_SUCCESSFUL", context),
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        ),
                                      ),

                                      const SizedBox(height: 20.0),

                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                            
                                              CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                btnColor: ColorResources.success,
                                                onTap: () {
                                                  NS.pushReplacement(context, DashboardScreen(key: UniqueKey()));
                                                }, 
                                                btnTxt: getTranslated("CONTINUE", context)
                                              )
                            
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ) 
                    ),
                  ),
                ),
              );
            },
          ); 
        },
      );
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Pay PLN Pasca Bayar )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  // Future<void> inquiryTopUp(BuildContext context, {
  //   required String productId, 
  //   required String channel, 
  // }) async {
  //   setStatePayStatus(PayStatus.loading);
  //   try {
  //     Dio dio = await DioManager.shared.getClient(context);
  //     await dio.post("${AppConstants.baseUrlPpobV2}/inquiry/topup/balance", data: {
  //       "product_id": productId,
  //       "channel": channel,
  //       "user_id": sp.getString("userId"),
  //       "phone_number": sp.getString("phoneNumber"),
  //       "email_address": sp.getString("emailAddress"),
  //       "origin": "saka",
  //     });
  //     NS.push(context, DashboardScreen());
  //     setStatePayStatus(PayStatus.loaded);
  //   } on DioError catch(e) {
  //     if(e.response?.statusCode == 400) {
  //       ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
  //       setStatePayStatus(PayStatus.error);
  //     }
  //     setStatePayStatus(PayStatus.error);
  //   } catch(e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     setStatePayStatus(PayStatus.error);
  //   }
  // }

  Future<void> inquiryTopUp(BuildContext context, String productId, String accountNumber) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/wallet/inquiry", data: {
        "productId": productId,
        "accountNumber" : accountNumber
      });
      InquiryTopUpModel inquiryTopUpModel = InquiryTopUpModel.fromJson(res.data);
      inquiryTopUpData = inquiryTopUpModel.body!;
      setStatePayStatus(PayStatus.loaded);
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context,"Internal Server Error ( Inquiry Top Up )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }


  Future<void> payTopUp(BuildContext context, String productId, String paymentChannel, String transactionId) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      var tempData = {
        "productId": productId,
        "paymentMethod" : "BANK_TRANSFER",
        "paymentChannel": paymentChannel,
        "transactionId": transactionId
      };
      debugPrint("payTopup (${tempData.toString()})");
      Response res = await dio.post("${AppConstants.baseUrlPpob}/wallet/pay", data : tempData);
      Map<String, dynamic> data = res.data;
      PayRegisterModel payRegisterModel = PayRegisterModel.fromJson(data);
      if(payRegisterModel.body!.data!.paymentCode == "linkaja_ewallet") {
        await launch("https://${payRegisterModel.body!.data!.paymentUrl!.split("://")[1]}");
        setStatePayStatus(PayStatus.loaded);
        Future.delayed(const Duration(seconds: 3), () {
          NS.pushReplacement(context, DashboardScreen());
        });
      } else if(payRegisterModel.body!.data!.paymentCode == "shopeepay_ewallet") {
        await launch("https://${payRegisterModel.body!.data!.paymentUrl!.split("://")[1]}");
        setStatePayStatus(PayStatus.loaded);
        Future.delayed(const Duration(seconds: 3), () {
          NS.pushReplacement(context, DashboardScreen());
        });
      } else {
        setStatePayStatus(PayStatus.loaded);
        showAnimatedDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0
                  ),
                  child: CustomDialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    minWidth: 180.0,
                    child: Transform.rotate(
                      angle: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: ColorResources.white,
                            width: 1.0
                          )
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Transform.rotate(
                                  angle: 56.5,
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    height: 270.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 50.0,
                                      left: 25.0,
                                      right: 25.0,
                                      bottom: 25.0
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        Image.asset("assets/imagesv2/payment.png",
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                        
                                        const SizedBox(height: 15.0),

                                        Text(getTranslated("INFO_PAYMENT", context),
                                          textAlign: TextAlign.center,
                                          style: poppinsRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          ),
                                        ),

                                        const SizedBox(height: 20.0),

                                        StatefulBuilder(
                                          builder: (BuildContext context, Function setState) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                              
                                                CustomButton(
                                                  isBorderRadius: true,
                                                  isBoxShadow: true,
                                                  btnColor: ColorResources.success,
                                                  onTap: () {
                                                    NS.pushReplacement(context, DashboardScreen(key: UniqueKey()));
                                                  }, 
                                                  btnTxt: getTranslated("CONTINUE", context)
                                                )
                              
                                              ],
                                            );
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ) 
                      ),
                    ),
                  ),
                );
              },
            ); 
          },
        );
      }
    } on DioError catch(e) {
      debugPrint("payTopup (${e.response!.data.toString()})");
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Pay Top Up )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> purchasePulsa(BuildContext context, String productId, String accountNumber) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      var tempData = {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentChannel": "WALLET",
        "paymentMethod": "WALLET"
      };
      debugPrint("purchasePulsa (${tempData.toString()})");
      await dio.post("${AppConstants.baseUrlPpob}/pulsa/purchase", data: tempData);
      setStatePayStatus(PayStatus.loaded);
      showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0
                ),
                child: CustomDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  minWidth: 180.0,
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: 56.5,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 25.0,
                                    right: 25.0,
                                    bottom: 25.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Image.asset("assets/imagesv2/payment.png",
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                      
                                      const SizedBox(height: 15.0),

                                      Text(getTranslated("PAYMENT_SUCCESSFUL", context),
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        ),
                                      ),

                                      const SizedBox(height: 20.0),

                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                            
                                              CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                btnColor: ColorResources.success,
                                                onTap: () {
                                                  NS.pushReplacement(context, DashboardScreen());
                                                }, 
                                                btnTxt: getTranslated("CONTINUE", context)
                                              )
                            
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ) 
                    ),
                  ),
                ),
              );
            },
          ); 
        },
      );
    } on DioError catch(e) {
      debugPrint("purchasePulsa (${e.response!.data.toString()})");
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      } 
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Purchase Pulsa )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error); 
    }
  }

  Future<void> purchaseEvent(BuildContext context, String productId, String accountNumber, String paymentChannel, String transactionId) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlPpob}/community/pay", data: {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentMethod": "BANK_TRANSFER",
        "paymentChannel": paymentChannel,
        "transactionId": transactionId
      });
      setStatePayStatus(PayStatus.loaded);
      showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0
                ),
                child: CustomDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  minWidth: 180.0,
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: 56.5,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 25.0,
                                    right: 25.0,
                                    bottom: 25.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Image.asset("assets/imagesv2/payment.png",
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                      
                                      const SizedBox(height: 15.0),

                                      Text(getTranslated("PAYMENT_SUCCESSFUL", context),
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        ),
                                      ),

                                      const SizedBox(height: 20.0),

                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                            
                                              CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                btnColor: ColorResources.success,
                                                onTap: () {
                                                  NS.pushReplacement(context, DashboardScreen(key: UniqueKey()));
                                                }, 
                                                btnTxt: getTranslated("CONTINUE", context)
                                              )
                            
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ) 
                    ),
                  ),
                ),
              );
            },
          ); 
        },
      );
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        setStatePayStatus(PayStatus.error);
        ShowSnackbar.snackbar(context, "(${e.response?.statusCode}) : ${e.response?.data["message"]}", "", ColorResources.error);
      } 
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500
        || e.response!.statusCode == 502
      ) {
        ShowSnackbar.snackbar(context, "Internal Server Error ( Purchase Pulsa )", "", ColorResources.error);
        setStatePayStatus(PayStatus.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);    
    }
  }

  Future<void> purchaseEmoney(BuildContext context, String productId, String accountNumber) async {
    setStatePayStatus(PayStatus.loading);
    try {
      Future.delayed(Duration.zero, () => notifyListeners());
      Dio dio = await DioManager.shared.getClient(context);
      var tempData = {
        "productId": productId,
        "accountNumber": accountNumber,
        "paymentChannel": "WALLET",
        "paymentMethod": "WALLET"
      };
      await dio.post("${AppConstants.baseUrlPpob}/emoney/purchase", data: tempData);
      setStatePayStatus(PayStatus.loaded);
      showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0
                ),
                child: CustomDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  minWidth: 180.0,
                  child: Transform.rotate(
                    angle: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: ColorResources.white,
                          width: 1.0
                        )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.rotate(
                                angle: 56.5,
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  height: 270.0,
                                  decoration: BoxDecoration(
                                    color: ColorResources.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 50.0,
                                    left: 25.0,
                                    right: 25.0,
                                    bottom: 25.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Image.asset("assets/imagesv2/payment.png",
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                                      
                                      const SizedBox(height: 15.0),

                                      Text(getTranslated("PAYMENT_SUCCESSFUL", context),
                                        textAlign: TextAlign.center,
                                        style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        ),
                                      ),

                                      const SizedBox(height: 20.0),

                                      StatefulBuilder(
                                        builder: (BuildContext context, Function setState) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                            
                                              CustomButton(
                                                isBorderRadius: true,
                                                isBoxShadow: true,
                                                btnColor: ColorResources.success,
                                                onTap: () {
                                                  NS.pushReplacement(context, DashboardScreen(key: UniqueKey()));
                                                }, 
                                                btnTxt: getTranslated("CONTINUE", context)
                                              )
                            
                                            ],
                                          );
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ) 
                    ),
                  ),
                ),
              );
            },
          ); 
        },
      );
    } on DioError catch(e) {
      debugPrint("purchaseEmoney (${e.response!.data.toString()})");
      if(e.response?.statusCode == 400) {
        setStatePayStatus(PayStatus.error);
        ShowSnackbar.snackbar(context, "${e.response?.data["message"]}", "", ColorResources.error);
      }
      setStatePayStatus(PayStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePayStatus(PayStatus.error);
    }
  }

  Future<void> postInquiryPLNPrabayarStatus(BuildContext context, {
    required String accountNumber, 
    required String productId,
    required String price
  }) async {
    setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.loading);
    try {
      Future.delayed(Duration.zero, () => notifyListeners());

      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/pln/prabayar/inquiry", data: {
        "productId" : productId,
        "accountNumber" : accountNumber,
        "paymentChannel": "WALLET",
        "paymentMethod": "WALLET"
      });
      
      Map<String, dynamic> data = res.data;

      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.loaded);
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.loaded);

      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: SizedBox(
            height: 300.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("CUSTOMER_INFORMATION", context),
                        softWrap: true,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("METER_NUMBER", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          ),
                          Text(accountNumber,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("CUSTOMER_NAME", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                          Text(data["body"]["data"]["accountName"],
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                const SizedBox(height: 12.0),
                 Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated("DETAIL_PAYMENT", context),
                        softWrap: true,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Token Listrik",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(price)),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50]!,
                        height: 3.0,
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated("TOTAL_PAYMENT", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(price)),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ), 
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(getTranslated("EDIT", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.purpleDark
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.purpleDark,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "pln-prabayar",
                              description: '-',
                              nominal : price,
                              provider: "pln",
                              accountNumber: accountNumber,
                              productId: data["body"]["productId"],
                            )),
                          );
                        },
                        child: Text(getTranslated("CONFIRM", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 
      || e.response!.statusCode == 401 
      || e.response!.statusCode == 402
      || e.response!.statusCode == 403
      || e.response!.statusCode == 404 
      || e.response!.statusCode == 500 
      || e.response!.statusCode == 502) {
        ShowSnackbar.snackbar(context,"Internal Server Error (${e.response!.data})", "", ColorResources.error);
        setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
        setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.error);
      }
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
      setStatePayPLNPrabayarStatus(PayPLNPrabayarStatus.error);
    }
  }

  Future<void> postInquiryPLNPascaBayar(BuildContext context, String accountNumber, TextEditingController controller, dynamic listener) async {
    setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loading);
    try {  
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlPpob}/pln/pascabayar/inquiry", data: {
        "productId": "49c55554-8c62-4f80-8758-d8f0cea1b63b",
        "accountNumber": accountNumber
      });

      InquiryPLNPascabayarModel inquiryPLNPascaBayarModel = InquiryPLNPascabayarModel.fromJson(res.data);
      inquiryPLNPascaBayarData = inquiryPLNPascaBayarModel.body!;

      setStateInquiryPLNPascabayarStatus(InquiryPLNPascabayarStatus.loaded);

      controller.removeListener(listener);
      showMaterialModalBottomSheet(        
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), 
            topRight: Radius.circular(20.0)
          ),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          child: SizedBox(
            height: 315.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getTranslated("CUSTOMER_INFORMATION", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getTranslated("METER_NUMBER", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(accountNumber,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getTranslated("CUSTOMER_NAME", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(inquiryPLNPascaBayarData!.data!.accountName!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  color: Colors.blueGrey[50],
                  height: 8.0,
                ),
                const SizedBox(height: 12.0),
                 Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getTranslated("DETAIL_PAYMENT", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Tagihan Listrik",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(inquiryPLNPascaBayarData!.data!.amount!.toString())),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MySeparatorDash(
                        color: Colors.blueGrey[50]!,
                        height: 3.0,
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getTranslated("TOTAL_PAYMENT", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(Helper.formatCurrency(double.parse(inquiryPLNPascaBayarData!.data!.amount.toString())),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.white,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          controller.addListener(listener);
                          Navigator.of(context).pop();
                        },
                        child: Text(getTranslated("EDIT", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.purpleDark
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: ColorResources.purpleDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide.none
                          ),
                        ),
                        onPressed: () { 
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ConfirmPaymentScreen(
                              type: "pln-pascabayar",
                              description: inquiryPLNPascaBayarData!.productName!,
                              nominal : inquiryPLNPascaBayarData!.data!.amount!,
                              provider: "pln",
                              accountNumber: inquiryPLNPascaBayarData!.accountNumber1,
                              productId: inquiryPLNPascaBayarData!.productId,
                            )),
                          );
                        },
                        child: Text(getTranslated("CONFIRM", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: ColorResources.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } on DioError catch(_) {
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateInquiryPLNPrabayarStatus(InquiryPLNPrabayarStatus.error);
    }
  } 

  Future<void> getListPricePLNPrabayar(context) async {
    setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=public_utility&category=PLN&type=prabayar");
      ListPricePraBayarModel listPricePraBayarModel = ListPricePraBayarModel.fromJson(res.data);
      _listPricePLNPrabayarData = [];
      List<ListPricePraBayarData> lpPpbd = listPricePraBayarModel.body!;
      _listPricePLNPrabayarData.addAll(lpPpbd);
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.loaded);
      if(_listPricePLNPrabayarData.isEmpty) {
        setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.empty);
      }
    } on DioError catch(_) { 
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateListPricePLNPrabayarStatus(ListPricePLNPrabayarStatus.error);
    }
  } 

  // Future<void> getListWalletDenom(BuildContext context) async {
  //   setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loading);
  //   try {
  //     Dio dio = await DioManager.shared.getClient(context);
  //     Response res = await dio.get("${AppConstants.baseUrlPpobV2}/get/denom");
  //     Map<String, dynamic> data = res.data;
  //     WalletDenomModel? wdm = WalletDenomModel.fromJson(data);
  //     List<WalletDenomData>? wld = wdm.body!.data;
  //     _wdd.addAll(wld!);
  //     if(wdd.isEmpty) {
  //       setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.empty);
  //     }
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loaded);
  //   } on CustomException catch(_) {
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
  //   } catch(e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
  //   }
  // }


  // Future<void> getListEmoney(BuildContext context, String category) async {
  //   try {
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loading);
  //     Dio dio = await DioManager.shared.getClient(context);
  //     Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=emoney&category=$category&type=credit");
  //     _listTopUpEmoney = [];
  //     ListProductDenomModel lpdm = ListProductDenomModel.fromJson(res.data);
  //     _listTopUpEmoney.addAll(lpdm.data);
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loaded);
  //     if(_listTopUpEmoney.isEmpty) {
  //       setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.empty);
  //     }
  //   } on DioError catch(_) {
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
  //   } catch(e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
  //   }
  // }

   Future<void> getListEmoney(BuildContext context, String category) async {
    try {
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loading);
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=emoney&category=$category&type=credit");
      _listTopUpEmoney = [];
      ListProductDenomModel lpdm = ListProductDenomModel.fromJson(res.data);
      _listTopUpEmoney.addAll(lpdm.body!);
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.loaded);
      if(_listTopUpEmoney.isEmpty) {
        setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.empty);
      }
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 
        || e.response!.statusCode == 401 
        || e.response!.statusCode == 402
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 502) {
          ShowSnackbar.snackbar(context,"Internal Server Error (${e.response!.data})", "", ColorResources.error);
          setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
        }
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateListTopUpEmoneyStatus(ListTopUpEmoneyStatus.error);
    }
  }


  // Future<void> getVoucherPulsaByPrefix(BuildContext context, int prefix) async {
  //   setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loading);
  //   try {
  //     Dio dio = await DioManager.shared.getClient(context);
  //     Response res = await dio.get("${AppConstants.baseUrlPpobV2}/inquiry/pulsa?prefix=$prefix&type=PULSA");
  //     ListProductDenomModel listVoucherPulsaByPrefixModel = ListProductDenomModel.fromJson(res.data);
  //     _listVoucherPulsaByPrefixData = [];
  //     List<ListProductDenomData> listVoucherPulsaByPrefixData = listVoucherPulsaByPrefixModel.data;
  //     _listVoucherPulsaByPrefixData.addAll(listVoucherPulsaByPrefixData);
  //     setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loaded);
  //     if(_listVoucherPulsaByPrefixData.isEmpty) {
  //       setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.empty);
  //     } 
  //   } on DioError catch(_) {
  //     setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
  //   } catch(e, stacktrace) {
  //     debugPrint(stacktrace.toString());
  //     setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
  //   }
  // } 

  Future<void> getVoucherPulsaByPrefix(BuildContext context, int prefix) async {
    setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/product/list?group=voucher&category=$prefix&type=pulsa");
      ListProductDenomModel listVoucherPulsaByPrefixModel = ListProductDenomModel.fromJson(res.data);
      _listVoucherPulsaByPrefixData = [];
      List<ListProductDenomData> listVoucherPulsaByPrefixData = listVoucherPulsaByPrefixModel.body!;
      _listVoucherPulsaByPrefixData.addAll(listVoucherPulsaByPrefixData);
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.loaded);
      if(_listVoucherPulsaByPrefixData.isEmpty) {
        setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.empty);
      } 
    } on DioError catch(e) {
      if(e.response!.statusCode == 400 
        || e.response!.statusCode == 401 
        || e.response!.statusCode == 402
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 502) {
          ShowSnackbar.snackbar(context,"Internal Server Error (${e.response!.data})", "", ColorResources.error);
          setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
        }
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateListVoucherPulsaByPrefixStatus(ListVoucherPulsaByPrefixStatus.error);
    }
  } 

  Future<void> getVA(context) async {
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlVa);
      VAModel pilihPembayaranModel = VAModel.fromJson(res.data);
      _listVa = [];
      List<VAData> vaData = pilihPembayaranModel.body!;
      _listVa.addAll(vaData);
      setStateVAStatus(VaStatus.loaded);
      if(listVa.isEmpty) {
        setStateVAStatus(VaStatus.empty);
      }
    } on DioError catch(_) {  
      setStateVAStatus(VaStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateVAStatus(VaStatus.error);
    }
  }

  Future<void> getBalance(BuildContext context) async {
    setStateBalanceStatus(BalanceStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get("${AppConstants.baseUrlPpob}/wallet/balance");
      Map<String, dynamic> data = res.data;
      BalanceModel balanceModel = BalanceModel.fromJson(data);
      balance = balanceModel.body?.balance!;
      setStateBalanceStatus(BalanceStatus.loaded);
    } on DioError catch(_) {
      setStateBalanceStatus(BalanceStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateBalanceStatus(BalanceStatus.error);
    }
  }

  Future<void> getHistoryBalance(BuildContext context, String startDate, String endDate) async {
    setStateHistoryBalanceStatus(HistoryBalanceStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      FormData formData = FormData.fromMap({
        "start": startDate,
        "end": endDate,
        "sort": "created,desc"
      });
      Response res = await dio.post("${AppConstants.baseUrlPpob}/wallet/history", data: formData);
      _historyBalanceData = [];
      HistoryBalanceModel historyBalanceModel = HistoryBalanceModel.fromJson(res.data);
      List<HistoryBalanceData> historyBalanceData = historyBalanceModel.body!;
      _historyBalanceData.addAll(historyBalanceData);
      setStateHistoryBalanceStatus(HistoryBalanceStatus.loaded);
      if(_historyBalanceData.isEmpty) {
        setStateHistoryBalanceStatus(HistoryBalanceStatus.empty);
      }
    } on DioError catch(_) {
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString()); 
      setStateHistoryBalanceStatus(HistoryBalanceStatus.error);
    }
  }

  Future<void> getDenomDisbursement(BuildContext context)  async {
    setStateDenomDisbursementStatus(DenomDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementDenom);
      DenomDisbursementModel denomDisbursementModel = DenomDisbursementModel.fromJson(res.data);
      _denomDisbursement = [];
      List<DenomDisbursementBody> denomDisbursement = denomDisbursementModel.body!;
      _denomDisbursement.addAll(denomDisbursement);
      setStateDenomDisbursementStatus(DenomDisbursementStatus.loaded);
      if(denomDisbursement.isEmpty) {
        setStateDenomDisbursementStatus(DenomDisbursementStatus.empty);
      } 
    } on DioError catch(_) {
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateDenomDisbursementStatus(DenomDisbursementStatus.error);
    }
  }

  Future<void> getBankDisbursement(BuildContext context) async {
    setStateBankDisbursementStatus(BankDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementBank);
      BankDisbursementModel bankDisbursementModel = BankDisbursementModel.fromJson(res.data);
      _bankDisbursement = [];
      List<BankDisbursementBody> listBankDisbursement = bankDisbursementModel.body!;
      _bankDisbursement.addAll(listBankDisbursement);
      setStateBankDisbursementStatus(BankDisbursementStatus.loaded);
    } on DioError catch(_) {
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.error);
    }
  }

  Future<void> getEmoneyDisbursement(BuildContext context) async {
    setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.get(AppConstants.baseUrlDisbursementEmoney);
      EmoneyDisbursementModel emoneyDisbursementModel = EmoneyDisbursementModel.fromJson(res.data);
      _emoneyDisbursement = [];
      List<EmoneyDisbursementBody> listEmoneyDisbursement = emoneyDisbursementModel.body!;
      _emoneyDisbursement.addAll(listEmoneyDisbursement);
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.loaded);
    } on DioError catch(_) {
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateEmoneyDisbursementStatus(EmoneyDisbursementStatus.error);
    }
  }

  Future<void> inquiryDisbursement(BuildContext context, int amount, int price) async {
    setStateDisbursementStatus(InquiryDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      Response res = await dio.post("${AppConstants.baseUrlDisbursement}/disbursement/inquiry", data: {
        "amount": amount
      });
      InquiryDisbursementModel inquiryDisbursementModel = InquiryDisbursementModel.fromJson(res.data);
      InquiryDisbursementBody idb = inquiryDisbursementModel.body!;
      Navigator.push(context, MaterialPageRoute(builder: (context) => CashOutInformationScreen(
        adminFee: idb.totalAdminFee, 
        totalDeduction: price,
        token: idb.token,
      )));
      setStateDisbursementStatus(InquiryDisbursementStatus.loaded);
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, "Insufficient wallet funds. Your Balance : ${Helper.formatCurrency(double.parse(balance.toString()))}", "", ColorResources.error);
        setStateDisbursementStatus(InquiryDisbursementStatus.error);
      }
      if(e.response?.statusCode == 411) {
        ShowSnackbar.snackbar(context, "Insufficient wallet funds. Your Balance : ${Helper.formatCurrency(double.parse(balance.toString()))}", "", ColorResources.error);
        setStateDisbursementStatus(InquiryDisbursementStatus.error);
      } else {
        ShowSnackbar.snackbar(context, "Internal Server Error (${e.response!.data})", "", ColorResources.error);
        setStateDisbursementStatus(InquiryDisbursementStatus.error);
      }
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateDisbursementStatus(InquiryDisbursementStatus.error);
    }
  }

  Future<void> submitDisbursement(BuildContext context, String token) async {
    setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loading);
    try {
      Dio dio = await DioManager.shared.getClient(context);
      await dio.post("${AppConstants.baseUrlDisbursement}/disbursement/submit", data: {
        "destAccount": getGlobalPaymentAccount,
        "destBank": getGlobalPaymentMethodCode
      }, options: Options(
        headers: {
          "x-request-token": token
        }
      ));
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.loaded);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CashOutSuccessScreen()));
    } on DioError catch(e) {
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, e.response?.data["message"], "", ColorResources.error);
        setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      }
      if(e.response?.statusCode == 411) {
        ShowSnackbar.snackbar(context, e.response?.data["message"], "", ColorResources.error);
        setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      } else {
        ShowSnackbar.snackbar(context, "Internal Server Error (${e.response!.data})", "", ColorResources.error);
        setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
      }
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateSubmitDisbursementStatus(SubmitDisbursementStatus.error);
    } 
  }
    
}
