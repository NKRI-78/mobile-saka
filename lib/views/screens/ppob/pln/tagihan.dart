// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:saka/views/basewidgets/loader/circular.dart';
// import 'package:provider/provider.dart';

// import 'package:saka/utils/color_resources.dart';
// import 'package:saka/utils/custom_themes.dart';
// import 'package:saka/utils/dimensions.dart';
// import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
// import 'package:saka/providers/ppob/ppob.dart';

// class TagihanListrikScreen extends StatefulWidget {
//   const TagihanListrikScreen({Key? key}) : super(key: key);

//   @override
//   _TagihanListrikScreenState createState() => _TagihanListrikScreenState();
// }

// class _TagihanListrikScreenState extends State<TagihanListrikScreen> {
//   bool next = false;
//   Timer? debounce;
//   late TextEditingController idPelangganController;

//   idPelangganNumberChange() {
//     if(idPelangganController.text.length >= 10) {
//       setState(() => next = true);
//       if (debounce?.isActive ?? false) debounce!.cancel();
//       debounce = Timer(const Duration(milliseconds: 500), () {
//         Provider.of<PPOBProvider>(context, listen: false).postInquiryPLNPascaBayar(context, idPelangganController.text, idPelangganController, idPelangganNumberChange);
//       });
//     } else {
//       setState(() => next = false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();  
//     idPelangganController = TextEditingController();
//     idPelangganController.addListener(idPelangganNumberChange);
//   }

//   @override
//   void dispose() {
//     debounce?.cancel();
//     idPelangganController.removeListener(idPelangganNumberChange);
//     idPelangganController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResources.bgGrey,
//       body: Column(
//         children: [

//           const CustomAppBar(title: "Tagihan Listrik"),
          
//           Container(
//             color: ColorResources.white,
//             padding: const EdgeInsets.all(10.0),
//             width: double.infinity,
//             height: 120.0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 10.0, left: 14.0),
//                   child: Text("ID Pelanggan",
//                     style: robotoRegular.copyWith(
//                       fontSize: Dimensions.fontSizeSmall,
//                       color: ColorResources.black
//                     )
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 8.0, left: 10.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(10.0)
//                   ),
//                   child: TextField(
//                     controller: idPelangganController,
//                     keyboardType: TextInputType.phone,
//                     style: robotoRegular.copyWith(
//                       fontSize: Dimensions.fontSizeSmall,
//                       color: ColorResources.black
//                     ),
//                     decoration: InputDecoration(
//                       hintText: "Contoh 1234567890",
//                       hintStyle: robotoRegular.copyWith(
//                         fontSize: Dimensions.fontSizeSmall,
//                         color: ColorResources.hintColor
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 16.0, 
//                         horizontal: 22.0
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(
//                           style: BorderStyle.none, 
//                           width: 0
//                         ),
//                       ),
//                       isDense: true
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),

//           Consumer<PPOBProvider>(
//             builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
//               if(ppobProvider.inquiryPLNPascabayarStatus == InquiryPLNPascabayarStatus.loading) {
//                   return const Expanded(
//                     child: Loader(
//                       color: ColorResources.primaryOrange,
//                     ),
//                   );
//               }
//               return Container();
//             },
//           )

//         ],
//       ),
//     );
//   }
// }