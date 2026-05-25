// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart' as s;

import 'package:saka/data/models/region/region.dart';
import 'package:saka/data/models/user/user.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/auth/auth.dart';
import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/input_formatters.dart';
import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/basewidgets/dropdown/custom_dropdown.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/views/screens/auth/sign_in.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});


  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();

  late TextEditingController fullnameC;
  late TextEditingController usernameC;
  late TextEditingController emailC;
  late TextEditingController phoneNumberC;
  late TextEditingController passwordC;
  late TextEditingController passwordConfirmC;

  String? lanudType = "Lanud Atang Sendjaja";

  bool passwordObscure = false;
  bool passwordConfirmObscure = false;

  UserData userData = UserData();

  s.SearchBarController<dynamic> searchBarProvince = s.SearchBarController<dynamic>();
  s.SearchBarController<dynamic> searchBarCity = s.SearchBarController<dynamic>();

  String? province;
  String? city;

  List<Province> provinces = [];
  List<City> cities = [];

  Future<void> register(BuildContext context) async {
    try {
      String fullname = fullnameC.text;
      String phone = phoneNumberC.text;
      String email = emailC.text;
      String password = passwordC.text;
      String passwordConfirm = passwordConfirmC.text;

      if(lanudType!.trim().isEmpty || lanudType == null) {
        ShowSnackbar.snackbar(getTranslated("LANUD_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(fullname.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("FULLNAME_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(fullname.trim().length < 6) {
        ShowSnackbar.snackbar(getTranslated("FULLNAME_6_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(phone.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("PHONE_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(phone.length <= 10) {
        ShowSnackbar.snackbar(getTranslated("PHONE_NUMBER_10_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(email.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("EMAIL_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email); 
      if(!emailValid) {
        ShowSnackbar.snackbar("Ex : customercare@connexist.com", "", ColorResources.error);
        return;
      }
      if(password.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("PASSWORD_MUST_BE_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(password.trim().length < 6) {
        ShowSnackbar.snackbar(getTranslated("PASSWORD_6_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(passwordConfirm.trim().isEmpty) {
        ShowSnackbar.snackbar(getTranslated("PASSWORD_CONFIRM_IS_REQUIRED", context), "", ColorResources.error);
        return;
      }
      if(password != passwordConfirm) {
        ShowSnackbar.snackbar(getTranslated("PASSWORD_CONFIRM_DOES_NOT_MATCH", context), "", ColorResources.error);
        return;
      }
    
      userData.lanudType = lanudType;
      userData.lanudCode = lanudType.toString().split('-')[0];
      userData.fullname = fullname;
      userData.phoneNumber = phone;
      userData.emailAddress = email;
      userData.password = password;
      userData.province = province;
      userData.city = city;
    
      await context.read<AuthProvider>().register(context, userData);
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fullnameC = TextEditingController();
    usernameC = TextEditingController();
    emailC = TextEditingController();
    phoneNumberC = TextEditingController();
    passwordC = TextEditingController();
    passwordConfirmC = TextEditingController();

    if(mounted) { 
      // NewVersionPlus newVersion = NewVersionPlus(
      //   androidId: 'com.inovasi78.saka',
      //   iOSId: 'com.inovatif78.saka'
      // );
      // Future.delayed(Duration.zero, () async {
      //   VersionStatus? vs = await newVersion.getVersionStatus();
      //   if(vs!.canUpdate) {
      //     NS.push(context, const UpdateScreen());
      //   } 
      // });
    }
  }

  @override 
  void dispose() {
    fullnameC.dispose();
    usernameC.dispose();
    emailC.dispose();
    phoneNumberC.dispose();
    passwordC.dispose();
    passwordConfirmC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        key: globalKey,
        body: Consumer<AuthProvider>(
          builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
            return SafeArea(
              child: StatefulBuilder(
              builder: (BuildContext context, Function s) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/back-login.jpg')
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [ 
                      
                      Positioned(
                        top: 50.0,
                        left: 0.0,
                        right: 0.0,
                        child: SizedBox(
                          height: 150.0,
                          child: Image.asset('assets/images/logo.png')
                        ),
                      ),

                      ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                                                  
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
                            decoration: BoxDecoration(
                              color: ColorResources.splash,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)
                              )
                            ),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Container(
                                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                                padding: EdgeInsets.only(top: 12.0, bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Lanud (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return CustomDropDownFormField(
                                                titleText: "LANUD",
                                                hintText: "Lanud",
                                                hintTextColor: ColorResources.brown,
                                                fillColor: ColorResources.white,
                                                value: lanudType,
                                                filled: true,
                                                onSaved: (val) {
                                                  s(() => lanudType = val);
                                                },
                                                onChanged: (val) {  
                                                  s(() { 
                                                    lanudType = val;
                                                    if(lanudType == "Lainnya") {
                                                      province = null;
                                                      city = null;
                                                    }
                                                  });
                                                },
                                                dataSource: [
                                                  {
                                                    "display": "Lanud Atang Sendjaja",
                                                    "value": "Lanud Atang Sendjaja",
                                                  },
                                                  {
                                                    "display": "Lanud Roesmin Nurjadin",
                                                    "value": "Lanud Roesmin Nurjadin",
                                                  },
                                                  {
                                                    "display": "Lanud Supadio",
                                                    "value": "Lanud Supadio",
                                                  },
                                                  {
                                                    "display": "Lanud Halim Perdana Kusuma",
                                                    "value": "Lanud Halim Perdana Kusuma",
                                                  },
                                                  {
                                                    "display": "Lanud Suryadarma",
                                                    "value": "Lanud Suryadarma",
                                                  },
                                                  {
                                                    "display": "Lanud Maimun Saleh",
                                                    "value": "Lanud Maimun Saleh",
                                                  },
                                                  {
                                                    "display": "Lanud Raden Sadjad",
                                                    "value": "Lanud Raden Sadjad",
                                                  },
                                                  {
                                                    "display": "Lanud Sri Mulyono Herlambang",
                                                    "value": "Lanud Sri Mulyono Herlambang",
                                                  },
                                                  {
                                                    "display": "Lanud Sultan Sjahril",
                                                    "value": "Lanud Sultan Sjahril",
                                                  },
                                                  {
                                                    "display": "Lanud Husein Sastranegara",
                                                    "value": "Lanud Husein Sastranegara",
                                                  },
                                                  {
                                                    "display": "Lanud Soewondo",
                                                    "value": "Lanud Soewondo",
                                                  },
                                                  {
                                                    "display": "Lanud Sultan Iskandar Muda",
                                                    "value": "Lanud Sultan Iskandar Muda",
                                                  },
                                                  {
                                                    "display": "Lanud Raja Haji Fasabilillah",
                                                    "value": "Lanud Raja Haji Fasabilillah",
                                                  },
                                                  {
                                                    "display": "Lanud Wiriadinata",
                                                    "value": "Lanud Wiriadinata",
                                                  },
                                                  {
                                                    "display": "Lanud Sugiri Sukani",
                                                    "value": "Lanud Sugiri Sukani",
                                                  },
                                                  {
                                                    "display": "Lanud Jendral Besar Sudirman",
                                                    "value": "Lanud Jendral Besar Sudirman",
                                                  },
                                                  {
                                                    "display": "Lanud Hang Nadim",
                                                    "value": "Lanud Hang Nadim"
                                                  },
                                                  {
                                                    "display": "Lanud Pangeran M. Bun Yamin",
                                                    "value": "Lanud Pangeran M. Bun Yamin",
                                                  },
                                                  {
                                                    "display": "Lanud H. Abdullah Sanusi H",
                                                    "value": "Lanud H. Abdullah Sanusi H",
                                                  },
                                                  {
                                                    "display": "Lanud Harry Hadisoemantri",
                                                    "value": "Lanud Harry Hadisoemantri",
                                                  },
                                                  {
                                                    "display": "Lanud Iswahjudi",
                                                    "value": "Lanud Iswahjudi"
                                                  },
                                                  {
                                                    "display": "Lanud Sultan Hasanuddin",
                                                    "value": "Lanud Sultan Hasanuddin",
                                                  },
                                                  {
                                                    "display": "Lanud Abdulrachman Saleh",
                                                    "value": "Lanud Abdulrachman Saleh",
                                                  },
                                                  {
                                                    "display": "Lanud Muljono",
                                                    "value": "Lanud Muljono",
                                                  },
                                                  {
                                                    "display": "Lanud Sam Ratulangi",
                                                    "value": "Lanud Sam Ratulangi",
                                                  },
                                                  {
                                                    "display": "Lanud Sjamsuddin Noor",
                                                    "value": "Lanud Sjamsuddin Noor"
                                                  },
                                                  {
                                                    "display": "Lanud Dhomber",
                                                    "value": "Lanud Dhomber"
                                                  },
                                                  {
                                                    "display": "Lanud Tuan Guru Kyai Haji Muhammad Zainudin",
                                                    "value": "Lanud Tuan Guru Kyai Haji Muhammad Zainudin"
                                                  },
                                                  {
                                                    "display": "Lanud Anang Bursa",
                                                    "value": "Lanud Anang Bursa"
                                                  },
                                                  {
                                                    "display": "Lanud I. Gusti Ngurah Rai",
                                                    "value": "Lanud I. Gusti Ngurah Rai"
                                                  },
                                                  {
                                                    "display": "Lanud Haluoleo",
                                                    "value": "Lanud Haluoleo"
                                                  },
                                                  {
                                                    "display": "Lanud Iskandar",
                                                    "value": "Lanud Iskandar"
                                                  },
                                                  {
                                                    "display": "Lanud Silas Papare",
                                                    "value": "Lanud Silas Papare"
                                                  },
                                                  {
                                                    "display": "Lanud Manuhua",
                                                    "value": "Lanud Manuhua"
                                                  },
                                                  {
                                                    "display": "Lanud Eltari",
                                                    "value": "Lanud Eltari"
                                                  },
                                                  {
                                                    "display": "Lanud Leo Wattimena",
                                                    "value": "Lanud Leo Wattimena"
                                                  },
                                                  {
                                                    "display": "Lanud Pattimura",
                                                    "value": "Lanud Pattimura"
                                                  },
                                                  {
                                                    "display": "Lanud Johanes Abraham Dimara",
                                                    "value": "Lanud Johanes Abraham Dimara"
                                                  },
                                                  {
                                                    "display": "Lanud Yohanis Kapiyau",
                                                    "value": "Lanud Yohanis Kapiyau"
                                                  },
                                                  {
                                                    "display": "Lanud Dumatubun",
                                                    "value": "Lanud Dumatubun"
                                                  }, 
                                                  {
                                                    "display": "Lanud Wamena",
                                                    "value": "Lanud Wamena"
                                                  },
                                                  {
                                                    "display": "Lanud Adisucjipto",
                                                    "value": "Lanud Adisucjipto"
                                                  },
                                                  {
                                                    "display": "Lanud Adi Soemarmo",
                                                    "value": "Lanud Adi Soemarmo"
                                                  },
                                                  {
                                                    "display": "Lanud Sulaiman",
                                                    "value": "Lanud Sulaiman"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud SRI Palu",
                                                    "value": "Lanud SRI Palu"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud ZAM Lombok",
                                                    "value": "Lanud ZAM Lombok"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud SRI Gorontalo",
                                                    "value": "Lanud SRI Gorontalo"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud IKR Palangkaraya",
                                                    "value": "Lanud IKR Palangkaraya"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud ELI Maumere",
                                                    "value": "Lanud ELI Maumere"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud SWO Sibolga",
                                                    "value": "Lanud SWO Sibolga",
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud SIM Lhoksumawe",
                                                    "value": "Lanud SIM Lhoksumawe"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud SKI Cirebon",
                                                    "value": "Lanud SKI Cirebon"
                                                  }, 
                                                  {
                                                    "display": "Perwakilan Lanud SUT Padang",
                                                    "value": "Lanud SUT Padang"
                                                  },
                                                  {
                                                    "display": "Perwakilan Lanud BNY Lampung",
                                                    "value": "Lanud BNY Lampung"
                                                  },
                                                ],
                                                textField: 'display',
                                                valueField: 'value',
                                              );
                                              
                                            }, 
                                          ),
                                        ],
                                      )
                                    ),

                                    if(lanudType != "Lainnya")   
                                      selectedLanudProvince(context, lanudType!),
                                    if(lanudType != "Lainnya") 
                                      selectedLanudCity(context, lanudType!),

                                    if(lanudType == "Lainnya")
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: [
                                            Text("Province (* is required)",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Dimensions.fontSizeDefault
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            TextField(
                                              readOnly: true,
                                              onTap: () {},
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: province ?? "Province",
                                                hintStyle: robotoRegular.copyWith(
                                                  color: ColorResources.brown,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                                fillColor: ColorResources.white,
                                                filled: true,
                                                isDense: true,
                                                suffixIcon: Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 23.0,
                                                  color: ColorResources.brown,
                                                ),
                                                enabledBorder: OutlineInputBorder(      
                                                  borderSide: BorderSide(color: ColorResources.brown),   
                                                ),  
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )                                   
                                      ),

                                    if(lanudType == "Lainnya")
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Province (* is required)",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Dimensions.fontSizeDefault
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            TextField(
                                              readOnly: true,
                                              onTap: () => () {},
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: city ?? "City",
                                                hintStyle: robotoRegular.copyWith(
                                                  color: ColorResources.brown,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                                fillColor: ColorResources.white,
                                                filled: true,
                                                suffixIcon: Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 23.0,
                                                  color: ColorResources.brown,
                                                ),
                                                isDense: true,
                                                enabledBorder: OutlineInputBorder(      
                                                  borderSide: BorderSide(color: ColorResources.brown),   
                                                ),  
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )                                   
                                      ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Fullname (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          TextField(
                                            controller: fullnameC,
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.brown,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                            textInputAction: TextInputAction.next,
                                            cursorColor: ColorResources.brown,
                                            inputFormatters: [
                                              CapitalizeWordsInputFormatter()
                                            ],
                                            decoration: InputDecoration(
                                              hintText: getTranslated("ENTER_YOUR_FULLNAME", context),
                                              hintStyle: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: ColorResources.brown,
                                              ),
                                              fillColor: ColorResources.white,
                                              filled: true,
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(      
                                                borderSide: BorderSide(color: ColorResources.brown),   
                                              ),  
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.brown),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.brown),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
             
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Phone Number (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          TextField(
                                            controller: phoneNumberC,
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.brown,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.next,
                                            cursorColor: ColorResources.brown,
                                            decoration: InputDecoration(
                                              hintText: getTranslated("PHONE_NUMBER", context),
                                              hintStyle: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                              prefixIcon: Icon(
                                                Icons.phone_android,
                                                color: ColorResources.brown,
                                              ),
                                              fillColor: ColorResources.white,
                                              filled: true,
                                              isDense: true,
                                              enabledBorder: OutlineInputBorder(      
                                                borderSide: BorderSide(color: ColorResources.brown),   
                                              ),  
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.brown),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: ColorResources.brown),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("E-mail Address (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Container(
                                            child: TextField(
                                              controller: emailC,
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.brown,
                                                fontSize: Dimensions.fontSizeSmall
                                              ),
                                              keyboardType: TextInputType.emailAddress,
                                              cursorColor: ColorResources.brown,
                                              textInputAction: TextInputAction.next,
                                              decoration: InputDecoration(
                                                hintText: "Ex : customercare@inovasi78.com",
                                                hintStyle: robotoRegular.copyWith(
                                                  color: ColorResources.brown,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  color: ColorResources.brown,
                                                ),
                                                fillColor: ColorResources.white,
                                                filled: true,
                                                isDense: true,
                                                enabledBorder: OutlineInputBorder(      
                                                  borderSide: BorderSide(color: ColorResources.brown),   
                                                ),  
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: ColorResources.brown),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Password (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return TextField(
                                                controller: passwordC,
                                                obscureText: passwordObscure,
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.brown,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                                cursorColor: ColorResources.brown,
                                                decoration: InputDecoration(
                                                  fillColor: ColorResources.white,
                                                  hintText: getTranslated("PASSWORD", context),
                                                  hintStyle: robotoRegular.copyWith(
                                                    color: ColorResources.brown,
                                                    fontSize: Dimensions.fontSizeSmall
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: ColorResources.brown,
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      s(() => passwordObscure = !passwordObscure);
                                                    }, 
                                                    child: Icon(
                                                      passwordObscure 
                                                      ? Icons.visibility_off 
                                                      : Icons.visibility,
                                                      color: ColorResources.brown
                                                    ),
                                                  ),
                                                  filled: true,
                                                  isDense: true,
                                                  enabledBorder: OutlineInputBorder(      
                                                    borderSide: BorderSide(color: ColorResources.brown),   
                                                  ),  
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorResources.brown),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorResources.brown),
                                                  ),
                                                ),
                                                textInputAction: TextInputAction.next,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Password Confirm (* is required)",
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return TextField(
                                                controller: passwordConfirmC,
                                                obscureText: passwordConfirmObscure,
                                                cursorColor: ColorResources.brown,
                                                style: robotoRegular.copyWith(
                                                  color: ColorResources.brown,
                                                  fontSize: Dimensions.fontSizeSmall
                                                ),
                                                decoration: InputDecoration(
                                                  fillColor: ColorResources.white,
                                                  hintText: getTranslated("PASSWORD_CONFIRM", context),
                                                  hintStyle: robotoRegular.copyWith(
                                                    color: ColorResources.brown,
                                                    fontSize: Dimensions.fontSizeSmall
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.lock,
                                                    color: ColorResources.brown,  
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () {
                                                      s(() => passwordConfirmObscure = !passwordConfirmObscure);
                                                    }, 
                                                    child: Icon(
                                                      passwordConfirmObscure 
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                      color: ColorResources.brown
                                                    ),
                                                  ),
                                                  filled: true,
                                                  isDense: true,
                                                  enabledBorder: OutlineInputBorder(      
                                                    borderSide: BorderSide(color: ColorResources.brown),   
                                                  ),  
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorResources.brown),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: ColorResources.brown),
                                                  ),
                                                ),
                                              );
                                            },  
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: TextButton(
                                        onPressed: () => register(context),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          backgroundColor: ColorResources.brown
                                        ),
                                        child: authProvider.registerStatus == RegisterStatus.loading 
                                          ? Loader(
                                            color: ColorResources.white
                                          )
                                          : Text(getTranslated("SIGN_UP", context),
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.white,
                                            fontSize: Dimensions.fontSizeSmall
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.only(top: 15.0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: "When you Register, you agree to our acknowledge reading our",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall
                                          ),
                                          children: [
                                            TextSpan(
                                              text: " User Policy Notice",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeSmall,
                                                decoration: TextDecoration.underline
                                              ),
                                              recognizer: TapGestureRecognizer()..onTap = () => showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  barrierColor: Colors.black.withValues(alpha: 0.5),
                                                  transitionDuration: const Duration(milliseconds: 700),
                                                  pageBuilder: (BuildContext ctx, Animation<double> double, _) {
                                                    return Center(
                                                      child: Material(
                                                        color: ColorResources.transparent,
                                                        child: Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                                                        height: 580.0,
                                                        decoration: BoxDecoration(
                                                          color: ColorResources.brown, 
                                                          borderRadius: BorderRadius.circular(20.0)
                                                        ),
                                                        child: Stack(
                                                          clipBehavior: Clip.none,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.topLeft,
                                                              child: Container(
                                                                margin: const EdgeInsets.only(
                                                                  top: 0.0, 
                                                                  left: 0.0
                                                                ),
                                                                child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                  child: Image.asset("assets/images/background/shading-top-left.png")
                                                                )
                                                              )
                                                            ),
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: Container(
                                                                margin: const EdgeInsets.only(
                                                                  top: 0.0, 
                                                                  right: 0.0
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  child: Image.asset("assets/images/background/shading-right.png")
                                                                )
                                                              )
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomRight,
                                                              child: Container(
                                                                margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                                                                child: Image.asset("assets/images/background/shading-right-bottom.png")
                                                              )
                                                            ),
                                                            Align(
                                                              alignment: Alignment.center,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [

                                                                  Text("I'ts important that you understand what",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),
                                                                  
                                                                  const SizedBox(height: 8.0),

                                                                  Text("information Saka Dirgantara collects.",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("Some examples of data Saka Dirgantara\n collects and users are:",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("● Your Forum Information & Content",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("This may include any information you share with us,\nfor example; your create a post and another users\ncan like your post or comment also you can delete\nyour post.",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("● Photos, Videos & Documents",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("This may include your can post on media\nphotos, videos, or documents",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("● Embedded Links",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 8.0),

                                                                  Text("This may include your can post on link\nsort of news, etc",
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall,
                                                                      fontWeight: FontWeight.w300,
                                                                      color: ColorResources.white
                                                                    ),
                                                                  ),
                                                                ]
                                                              ) 
                                                            ),
                                                            Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets.only(
                                                                      left: 30.0,
                                                                      right: 30.0,
                                                                      bottom: 30.0,
                                                                    ),
                                                                    child: CustomButton(
                                                                      isBorderRadius: true,
                                                                      btnColor: ColorResources.brown,
                                                                      btnTextColor: ColorResources.white,
                                                                      onTap: () {
                                                                        Helper.prefs!.setBool("isAccept", true);
                                                                        NS.pop();
                                                                      }, 
                                                                      btnTxt: "Agree"
                                                                    ),
                                                                  )
                                                                ],
                                                              ) 
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  );
                                                },
                                                  transitionBuilder: (_, anim, __, child) {
                                                    Tween<Offset> tween;
                                                    if (anim.status == AnimationStatus.reverse) {
                                                      tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                                                    } else {
                                                      tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                                                    }
                                                    return SlideTransition(
                                                      position: tween.animate(anim),
                                                      child: FadeTransition(
                                                        opacity: anim,
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                                )
                                              )
                                          ]
                                        )
                                      )
                                    ),

                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getTranslated("ALREADY_HAVE_A_ACCOUNT", context),
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.white,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          InkWell(
                                            onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
                                            child: Text(getTranslated("SIGN_IN", context),
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.white,
                                                fontSize: Dimensions.fontSizeSmall,
                                                fontWeight: FontWeight.bold
                                              )
                                            ),
                                          )
                                        ],
                                      ) 
                                    )

                                        
                                  ]
                                )
                              
                              ),
                            ),
                          ),

                        ],
                      ),
                    ]
                  ),
                );
              },
            ),
          );
          } 
        ),
      ),
    );
  }



  Widget selectedLanudProvince(BuildContext context, String lanudType) {
    province = lanudType == "Lanud Atang Sendjaja" 
    ? "Jawa Barat" 
    : lanudType == "Lanud Roesmin Nurjadin" 
    ? "Riau" 
    : lanudType == "Lanud Supadio" 
    ? "Kalimantan Barat" 
    : lanudType == "Lanud Halim Perdana Kusuma" 
    ? "DKI Jakarta" 
    : lanudType == "Lanud Suryadarma" 
    ? "Jawa Barat" 
    : lanudType == "Lanud Maimun Saleh" 
    ? "Nangroe Aceh Darusalam" 
    : lanudType == "Lanud Raden Sadjad"  
    ? "Kep. Riau" 
    : lanudType == "Lanud Sri Mulyono Herlambang" 
    ? "Sumatera Selatan"
    : lanudType == "Lanud Sultan Sjahril" 
    ? "Sumatera Barat" 
    : lanudType == "Lanud Husein Sastranegara" 
    ? "Jawa Barat" 
    : lanudType == "Lanud Soewondo" 
    ? "Sumatera Utara"
    : lanudType == "Lanud Sultan Iskandar Muda" 
    ? "Nangroe Aceh Darusalam" 
    : lanudType == "Lanud Raja Haji Fasabilillah" 
    ? "Kepulauan Riau" 
    : lanudType == "Lanud Wiriadinata"
    ? "Jawa Barat" 
    : lanudType == "Lanud Sugiri Sukani" 
    ? "Jawa Barat"
    : lanudType == "Lanud Jendral Besar Sudirman"
    ? "Jawa Tengah"
    : lanudType == "Lanud Hang Nadim" 
    ? "Kep. Riau" 
    : lanudType == "Lanud Pangeran M. Bun Yamin" 
    ? "Lampung" 
    : lanudType == "Lanud H. Abdullah Sanusi H" 
    ? "Bangka Belitung" 
    : lanudType == "Lanud Harry Hadisoemantri" 
    ? "Kalimantan Barat" 
    : lanudType == "Lanud Iswahjudi" 
    ? "Jawa Timur"  
    : lanudType == "Lanud Sultan Hasanuddin" 
    ? "Sulawesi Selatan"
    : lanudType == "Lanud Abdulrachman Saleh"
    ? "Jawa Timur" 
    : lanudType == "Lanud Mujiono" 
    ? "Jawa Timur"
    : lanudType == "Lanud Sam Ratulangi" 
    ? "Sulawesi Utara" 
    : lanudType == "Lanud Sjamsuddin Noor"
    ? "Kalimantan Selatan"
    : lanudType == "Lanud Dhomber" 
    ? "Kalimantan Timur" 
    : lanudType == "Lanud Tuan Guru Kyai Haji Muhammad Zainudin" 
    ? "Nusa Tenggara Barat" 
    : lanudType == "Lanud Anang Bursa" 
    ? "Kalimantan Timur"
    : lanudType == "Lanud I Gusti Ngurah Rai" 
    ? "Bali" 
    : lanudType == "Lanud Haluoleo" 
    ? "Sulawesi Tenggara" 
    : lanudType == "Lanud Iskandar" 
    ? "Kalimantan Tengah"
    : lanudType == "Lanud Silas Papare" 
    ? "Jayapura" 
    : lanudType == "Lanud Manuhua" 
    ? "Biak" 
    : lanudType == "Lanud Eltari" 
    ? "Kupang" 
    : lanudType == "Lanud Leo Wattimena" 
    ? "Morotai" 
    : lanudType == "Lanud Pattimura" 
    ? "Ambon" 
    : lanudType == "Lanud Johanes Abraham Dimara" 
    ? "Merauke" 
    : lanudType == "Lanud Yohanis Kapiyau" 
    ? "Timika" 
    : lanudType == "Lanud Dumatubun" 
    ? "Tual" 
    : lanudType == "Lanud Wamena" 
    ? "Wamena" 
    : lanudType == "Lanud Adisucjipto" 
    ? "Yogyakarta" 
    : lanudType == "Lanud Adi Soemarmo" 
    ? "Jawa Tengah" 
    : lanudType == "Lanud Sulaiman" 
    ? "Jawa Barat" 
    : lanudType == "Lanud SRI Palu" 
    ? "Sulawesi Tengah" 
    : lanudType == "Lanud ZAM Lombok" 
    ? "Nusa Tenggara Barat" 
    : lanudType == "Lanud SRI Gorontalo" 
    ? "Sulawesi Utara" 
    : lanudType == "Lanud IKR Palangkaraya" 
    ? "Kalimantan Tengah" 
    : lanudType == "Lanud ELI Maumere" 
    ? "Nusa Tenggara Timur" 
    : lanudType == "Lanud SWO Sibolga" 
    ? "Sumatera Utara" 
    : lanudType == "Lanud SIM Lhoksumawe" 
    ? "Nangroe Aceh Darusalam" 
    : lanudType == "Lanud SKI Cirebon" 
    ? "Jawa Barat"
    : lanudType == "Lanud SUT Padang" 
    ? "Sumatera Barat" 
    : lanudType == "Lanud BNY Lampung" 
    ? "Bandar Lampung" 
    : lanudType == "Lanud Muljono" 
    ? "Jawa Timur"
    :  lanudType == "Lanud I. Gusti Ngurah Rai" 
    ? "Bali"
    : lanudType == "Lanud Raja Haji Fasabilillah" 
    ? "Riau" 
    : "-";

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Province (* is required)",
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.fontSizeSmall
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                readOnly: true,
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontSize: Dimensions.fontSizeSmall
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: province,
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.brown,
                    fontSize: Dimensions.fontSizeSmall
                  ),
                  fillColor: ColorResources.white,
                  filled: true,
                  isDense: true,
                  enabledBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: ColorResources.brown),   
                  ),  
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorResources.brown),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorResources.brown),
                  ),
                ),
              ),
            ],
          )                                   
        ),
      ]
    );
  }

  Widget selectedLanudCity(BuildContext context, String lanudType) {
    city = lanudType == "Lanud Atang Sendjaja" 
    ? "Bogor" 
    : lanudType == "Lanud Roesmin Nurjadin" 
    ? "Pekanbaru" 
    : lanudType == "Lanud Supadio" 
    ? "Pontianak" 
    : lanudType == "Lanud Halim Perdana Kusuma" 
    ? "Jakarta" 
    : lanudType == "Lanud Suryadarma" 
    ? "Kalijati" 
    : lanudType == "Lanud Maimun Saleh" 
    ? "Sabang" 
    : lanudType == "Lanud Raden Sadjad"  
    ? "Ranai" 
    : lanudType == "Lanud Sri Mulyono Herlambang" 
    ? "Palembang"
    : lanudType == "Lanud Sultan Sjahril" 
    ? "Padang" 
    : lanudType == "Lanud Husein Sastranegara" 
    ? "Bandung" 
    : lanudType == "Lanud Soewondo" 
    ? "Medan"
    : lanudType == "Lanud Sultan Iskandar Muda" 
    ? "Banda Aceh" 
    : lanudType == "Lanud Raja Haji Fasabilillah" 
    ? "Pinang" 
    : lanudType == "Lanud Wiriadinata"
    ? "Tasikmalaya" 
    : lanudType == "Lanud Sugiri Sukani" 
    ? "Majalengka"
    : lanudType == "Lanud Jendral Besar Sudirman"
    ? "Purbalingga"
    : lanudType == "Lanud Hang Nadim" 
    ? "Batam" 
    : lanudType == "Lanud Pangeran M. Bun Yamin" 
    ? "Lampung" 
    : lanudType == "Lanud H. Abdullah Sanusi H" 
    ? "Tanjung Pandan" 
    : lanudType == "Lanud Harry Hadisoemantri" 
    ? "Singkawang" 
    : lanudType == "Lanud Iswahjudi" 
    ? "Madiun"  
    : lanudType == "Lanud Sultan Hasanuddin" 
    ? "Makassar"
    : lanudType == "Lanud Abdulrachman Saleh"
    ? "Malang" 
    : lanudType == "Lanud Mujiono" 
    ? "Surabaya"
    : lanudType == "Lanud Sam Ratulangi" 
    ? "Manado" 
    : lanudType == "Lanud Sjamsuddin Noor"
    ? "Banjarmasin"
    : lanudType == "Lanud Dhomber" 
    ? "Balikpapan" 
    : lanudType == "Lanud Tuan Guru Kyai Haji Muhammad Zainudin" 
    ? "Rembiga" 
    : lanudType == "Lanud Anang Bursa" 
    ? "Tarakan"
    : lanudType == "Lanud I Gusti Ngurah Rai" 
    ? "Denpasar" 
    : lanudType == "Lanud Haluoleo" 
    ? "Kendari" 
    : lanudType == "Lanud Iskandar" 
    ? "Pangkalan Bun"
    : lanudType == "Lanud Silas Papare" 
    ? "Biak" 
    : lanudType == "Lanud Manuhua" 
    ? "Kupang" 
    : lanudType == "Lanud Eltari" 
    ? "Morotai" 
    : lanudType == "Lanud Leo Wattimena" 
    ? "Ambon" 
    : lanudType == "Lanud Pattimura" 
    ? "Merauke" 
    : lanudType == "Lanud Johanes Abraham Dimara" 
    ? "Timika" 
    : lanudType == "Lanud Yohanis Kapiyau" 
    ? "Tual" 
    : lanudType == "Lanud Dumatubun" 
    ? "Wamena" 
    : lanudType == "Lanud Wamena" 
    ? "Yogyakarta" 
    : lanudType == "Lanud Adisucjipto" 
    ? "Daerah Istimewa Yogyakarta" 
    : lanudType == "Lanud Adi Soemarmo" 
    ? "Surakarta" 
    : lanudType == "Lanud Sulaiman" 
    ? "Bandung" 
    : lanudType == "Lanud SRI Palu" 
    ? "Palu" 
    : lanudType == "Lanud ZAM Lombok" 
    ? "Lombok" 
    : lanudType == "Lanud SRI Gorontalo" 
    ? "Gorontalo" 
    : lanudType == "Lanud IKR Palangkaraya" 
    ? "Palangkaraya" 
    : lanudType == "Lanud ELI Maumere" 
    ? "Maumere" 
    : lanudType == "Lanud SWO Sibolga" 
    ? "Sibolga" 
    : lanudType == "Lanud SIM Lhoksumawe" 
    ? "Lhoksumawe" 
    : lanudType == "Lanud SKI Cirebon" 
    ? "Cirebon"
    : lanudType == "Lanud SUT Padang" 
    ? "Padang" 
    : lanudType == "Lanud BNY Lampung" 
    ? "Lampung" 
    : lanudType == "Lanud Muljono" 
    ? "Surabaya"
    : lanudType == "Lanud I. Gusti Ngurah Rai" 
    ? "Denpasar"
    : lanudType == "Lanud Raja Haji Fasabilillah" 
    ?  "Riau"
    : "-";  

    
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("City (* is required)",
                style: robotoRegular.copyWith(
                  color: ColorResources.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.fontSizeSmall
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                readOnly: true,
                style: robotoRegular.copyWith(
                  color: ColorResources.brown,
                  fontSize: Dimensions.fontSizeSmall
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: city,
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.brown,
                    fontSize: Dimensions.fontSizeSmall
                  ),
                  fillColor: ColorResources.white,
                  filled: true,
                  isDense: true,
                  enabledBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: ColorResources.brown),   
                  ),  
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorResources.brown),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorResources.brown),
                  ),
                ),
              ),
            ],
          )                                   
        ),
      ]
    );
  }

}

