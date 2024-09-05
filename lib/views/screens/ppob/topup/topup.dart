// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:saka/utils/custom_themes.dart';
// import 'package:saka/utils/dimensions.dart';
// import 'package:saka/utils/color_resources.dart';

// import 'package:saka/localization/language_constraints.dart';

// import 'package:saka/providers/ppob/ppob.dart';
// import 'package:saka/providers/profile/profile.dart';

// import 'package:saka/views/basewidgets/loader/circular.dart';
// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

// import 'package:saka/views/screens/ppob/confirm_payment.dart';

// class TopUpScreen extends StatefulWidget {
//   const TopUpScreen({Key? key}) : super(key: key);

//   @override
//   _TopUpScreenState createState() => _TopUpScreenState();
// }

// class _TopUpScreenState extends State<TopUpScreen> {
//   int selected = -1;

//   late PPOBProvider ppobProvider; 

//   @override 
//   void initState() {
//     super.initState();

//     ppobProvider = context.read<PPOBProvider>();

//     if(mounted) {
//       ppobProvider.getListEmoney(context, "CX_WALLET");
//     }
//   }

//   @override 
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         backgroundColor: ColorResources.backgroundColor,
//         body: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
        
//               CustomAppBar(title: getTranslated("TOPUP", context), isBackButtonExist: true),
        
//               Consumer<PPOBProvider>(
//                 builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
//                   if(ppobProvider.listTopUpEmoneyStatus == ListTopUpEmoneyStatus.loading) {
//                     return const Expanded(
//                         child: Loader(
//                         color: ColorResources.primaryOrange,
//                       ),
//                     );
//                   }
//                   return Expanded(
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 10.0),
//                       child: StatefulBuilder(
//                         builder: (BuildContext context, s) {
//                           return GridView.builder(
//                             itemCount: ppobProvider.listTopUpEmoney.length,
//                             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               childAspectRatio: 1.0,
//                             ),
//                             physics: const ScrollPhysics(),
//                             scrollDirection: Axis.vertical,
//                             itemBuilder: (BuildContext ctx, int i) {
//                               return Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       margin: const EdgeInsets.all(5.0),
//                                       child: Card(
//                                         elevation: 0.0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(15.0),
//                                           side: const BorderSide(
//                                             width: 1.0,
//                                             color: ColorResources.primaryOrange
//                                           )
//                                         ),
//                                         color: selected == i 
//                                         ? ColorResources.primaryOrange 
//                                         : ColorResources.white,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             s(() => selected = i);
//                                             Navigator.push(ctx,
//                                               MaterialPageRoute(builder: (_) => ConfirmPaymentScreen(
//                                                 type: "topup",
//                                                 description: "Topup",
//                                                 nominal: ppobProvider.listTopUpEmoney[i].price,
//                                                 accountNumber: context.read<ProfileProvider>().getUserPhoneNumber,
//                                                 productId: ppobProvider.listTopUpEmoney[i].productId,
//                                               )),
//                                             );
//                                           },
//                                           child: Container(
//                                             margin: const EdgeInsets.only(top: 10.0),
//                                             width: 100.0,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius .circular(10.0)
//                                             ),
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 Center(
//                                                   child: Text(NumberFormat("###,000", "id_ID").format(ppobProvider.listTopUpEmoney[i].price),
//                                                     style: robotoRegular.copyWith(
//                                                       color: selected == i ? ColorResources.white : ColorResources.primaryOrange,
//                                                       fontSize: Dimensions.fontSizeSmall
//                                                     ),
//                                                   )
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ),
//                                   )
//                                 ]
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ));
//                   },
//                 )
//               ],
//             ),
//         ),
//       ),
//     );
//   }
// }
