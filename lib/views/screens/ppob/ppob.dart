// import 'package:flutter/material.dart';

// import 'package:saka/localization/language_constraints.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';

// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/views/basewidgets/ppob/ppob.dart';

// import 'package:saka/views/screens/ppob/emoney/emoney.dart';
// import 'package:saka/views/screens/ppob/pln/pln.dart';
// import 'package:saka/views/screens/ppob/pulsa/voucher_by_prefix.dart';

// class PPOBScreen extends StatefulWidget {
//   const PPOBScreen({Key? key}) : super(key: key);

//   @override
//   _PPOBScreenState createState() => _PPOBScreenState();
// }

// class _PPOBScreenState extends State<PPOBScreen> {
//   ScrollController ppobController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column( 
//           mainAxisSize: MainAxisSize.min,
//           children: [

//             CustomAppBar(title: getTranslated("PPOB" ,context)),

//             Container(
//               margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 1.0,
//                     blurRadius: 3.0,
//                     offset: const Offset(0.0, 3.0),
//                   )
//                 ]
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 elevation: 3.0,
//                 child: GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: ppobMenus[0]["menu-0"].length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 0.0,
//                   mainAxisSpacing: 0.0,
//                   childAspectRatio: 1 / 1
//                 ),
//                 itemBuilder: (BuildContext context, int i) {
//                   return  Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [    
//                           SizedBox(
//                             width: 50.0,
//                             child: IconButton(
//                               icon: ppobMenus[0]["menu-0"][i]["icons"],
//                               onPressed: () {
//                                 switch(ppobMenus[0]["menu-0"][i]["link"]) {
//                                   case "pulsa":
//                                     Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) => const VoucherPulsaByPrefixScreen()),
//                                     );
//                                   break;
//                                   case "uang-elektronik" :
//                                     Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) => const VoucherEmoneyScreen()),
//                                     );
//                                   break;
//                                   case "pln":
//                                     Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) => const PlnScreen()),
//                                     );
//                                   break;
//                                 }
//                               },
//                             ),
//                           ),                              
//                           Text(getTranslated(ppobMenus[0]["menu-0"][i]["text"], context),
//                             style: robotoRegular.copyWith(
//                               color: ColorResources.primaryOrange,
//                               fontWeight: FontWeight.w600
//                             ),
//                           ) , 
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               ),
//               )
//             )
            
//           ] 
//         ),
//       )
//     );
//   }
// }