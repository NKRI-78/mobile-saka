import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => ComplaintScreenState();
}

class ComplaintScreenState extends State<ComplaintScreen> {

  late EcommerceProvider ep;

  @override 
  void initState() {
    super.initState();
    
    ep = context.read<EcommerceProvider>();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: ColorResources.white,
          boxShadow: kElevationToShadow[1]
        ),
        child: CustomButton(
          onTap: () {},
          isBorder: false,
          isBorderRadius: true,
          isBoxShadow: false,
          btnTxt: "Submit",
        )
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [

          SliverAppBar(
            title: Text("Komplain",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black
              ),
            ),
            leading: BackButton(
              color: ColorResources.black,
              onPressed: () {
                NS.pop();
              },
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([

              Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 16.0,
                  right: 16.0
                ),
                child: TextField(
                  maxLength: 150,
                  minLines: 3,
                  maxLines: null,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black
                  ),
                  decoration: InputDecoration(
                    hintText: "Sertakan alasan untuk pengembalian barang",
                    hintStyle: robotoRegular,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black
                      )
                    )
                  ),
                ),
              )

            ])
          )

        ],
      )
    );
  }

}