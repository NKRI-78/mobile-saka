import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:saka/localization/language_constraints.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';
import 'package:saka/views/screens/ppob/topup/history/detail.dart';

class TopUpHistoryScreen extends StatefulWidget {
  const TopUpHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TopUpHistoryScreen> createState() => _TopUpHistoryScreenState();
}

class _TopUpHistoryScreenState extends State<TopUpHistoryScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  String? startDate = "";
  String? endDate = "";

  @override
  void initState() {
    super.initState();

    startDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 7)).toString();
    endDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).toString();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return buildUI();  
  }
  
  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(
              title: getTranslated("HISTORY_TRANSACTION", context), 
              isBackButtonExist: true
            ),

            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 0.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      StatefulBuilder(
                        builder: (BuildContext context, Function setState) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 10.0, 
                              left: 16.0, 
                              right: 16.0
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorResources.grey
                              )
                            ),
                            child: DateTimePicker(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, 
                                    width: 0.5
                                  ),
                                ),
                                hintText: getTranslated("SELECT_DATE", context)
                              ),
                              initialValue: startDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onChanged: (String val) {
                                setState(() => startDate = val);
                              },
                            ),
                          );
                        }, 
                      ),

                      const SizedBox(height: 10.0),

                      StatefulBuilder(
                        builder: (BuildContext context, Function setState) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 10.0, 
                              left: 16.0, 
                              right: 16.0
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.0,
                                color: ColorResources.grey
                              )
                            ),
                            child: DateTimePicker(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey, 
                                    width: 0.5
                                  ),
                                ),
                                hintText: getTranslated("SELECT_DATE", context)
                              ),
                              initialValue: endDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onChanged: (String val) {
                                setState(() => endDate = val);
                              },
                            ),
                          );
                        }
                      ),

                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          top: 20.0, 
                          left: 16.0,
                          right: 16.0,
                          bottom: 20.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            NS.push(context, HistoryTopUpTransaksiListScreen(startDate: startDate, endDate: endDate));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(ColorResources.primaryOrange),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )
                            )
                          ),
                          child: Text("Submit",
                            style: robotoRegular.copyWith(
                              color: ColorResources.white
                            ),
                          )
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}