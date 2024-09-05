// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:saka/views/basewidgets/textfield/password.dart';
// import 'package:saka/localization/language_constraints.dart';

// import 'package:saka/providers/auth/auth.dart';
// import 'package:saka/providers/ppob/ppob.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';
// import 'package:saka/utils/dimensions.dart';
// import 'package:saka/utils/exceptions.dart';
// import 'package:saka/utils/helper.dart';

// import 'package:saka/views/basewidgets/loader/circular.dart';
// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/views/basewidgets/tile/list.dart';

// class CashOutInformationScreen extends StatefulWidget {
//   final int? totalDeduction;
//   final double? adminFee;
//   final String? token;

//   const CashOutInformationScreen({Key? key, 
//     this.totalDeduction,
//     this.adminFee,
//     this.token
//   }) : super(key: key);

//   @override
//   _CashOutInformationScreenState createState() => _CashOutInformationScreenState();
// }

// class _CashOutInformationScreenState extends State<CashOutInformationScreen> {
//   FocusNode passNode = FocusNode();
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   GlobalKey<ScaffoldMessengerState> globalKey = GlobalKey<ScaffoldMessengerState>();
//   TextEditingController passwordTextController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();  
//     passNode = FocusNode();
//     formKey = GlobalKey<FormState>();
//     passwordTextController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
 
//     int adminFee = int.parse(widget.adminFee!.toStringAsFixed(0));
//     int grandTotal = (widget.totalDeduction! + adminFee);

//     void submit() async {
//       try {
//         if(Provider.of<PPOBProvider>(context, listen: false).getGlobalPaymentMethodName.isEmpty) {
//           ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
//             const SnackBar(
//               backgroundColor: ColorResources.error,
//               content: Text("Please select destination cash out method",
//                 style: robotoRegular,
//               )
//             )
//           );
//           return;
//         }
//         if(Provider.of<PPOBProvider>(context, listen: false).getGlobalPaymentAccount.trim().isEmpty) {
//           ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
//             const SnackBar(
//               backgroundColor: ColorResources.error,
//               content: Text("Please fill no account",
//                 style: robotoRegular,
//               )
//             )
//           );
//           return;
//         }
//         showMaterialModalBottomSheet(
//           context: context, 
//           builder: (context) {
//             return Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: SizedBox(
//                 height: 50.0,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     Container(
//                       margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16, bottom: 20.0),
//                       child: Text(getTranslated("ENTER_YOUR_PASSWORD", context),
//                         style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeSmall 
//                         ),
//                       ),
//                     ),

//                     Container(
//                       margin: const EdgeInsets.only(
//                         left: Dimensions.marginSizeDefault, 
//                         right: Dimensions.marginSizeDefault, 
//                         bottom: Dimensions.marginSizeDefault
//                       ),
//                       child: CustomPasswordTextField(
//                         hintText: getTranslated("PASSWORD", context),
//                         textInputAction: TextInputAction.done,
//                         focusNode: passNode,
//                         controller: passwordTextController,
//                       )
//                     ),

//                   Container(
//                     margin: const EdgeInsets.only(
//                       left: 16.0,
//                       right: 16.0, 
//                       bottom: 10.0, 
//                       top: 15.0
//                     ),
//                     child: TextButton(
//                     onPressed: () async {
//                       try {
//                         if(passwordTextController.text.trim().isEmpty) {
//                           Fluttertoast.showToast(
//                             msg: getTranslated("PASSWORD_REQUIRED", context),
//                             toastLength: Toast.LENGTH_SHORT,
//                             backgroundColor: ColorResources.error,
//                           );
//                           return;
//                         }
//                         await Provider.of<AuthProvider>(context, listen: false).authDisbursement(context, passwordTextController.text);
//                         await Provider.of<PPOBProvider>(context, listen: false).submitDisbursement(context, widget.token!);
//                       } on CustomException catch(e) {
//                         String error = e.toString();
//                         ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
//                           SnackBar(
//                             backgroundColor: ColorResources.error,
//                             content: Text(error,
//                               style: robotoRegular,
//                             )
//                           )
//                         );
//                       }
//                     },
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       backgroundColor: ColorResources.primaryOrange
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.2), 
//                             spreadRadius: 1.0, 
//                             blurRadius: 7.0, 
//                             offset: const Offset(0, 1)
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(10.0)),
//                         child: Consumer<AuthProvider>(
//                           builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
//                             return authProvider.authDisbursementStatus == AuthDisbursementStatus.loading 
//                             ? const Loader(
//                                 color: ColorResources.white,
//                               )
//                             : Text(getTranslated('CONTINUE', context),
//                               style: robotoRegular.copyWith(
//                                 fontSize: Dimensions.fontSizeSmall,
//                                 color: ColorResources.white,
//                               )
//                             );
//                           } 
//                         )
//                       ),
//                     )  
//                   ),
//                   ],
//                 ),
//               ),
//             )
//           );
//       });
//       } catch(e) {
//         debugPrint(e.toString());
//       }
//     }
    
//     return Scaffold(
//       key: globalKey,
//       body: SafeArea(
//         child: Stack(
//           children: [

//             const CustomAppBar(title: "Cash out Information", isBackButtonExist: true),

//             Container(
//               margin: const EdgeInsets.only(top: 90.0, bottom: 20.0, left: 16.0, right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
                
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Total deduction",
//                         style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeSmall,
//                           fontWeight: FontWeight.w500
//                         )
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(Helper.formatCurrency(double.parse(widget.totalDeduction.toString())),
//                         style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeSmall,
//                           fontWeight: FontWeight.w600,
//                           color: ColorResources.black
//                         ),
//                       )
//                     ],
//                   ),

//                   const SizedBox(height: 20.0),

//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       Text("Cash out on",
//                         style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeSmall,
//                           fontWeight: FontWeight.w500
//                         )
//                       ),

//                       Consumer<PPOBProvider>(
//                         builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
//                           return StatefulBuilder(
//                             builder: (BuildContext context, Function s) {
//                               return ppobProvider.getGlobalPaymentMethodName != "" && 
//                               ppobProvider.getGlobalPaymentAccount != "" 
//                               ?  
//                                 Container(
//                                   margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                                   child: Column(
//                                     children: [

//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text("${ppobProvider.getGlobalPaymentMethodName} - ${ppobProvider.getGlobalPaymentAccount}",
//                                             style: robotoRegular.copyWith(
//                                               fontSize: Dimensions.fontSizeSmall
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               Provider.of<PPOBProvider>(context, listen: false).removePaymentMethod();
//                                             },
//                                             child: const Icon(
//                                               Icons.remove_circle,
//                                               color: ColorResources.primaryOrange,  
//                                             ),
//                                           )
//                                         ],
//                                       ),

//                                     ]
//                                   ),
//                                 )
//                               : SizedBox(
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         ElevatedButton(
//                                           style: ButtonStyle(
//                                             elevation: MaterialStateProperty.resolveWith<double>(
//                                               (Set<MaterialState> states) {
//                                                 if (states.contains(MaterialState.disabled)) {
//                                                   return 0;
//                                                 }
//                                                 return 0;
//                                               },
//                                             ),
//                                             backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
                                            
//                                           ),
//                                           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
//                                             title: "Bank Transfer",
//                                             items: ppobProvider.bankDisbursement
//                                           ))),
//                                           child: Text("Bank Transfer",
//                                             style: robotoRegular.copyWith(
//                                               fontSize: Dimensions.fontSizeSmall,
//                                               color: ColorResources.white
//                                             ),
//                                           )
//                                         ),
//                                         const SizedBox(width: 15.0),
//                                         ElevatedButton(
//                                           style: ButtonStyle(
//                                             elevation: MaterialStateProperty.resolveWith<double>(
//                                               (Set<MaterialState> states) {
//                                                 if (states.contains(MaterialState.disabled)) {
//                                                   return 0;
//                                                 }
//                                                 return 0;
//                                               },
//                                             ),
//                                             backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
//                                           ),
//                                           onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListTileComponent(
//                                             title: getTranslated("E_MONEY", context),
//                                             items: ppobProvider.emoneyDisbursement
//                                           ))), 
//                                           child: Text(getTranslated("E_MONEY", context),
//                                             style: robotoRegular.copyWith(
//                                               fontSize: Dimensions.fontSizeSmall,
//                                               color: ColorResources.white
//                                             ),
//                                           )
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),                        
                     
//                     ],
//                   ),

//                   const SizedBox(height: 10.0),

//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       Text("Cash out detail",
//                         style: robotoRegular.copyWith(
//                           fontSize: Dimensions.fontSizeSmall,
//                           fontWeight: FontWeight.w500
//                         )
//                       ),

//                       const SizedBox(height: 8.0),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Cash out amount",
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall
//                             ),
//                           ),
//                           Text(Helper.formatCurrency(double.parse(widget.totalDeduction.toString())),
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall,
//                               color: ColorResources.black
//                             ),
//                           )
//                         ],
//                       ),

//                       const SizedBox(height: 6.0),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Admin fee",
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall
//                             ),
//                           ),
//                           Text(Helper.formatCurrency(double.parse(widget.adminFee.toString())),
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall,
//                               color: ColorResources.black
//                             ),
//                           )
//                         ],
//                       ),

//                       const Divider(),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Total deduction",
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall
//                             ),
//                           ),
//                           Text(Helper.formatCurrency(double.parse(grandTotal.toString())),
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeSmall,
//                               color: ColorResources.black
//                             ),
//                           )
//                         ],
//                       ),

//                     ],
//                   ),

//                 ],
//               ),
//             ),

//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: double.infinity,
//                 color: Colors.transparent,
//                 padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
//                 child: ElevatedButton(
//                   onPressed: submit,
//                   style: ButtonStyle(
//                   elevation: MaterialStateProperty.resolveWith<double>(
//                     (Set<MaterialState> states) {
//                       if (states.contains(MaterialState.disabled)) {
//                         return 0;
//                       }
//                       return 0;
//                     },
//                   ),
//                     backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       )
//                     )
//                   ),
//                   child: Consumer<PPOBProvider>(
//                     builder: (BuildContext context, PPOBProvider ppobProvider, Widget? tchild) {
//                       return ppobProvider.submitDisbursementStatus == SubmitDisbursementStatus.loading 
//                       ? const SizedBox(
//                           width: 18.0,
//                           height: 18.0,
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white),
//                           )
//                         )
//                       : Text(getTranslated("CONTINUE", context),
//                         style: robotoRegular.copyWith(
//                           color: ColorResources.white,
//                           fontSize: Dimensions.fontSizeSmall
//                         ),
//                       );
//                     },
//                   )       
//                 ),
//               ),
//             )

//           ],
//         ),
//       ),
//     );
//   }
// }