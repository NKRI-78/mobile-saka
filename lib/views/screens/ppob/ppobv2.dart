// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'package:saka/localization/language_constraints.dart';
// import 'package:saka/services/navigation.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';
// import 'package:saka/utils/dimensions.dart';

// import 'package:saka/views/basewidgets/button/custom.dart';

// import 'package:saka/views/screens/ppob/pln/pln.dart';
// import 'package:saka/views/screens/ppob/pulsa/voucher_by_prefix.dart';

// class PPOBV2Screen extends StatefulWidget {
//   const PPOBV2Screen({ Key? key }) : super(key: key);

//   @override
//   State<PPOBV2Screen> createState() => _PPOBV2ScreenState();
// }

// class _PPOBV2ScreenState extends State<PPOBV2Screen> {
//   int selected = -1;
      
//   List<Map<String, dynamic>> ppobs = [
//     {
//       "id": 1,
//       "name": "PULSA",
//       "image": "assets/images/home-category/pulsa.png"
//     },
//     // {
//     //   "id": 2,
//     //   "name": "E_MONEY",
//     //   "image": "assets/images/home-category/e-money.png"
//     // },
//     {
//       "id": 3,
//       "name": "PLN",
//       "image": "assets/images/home-category/pln.png"
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
    
//   }

//   @override 
//   void dispose() {

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildUI();
//   }

//   Widget buildUI() {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: ColorResources.backgroundColor,
//         body: Stack(
//           clipBehavior: Clip.none,
//           children: [
    
//             CustomScrollView(
//               physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
    
//                 SliverAppBar(
//                   backgroundColor: Colors.transparent,
//                   elevation: 0.0,
//                   title: Text("PPOB",
//                     style: robotoRegular.copyWith(
//                       color: ColorResources.black,
//                       fontSize: Dimensions.fontSizeDefault
//                     ),
//                   ),
//                   centerTitle: true,
//                   pinned: true,
//                   leading: CupertinoNavigationBarBackButton(
//                     color: ColorResources.black,
//                     onPressed: () {
//                       NS.pop(context);
//                     },
//                   )
//                 ),
    
//                 SliverPadding(
//                   padding: const EdgeInsets.only(
//                     top: 20.0, 
//                     bottom: 60.0
//                   ),
//                   sliver: SliverList(
//                     delegate: SliverChildListDelegate([
    
//                       Container(
//                         margin: const EdgeInsets.only(
//                           top: Dimensions.marginSizeSmall,
//                           left: Dimensions.marginSizeDefault,
//                           right: Dimensions.marginSizeDefault,
//                         ),
//                         height: 110.0,
//                         child: StaggeredGridView.countBuilder(
//                           crossAxisCount: 3,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           padding: EdgeInsets.zero,
//                           itemCount: ppobs.length,
//                           staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1.0),
//                           itemBuilder: (BuildContext context, int i) {
//                             return Container(
//                               margin: const EdgeInsets.all(Dimensions.marginSizeSmall),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: selected == i 
//                                 ? ColorResources.primaryOrange
//                                 : ColorResources.white,
//                                 gradient: selected == i 
//                                 ? const LinearGradient(
//                                     colors: [
//                                       Color(0xffFF6502),
//                                       Color(0xffFFAF00),
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     tileMode: TileMode.clamp
//                                   ) 
//                                 : null
//                               ),
//                               child: Material(
//                                 color: Colors.transparent,
//                                 child: InkWell(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   onTap: () {
//                                     setState(() {
//                                       selected = i;
//                                     });
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Image.asset("${ppobs[i]["image"]}",
//                                           width: 30.0,
//                                           height: 30.0,
//                                           color: selected == i 
//                                           ? ColorResources.white  
//                                           : ColorResources.primaryOrange,
//                                         ),
//                                         const SizedBox(height: 10.0),
//                                         Text(getTranslated(ppobs[i]["name"], context),
//                                           textAlign: TextAlign.center,
//                                           style: robotoRegular.copyWith(
//                                             fontSize: Dimensions.fontSizeSmall,
//                                             color: selected == i 
//                                             ? ColorResources.white  
//                                             : ColorResources.primaryOrange
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
    
//                     ])
//                   ),
//                 )
    
//               ],
//             ),
    
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: const EdgeInsets.only(
//                   left: Dimensions.marginSizeDefault,
//                   right: Dimensions.marginSizeDefault,
//                   bottom: Dimensions.marginSizeDefault
//                 ),
//                 child: CustomButton(
//                   onTap: selected == -1 ? () { }  
//                   : () {
//                     switch (selected) {
//                       case 0:
//                         NS.push(context, VoucherPulsaByPrefixScreen(key: UniqueKey()));
//                       break;
//                       case 1:   
//                         // NS.push(context, VoucherEmoneyScreen(key: UniqueKey()));
//                       break;
//                       case 2: 
//                         NS.push(context, PlnScreen(key: UniqueKey()));
//                       break;
//                       default:
//                     }
//                   },
//                   isBorderRadius: true,
//                   isBorder: false,
//                   isBoxShadow: false,
//                   height: 40.0,
//                   loadingColor: ColorResources.white,
//                   btnTextColor: ColorResources.white,
//                   btnColor: selected == -1 
//                   ? ColorResources.grey
//                   : ColorResources.primaryOrange,
//                   btnTxt: getTranslated("CONTINUE", context),
//                 ),
//               ),
//             )
    
//           ],
//         )
//         ),
//     );
      
//   }
// }