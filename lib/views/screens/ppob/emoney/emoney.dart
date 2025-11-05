// import 'package:flutter/material.dart';

// import 'package:saka/localization/language_constraints.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';

// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/views/basewidgets/emoney/emoney.dart';
// import 'package:saka/views/screens/ppob/emoney/detail.dart';

// class VoucherEmoneyScreen extends StatefulWidget {
//   const VoucherEmoneyScreen({Key? key}) : super(key: key);

//   @override
//   State<VoucherEmoneyScreen> createState() => _VoucherEmoneyScreenState();
// }

// class _VoucherEmoneyScreenState extends State<VoucherEmoneyScreen> {
//   GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: globalKey,
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [

//             CustomAppBar(title: getTranslated("E_MONEY", context)),

//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(top: 10.0),
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 0.0,
//                     mainAxisSpacing: 0.0,
//                     childAspectRatio: 2 / 1
//                   ),
//                   itemCount: emoneyMenus.length,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (BuildContext context, int i) {
//                     return Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             margin: const EdgeInsets.all(5.0),
//                             height: 80.0,
//                             child: Card(
//                               elevation: 1.0,
//                               color: ColorResources.white,
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(context,
//                                     MaterialPageRoute(builder: (context) => DetailVoucherEmoneyScreen(
//                                       type: emoneyMenus[i]["type"],
//                                     )),
//                                   );
//                                 },
//                                 child: Container(
//                                   width: 100.0,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius .circular(4.0)
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Column(
//                                         children: [
//                                           emoneyMenus[i]["icons"] == null ? Text(emoneyMenus[i]["text"],
//                                             style: robotoRegular.copyWith(
//                                               color: ColorResources.primaryOrange,
//                                               fontSize: 12.0
//                                             )) : Center(
//                                             child: Image.asset("${emoneyMenus[i]["icons"]}",
//                                               height: 40.0,
//                                               width: 40.0,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ),
//                         )
//                       ]
//                     );
//                   },
//                 ),
//               ),
//             ),
      

//           ],
//         ),
//       ),
//     );
//   }
// }