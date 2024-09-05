// import 'package:flutter/material.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';
// import 'package:saka/utils/dimensions.dart';

// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/views/screens/ppob/pln/token.dart';

// class PlnScreen extends StatefulWidget {
//   const PlnScreen({Key? key}) : super(key: key);

//   @override
//   State<PlnScreen> createState() => _PlnScreenState();
// }

// class _PlnScreenState extends State<PlnScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return buildUI();
//   }

//   Widget buildUI() {
//     return  Scaffold(
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             return Column(
//               children: [

//                 const CustomAppBar(title: "PLN", isBackButtonExist: true),

//                 Container(
//                   height: 60.0,
//                   color: ColorResources.white,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => const TokenListrikScreen()),
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             const SizedBox(width: 5.0),
//                             Container(
//                               margin: const EdgeInsets.only(left: 12.0),
//                               child: Text("Token Listrik",
//                                 style: robotoRegular.copyWith(
//                                   color: ColorResources.black,
//                                   fontSize: Dimensions.fontSizeSmall,
//                                   fontWeight: FontWeight.w600
//                                 ),
//                               )
//                             )
//                           ],
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(right: 12.0),
//                           child: InkWell(
//                             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TokenListrikScreen())),
//                             child: const Icon(Icons.keyboard_arrow_right)
//                           )
//                         ),
//                       ],
//                     ),
//                   )
//                 ),
//                 // Container(
//                 //   height: 60.0,
//                 //   color: ColorResources.white,
//                 //   child: InkWell(
//                 //     onTap: () {
//                 //       Navigator.push(context,
//                 //         MaterialPageRoute(builder: (context) => const TagihanListrikScreen()),
//                 //       );
//                 //     },
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //       children: [
//                 //         Row(
//                 //           children: [
//                 //             const SizedBox(width: 5.0),
//                 //             Container(
//                 //               margin: const EdgeInsets.only(left: 12.0),
//                 //               child: Text("Tagihan Listrik",
//                 //                 style: robotoRegular.copyWith(
//                 //                   color: ColorResources.black,  
//                 //                   fontSize: Dimensions.fontSizeSmall,
//                 //                   fontWeight: FontWeight.w600,
//                 //                 ),
//                 //               )
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         Container(
//                 //           margin: const EdgeInsets.only(right: 12.0),
//                 //           child: InkWell(
//                 //             onTap: () {
//                 //               Navigator.push(context,
//                 //                 MaterialPageRoute(builder: (context) => const TagihanListrikScreen()),
//                 //               );
//                 //             },
//                 //             child: const Icon(Icons.keyboard_arrow_right)
//                 //           )
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   )
//                 // )
//               ],
//             );
//           },
//         )
//       ),      
//     );
//   }
// }