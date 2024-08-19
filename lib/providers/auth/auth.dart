import 'dart:convert';
import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:saka/data/models/mascot/mascot.dart';
import 'package:saka/utils/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/data/models/user/user.dart';
import 'package:saka/data/models/inquiry/register.dart';
import 'package:saka/data/repository/auth/auth.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/auth/otp.dart';
import 'package:saka/views/screens/auth/sign_up_social.dart';
import 'package:saka/views/screens/dashboard/dashboard.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/constant.dart';

enum AuthDisbursementStatus { loading, loaded, error, idle } 
enum RegisterStatus { loading, loaded, error, idle }
enum ForgotPasswordStatus { loading, loaded, error, idle }
enum LoginStatus { loading, loaded, error, idle }
enum MascotStatus { loading, loaded, error, idle }
enum ResendOtpStatus { idle, loading, loaded, error, empty } 
enum VerifyOtpStatus { idle, loading, loaded, error, empty }
enum ApplyChangeEmailOtpStatus { idle, loading, loaded, error, empty }

abstract class BaseAuth {
  Future<void> register(BuildContext context, UserData userData);
  Future<void> login(BuildContext context, UserData userData);
  Future<void> resendOtp(BuildContext context, String email);
  Future<void> verifyOtp(BuildContext context);
  Future<void> forgetPassword(BuildContext context, String email);
  Future<void> changePassword(BuildContext context, UserData userData);
  Future<InquiryRegisterModel> verify(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String token, UserModel user);
  late InquiryRegisterModel inquiryRegisterModel;
  Future<void> logout();
  Future<void> authDisbursement(BuildContext context, String password);
  Future<void> mascot(BuildContext context); 
  bool isLoggedIn();
}

class AuthProvider with ChangeNotifier implements BaseAuth {
  final AuthRepo ar;
  final SharedPreferences sp;
  final Dio dio = Dio(
    BaseOptions(
      contentType: Headers.jsonContentType,
      baseUrl: "${AppConstants.baseUrl}",
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 10 seconds
      receiveTimeout: 10 * 1000 // 10 seconds
    )
  );
  AuthProvider({
    required this.ar,
    required this.sp,
  });

  Map<String, dynamic>? dataGoogleVerification;

  GoogleSignIn googleSignIn = GoogleSignIn();
  FacebookAuth facebookAuth = FacebookAuth.instance;
  GoogleSignInAccount? currentUser;

  int _isShow = 0;
  int get isShow => _isShow;

  bool changeEmail = true;
  String? otp;
  String whenCompleteCountdown = "start";
  String changeEmailName = "";
  String emailCustom = "";

  CountDownController countDownController = CountDownController();
  TextEditingController otpTextController = TextEditingController();
  
  late SearchBarController<dynamic> searchBarProvinsi;

  LoginStatus _loginStatus = LoginStatus.idle;
  LoginStatus get loginStatus => _loginStatus;

  RegisterStatus _registerStatus = RegisterStatus.idle;
  RegisterStatus get registerStatus => _registerStatus;

  ForgotPasswordStatus _forgotPasswordStatus = ForgotPasswordStatus.idle;
  ForgotPasswordStatus get forgotPasswordStatus => _forgotPasswordStatus;

  AuthDisbursementStatus _authDisbursementStatus = AuthDisbursementStatus.idle;
  AuthDisbursementStatus get authDisbursementStatus => _authDisbursementStatus;

  VerifyOtpStatus _verifyOtpStatus = VerifyOtpStatus.idle;
  VerifyOtpStatus get verifyOtpStatus => _verifyOtpStatus;

  ResendOtpStatus _resendOtpStatus = ResendOtpStatus.idle;
  ResendOtpStatus get resendOtpStatus => _resendOtpStatus;

  ApplyChangeEmailOtpStatus _applyChangeEmailOtpStatus = ApplyChangeEmailOtpStatus.idle;
  ApplyChangeEmailOtpStatus get applyChangeEmailOtpStatus => _applyChangeEmailOtpStatus;

  MascotStatus _mascotStatus = MascotStatus.idle;
  MascotStatus get mascotStatus => _mascotStatus;

  void setStateLoginStatus(LoginStatus loginStatus) {
    _loginStatus = loginStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  void setStateRegisterStatus(RegisterStatus registerStatus) {
    _registerStatus = registerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateMascotStatus(MascotStatus mascotStatus) {
    _mascotStatus = mascotStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateForgotPasswordStatus(ForgotPasswordStatus forgotPasswordStatus) {
    _forgotPasswordStatus = forgotPasswordStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateAuthDisbursement(AuthDisbursementStatus authDisbursementStatus) {
    _authDisbursementStatus = authDisbursementStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setVerifyOtpStatus(VerifyOtpStatus verifyOtpStatus) {
    _verifyOtpStatus = verifyOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setResendOtpStatus(ResendOtpStatus resendOtpStatus) {
    _resendOtpStatus = resendOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus applyChangeEmailOtpStatus) {
    _applyChangeEmailOtpStatus = applyChangeEmailOtpStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  late InquiryRegisterModel inquiryRegisterModel;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index){
    _selectedIndex = index;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  String getUserToken() {
    return ar.getUserToken()!;
  }

  @override
  Future<void> mascot(BuildContext context) async {
    setStateMascotStatus(MascotStatus.loading);
    try {
      Dio d = await DioManager.shared.getClient();
      Response res = await d.get("${AppConstants.baseUrl}/content-service/maskot");
      MascotModel mm = MascotModel.fromJson(json.decode(res.data));
      MascotData md = mm.data!;
      _isShow = md.show!;
      setStateMascotStatus(MascotStatus.loaded);
    } on DioError catch(e) {
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.other) {
        ShowSnackbar.snackbar(context, e.error.toString(), "", ColorResources.error);
      } 
      if(e.type == DioErrorType.response) {
        if(e.response!.statusCode == 400 || e.response!.statusCode == 500) {
          ShowSnackbar.snackbar(context, "${e.response!.data["error"]}", "", ColorResources.error);
        } 
        if(e.response!.statusCode == 404) {
          ShowSnackbar.snackbar(context, "URL no found", "", ColorResources.error);
        }
        if(e.response!.statusCode == 502) {
          ShowSnackbar.snackbar(context, "Bad gateway", "", ColorResources.error);
        }
      }
      setStateMascotStatus(MascotStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateMascotStatus(MascotStatus.error);
    }
  }

  bool isLoggedIn() {
    return ar.isLoggedIn();
  }

  void writeData(UserModel user) async {
    sp.setString("token", user.data!.token!);
    sp.setString("refreshToken", user.data!.refreshToken!);
    sp.setString("created", user.data!.user!.created.toString());
    sp.setBool("emailActivated", user.data!.user!.emailActivated!);
    sp.setString("emailAddress", user.data!.user!.emailAddress!);
    sp.setBool("phoneActivated", user.data!.user!.phoneActivated!);
    sp.setString("phoneNumber", user.data!.user!.phoneNumber!);
    sp.setString("role", user.data!.user!.role!);
    sp.setString("status", user.data!.user!.status!);
    sp.setString("userId", user.data!.user!.userId!);
    sp.setString("userName", user.data!.user!.username!);
    sp.setString("fullname", user.data!.user!.fullname!);
    sp.setString("userType", user.data!.user!.userType!);
  }

  void deleteData() {
    sp.remove("token");
    sp.remove("refreshToken");
    sp.remove("created");
    sp.remove("emailActivated");
    sp.remove("emailAddress");
    sp.remove("phoneActivated");
    sp.remove("phoneNumber");
    sp.remove("role");
    sp.remove("status");
    sp.remove("userId");
    sp.remove("userName");
    sp.remove("userType");
  }

  @override
  Future<void> logout() {
    deleteData();
    return Future.value(true);
  }

  @override 
  Future<InquiryRegisterModel> verify(BuildContext context, GlobalKey<ScaffoldMessengerState> globalKey, String token, UserModel user) async {
    var productId;
    if(user.data!.user!.role == "lead") {
      productId = "48dc000f-07fb-4b7a-940d-1029ec604bf8"; // 200 K
    } else {
      productId = "8b02a294-5245-4abd-973e-990a6c2095c0"; // 100 K
    }
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      Response res = await dio.post("${AppConstants.baseUrlPpob}/registration/inquiry", data: {
        "productId" : productId
      }, options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "X-Context-ID": AppConstants.xContextId
        }
      ));
      InquiryRegisterModel inquiryRegisterModel = InquiryRegisterModel.fromJson(res.data); 
      return inquiryRegisterModel;  
    } on DioError catch(e) {
      if(e.response?.data != null) {
        if(e.response?.data['code'] == 404 && user.data!.user!.status == "pending") {
          ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
        }
        if(e.response?.data['code'] == 404 && user.data!.user!.status == "enabled") {
          writeData(user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardScreen()));
        } 
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              alignment: Alignment.center,
              height: 60.0,
              child: Text(getTranslated("THERE_WAS_PROBLEM", context),
                textAlign: TextAlign.center,
                style: robotoRegular
              ),
            ),
          );
        },
        animationType: DialogTransitionType.scale,
        curve: Curves.fastOutSlowIn,
        duration: Duration(seconds: 2),
      );
    }
    return inquiryRegisterModel;
  }

  @override
  Future<void> login(BuildContext context, UserData userData) async {
    setStateLoginStatus(LoginStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      Response res = await dio.post("${AppConstants.baseUrl}/user-service/login",
        data: {
          "phone_number": userData.phoneNumber, 
          "password": userData.password
        },
        options: Options(
          headers: {"Accept": "application/json"}
        )
      ); 
      Map<String, dynamic> data = json.decode(res.data);
      UserModel userModel = UserModel.fromJson(data);
      if(userModel.data!.user!.emailActivated!) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen())); 
        UserModel user = UserModel.fromJson(json.decode(res.data));
        writeData(user);
      } else {
        sp.setString("email_otp", userModel.data!.user!.emailAddress!);
        ShowSnackbar.snackbar(context, "Silahkan periksa Alamat E-mail ${userModel.data!.user!.emailAddress!} Anda, untuk melihat kode OTP yang tercantum", "", ColorResources.success);
        NS.pushReplacement(context, OtpScreen(key: UniqueKey()));
      }
      setStateLoginStatus(LoginStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
        setStateLoginStatus(LoginStatus.error);
      }
      if(e.type == DioErrorType.response) {
        if(e.response?.statusCode == 500 || e.response?.statusCode == 400) {
          ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
          setStateLoginStatus(LoginStatus.error);
        } else {
          ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
          setStateLoginStatus(LoginStatus.error);
        }
      }
      setStateLoginStatus(LoginStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateLoginStatus(LoginStatus.error);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      currentUser = googleUser;
      await isEmailAddressExistWithGmail(context, currentUser!.email);
      if(dataGoogleVerification!["code"] != 400) {
        UserModel user = UserModel.fromJson(dataGoogleVerification!);
        if(user.data!.user!.emailActivated!) {
          writeData(user);
          sp.setString("avatar_g", currentUser!.photoUrl!);
          sp.setString("loginType", "google");
          NS.pushReplacement(
            context, 
            DashboardScreen()
          );
        } else {
          sp.setString("email_otp", currentUser!.email);
          NS.pushReplacement(
            context,
            OtpScreen(key: UniqueKey())
          );
        }
      } else {
        NS.push(context, SignUpSocialMediaScreen(
          fullName: currentUser!.displayName!,
          emailAddress: currentUser!.email,
          profilePic: currentUser!.photoUrl!,
          type: "google",
        ));
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  } 

  Future<void> signInWithFb(BuildContext context) async {
    await facebookAuth.login(
      loginBehavior: LoginBehavior.dialogOnly
    );
    Map<String, dynamic> userData = await facebookAuth.getUserData();
    String emailAddress = userData["email"];
    String name = userData["name"];
    await isEmailAddressExistWithGmail(context, emailAddress); 
    if(dataGoogleVerification!["code"] != 400) {
      UserModel user = UserModel.fromJson(dataGoogleVerification!);
      if(user.data!.user!.emailActivated!) {  
        writeData(user);
        sp.setString("loginType", "facebook");
        NS.pushReplacement(
          context, 
          DashboardScreen(key: UniqueKey())
        );
      } else {
        sp.setString("email_otp", emailAddress);
        NS.pushReplacement(
          context,
          OtpScreen(key: UniqueKey())
        );
      }
    } else {
      NS.push(context, SignUpSocialMediaScreen(
        fullName: name,
        emailAddress: emailAddress,
        profilePic: "",
        type: "facebook",
        key: UniqueKey(),
      ));
    }
  }

  Future<void> isEmailAddressExistWithGmail(BuildContext context, String emailAddress) async {
    try {
      Response response = await dio.get("${AppConstants.baseUrl}/user-service/users/email-exist/$emailAddress");
      Map<String, dynamic> data = json.decode(response.data);
      dataGoogleVerification = data;
      Future.delayed(Duration.zero, () => notifyListeners());
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      dataGoogleVerification = data;
      Future.delayed(Duration.zero, () => notifyListeners());
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
      }
      if(e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error ( ${e.response?.data["error"]} )", "", ColorResources.purpleDark);
      }
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
    }
  }

  @override
  Future<void> register(BuildContext context, UserData userData) async {
    Object obj = {};
    obj = {
      "user_fullname": userData.fullname,
      "phone_number": userData.phoneNumber,
      "email_address": userData.emailAddress,
      "password": userData.password,
      "province": userData.province,
      "city": userData.city,
      "lanud": "${userData.lanudType}",
      "code_province": userData.codeProvince,
      "code_city": userData.codeCity,
      "code_lanud": userData.lanudCode
    };
    setStateRegisterStatus(RegisterStatus.loading);
    try {
      Response res = await dio.post("${AppConstants.baseUrl}/user-service/register",
        data: obj,
        options: Options(
          headers: {"Accept": "application/json"}
        )
      );
      Map<String, dynamic> data = json.decode(res.data);
      UserModel userModel = UserModel.fromJson(data);
      if(userModel.data!.user!.emailActivated!) {
        NS.pushReplacement(context, DashboardScreen());
        UserModel user = UserModel.fromJson(json.decode(res.data));
        writeData(user);
      } else {
        sp.setString("email_otp", userModel.data!.user!.emailAddress!);
        ShowSnackbar.snackbar(context, "Silahkan periksa Alamat E-mail ${userModel.data!.user!.emailAddress!} Anda, untuk melihat kode OTP yang tercantum", "", ColorResources.success);
        NS.pushReplacement(context, OtpScreen(key: UniqueKey())); 
      }
      setStateRegisterStatus(RegisterStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.type == DioErrorType.connectTimeout) {
        ShowSnackbar.snackbar(context, getTranslated("CONNECTION_TIMEOUT", context), "", ColorResources.error);
        setStateRegisterStatus(RegisterStatus.error);
      }
      if(e.type == DioErrorType.response) {
        if(e.response?.statusCode == 500 || e.response?.statusCode == 400) {
          ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
          setStateLoginStatus(LoginStatus.error);
        } else {
          ShowSnackbar.snackbar(context, getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
          setStateLoginStatus(LoginStatus.error);
        }
      }
      setStateRegisterStatus(RegisterStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateRegisterStatus(RegisterStatus.error);
    }
  }

  @override 
  Future<void> authDisbursement(BuildContext context, String password) async {
    setStateAuthDisbursement(AuthDisbursementStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      await dio.post("${AppConstants.baseUrl}/user-service/authentication-disburse", data: {
        "password": password
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${sp.getString("token")}",
          "Accept": "application/json"
        }
      ));
      setStateAuthDisbursement(AuthDisbursementStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
        setStateAuthDisbursement(AuthDisbursementStatus.error);
      }
      setStateAuthDisbursement(AuthDisbursementStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateAuthDisbursement(AuthDisbursementStatus.error);
    }
  }

  @override 
  Future<void> changePassword(BuildContext context, UserData userData) async {
    setStateForgotPasswordStatus(ForgotPasswordStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      await dio.post("${AppConstants.baseUrl}/user-service/change-password", data: {
        "old_password": userData.password,
        "new_password": userData.passwordNew,
        "confirm_new_password": userData.passwordConfirm
      }, options: Options(
        headers: {
          "Authorization": "Bearer ${sp.getString("token")}",
          "Accept": "application/json" 
        }
      ));
      setStateForgotPasswordStatus(ForgotPasswordStatus.loaded);
    } on DioError catch(e) {  
      Map<String, dynamic> data = e.response!.data;
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
        setStateForgotPasswordStatus(ForgotPasswordStatus.error);
      }
      setStateForgotPasswordStatus(ForgotPasswordStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateForgotPasswordStatus(ForgotPasswordStatus.error);
    }
  }

  Future<void> forgetPassword(BuildContext context, String email) async {
    setStateForgotPasswordStatus(ForgotPasswordStatus.loading);
    try { 
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      await dio.post("${AppConstants.baseUrl}/user-service/forgot-password",
        data: {
          "email": email   
        },
        options: Options(
          headers: { 
            "Accept": "application/json" 
          }
        )
      );
      ShowSnackbar.snackbar(context, "Kata Sandi telah berhasil diubah, Mohon periksa E-mail Anda", "", ColorResources.success);
      setStateForgotPasswordStatus(ForgotPasswordStatus.loaded);
      Navigator.of(context).pop();
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
      }
      setStateForgotPasswordStatus(ForgotPasswordStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateForgotPasswordStatus(ForgotPasswordStatus.error);
    }
  }

  Future<void> applyChangeEmailOtp(BuildContext context, GlobalKey<ScaffoldState> globalKey) async {
    changeEmailName = sp.getString("email_otp")!;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(changeEmailName); 
    if(!emailValid) {
      ShowSnackbar.snackbar(context, "Ex : customcare@inovasi78.com", "", ColorResources.error);
      return;
    } else {
      if(emailCustom.trim().isNotEmpty) {
        changeEmailName = emailCustom;
      }
      Future.delayed(Duration.zero, () => notifyListeners());
    }
    setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      await dio.post("${AppConstants.baseUrl}/user-service/change-email", data: {
        "old_email": sp.getString("email_otp"),
        "new_email": changeEmailName,
      },
        options: Options(
          headers: { 
            "Accept": "application/json" 
          }
        )
      );
      sp.setString("email_otp", changeEmailName);
      ShowSnackbar.snackbar(context, getTranslated("UPDATE_CHANGE_EMAIL_SUCCESSFUL", context), "", ColorResources.success);
      changeEmail = true;
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
        setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error); 
      }
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setApplyChangeEmailOtpStatus(ApplyChangeEmailOtpStatus.error);
    }
  }
  

  Future<void> verifyOtp(BuildContext context) async {
    if(otp == null) {
      ShowSnackbar.snackbar(context, "Mohon input OTP Anda", "", ColorResources.error);
      return;
    }
    setVerifyOtpStatus(VerifyOtpStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      Response res = await dio.post("${AppConstants.baseUrl}/user-service/verify-otp",
        data: {
          "otp": otp,
          "email": changeEmailName
        },
        options: Options(
          headers: { 
            "Accept": "application/json" 
          }
        )
      );
      ShowSnackbar.snackbar(context, "Akun Alamat E-mail $changeEmailName Anda sudah aktif", "", ColorResources.success);
      UserModel user = UserModel.fromJson(json.decode(res.data));
      writeData(user);
      NS.pushReplacement(context, DashboardScreen());
      setVerifyOtpStatus(VerifyOtpStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
      }
      setVerifyOtpStatus(VerifyOtpStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setVerifyOtpStatus(VerifyOtpStatus.error);
    }
  }

  Future<void> resendOtp(BuildContext context, String email) async {
    setResendOtpStatus(ResendOtpStatus.loading);
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return null;
      };
      await dio.post("${AppConstants.baseUrl}/user-service/resend-otp",
        data: {
          "email": email
        },
        options: Options(
          headers: { 
            "Accept": "application/json" 
          }
        )
      );
      ShowSnackbar.snackbar(context, "Silahkan periksa Alamat E-mail $email Anda, untuk melihat kode OTP yang tercantum", "", ColorResources.success);
      setResendOtpStatus(ResendOtpStatus.loaded);
    } on DioError catch(e) {
      Map<String, dynamic> data = json.decode(e.response!.data);
      if(e.response?.statusCode == 500 || e.response?.statusCode == 400) {
        ShowSnackbar.snackbar(context, data["error"], "", ColorResources.error);
      }
      setResendOtpStatus(ResendOtpStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setResendOtpStatus(ResendOtpStatus.error);
    }
  }

  void cleanText() {
    otpTextController.text = "";
    notifyListeners();
  }

  Future<void> resendOtpCall(BuildContext context, GlobalKey<ScaffoldState> globalKey) async {
    whenCompleteCountdown = "start";
    notifyListeners();
    await resendOtp(context, changeEmailName);
  }

  void cancelCustomEmail() {
    changeEmail = true;
    changeEmailName = sp.getString("email_otp")!;
    notifyListeners();
  }

  void applyCustomEmail() {
    changeEmail = true;
    changeEmailName = emailCustom.trim().isEmpty ? sp.getString("email_otp")! : emailCustom;
    notifyListeners();
  }

  void changeEmailCustom() {
    changeEmail = !changeEmail;
    notifyListeners();
  }

  void emailCustomChange(String val) {
    emailCustom = val;
    notifyListeners();
  } 

  void completeCountDown() {
    whenCompleteCountdown = "completed";
    notifyListeners();
  }

  void otpCompleted(v) {
    otp = v;
    notifyListeners();
  }

}