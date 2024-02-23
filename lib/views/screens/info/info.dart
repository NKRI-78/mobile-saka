import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';

import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class InfoScreen extends StatefulWidget {

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            CustomAppBar(title: "Info"),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Card(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: ColorResources.primaryOrange,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () {},
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600 
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(     
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 6.0, left: 5.0, bottom: 15.0),
                            child: SizedBox(
                              child: IconButton(
                                onPressed: () => Navigator.of(context).pushNamed("/search-slb"),
                                icon: Icon(Icons.search),
                                color: Colors.white,
                              ),
                            ),
                          ),          
                          hintText: "Cari Bengkel", 
                          hintStyle: TextStyle(
                            color: Colors.white
                          ), 
                          contentPadding: EdgeInsets.only(
                            left: 18.0,
                            top: 18.0,
                            right: 18.0,
                            bottom: 18.0
                          ),
                          border: InputBorder.none,
                        ),
                      ) 
                    ),
                  )
                ),
              )
            )

          ],
        )
      ),
    );
  }
}