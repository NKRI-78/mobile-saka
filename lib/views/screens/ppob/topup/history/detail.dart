import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/localization/language_constraints.dart';
import 'package:saka/providers/ppob/ppob.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class HistoryTopUpTransaksiListScreen extends StatefulWidget {

  final String? startDate;
  final String? endDate;

  const HistoryTopUpTransaksiListScreen({Key? key, 
    this.startDate,
    this.endDate
  }) : super(key: key);

  @override
  State<HistoryTopUpTransaksiListScreen> createState() => _HistoryTopUpTransaksiListScreenState();
}

class _HistoryTopUpTransaksiListScreenState extends State<HistoryTopUpTransaksiListScreen> {

  @override 
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<PPOBProvider>(context, listen: false).getHistoryBalance(context, widget.startDate!, widget.endDate!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomAppBar(title: getTranslated("HISTORY_TRANSACTION_DETAIL", context), isBackButtonExist: true),

            Consumer<PPOBProvider>(
              builder: (BuildContext context, PPOBProvider ppobProvider, Widget? child) {
                
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.loading) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Loader(
                          color: ColorResources.primaryOrange
                        )
                      ],
                    ),
                  );
                }
                if(ppobProvider.historyBalanceStatus == HistoryBalanceStatus.empty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(getTranslated("YOU_DONT_HAVE_TRANSACTION", context),
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault, 
                              color: ColorResources.black
                            ),
                          ),
                        ]
                      )
                    ),
                  );
                }
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: ppobProvider.historyBalanceData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ppobProvider.historyBalanceData[i].type!,
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black, 
                                      fontSize: Dimensions.fontSizeDefault
                                    )
                                  ),
                                  Text(Helper.formatCurrency(double.parse(ppobProvider.historyBalanceData[i].amount.toString())).toString(),
                                  style: robotoRegular.copyWith(
                                    color: ppobProvider.historyBalanceData[i].type != "CREDIT" ? ColorResources.error : ColorResources.success, fontSize: Dimensions.fontSizeDefault)                                  
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(ppobProvider.historyBalanceData[i].description!,
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black, 
                                  fontSize: ppobProvider.historyBalanceData[i].type != "CREDIT" ? Dimensions.fontSizeSmall :  Dimensions.fontSizeDefault 
                                )
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text(Helper.formatDate(DateTime.parse(ppobProvider.historyBalanceData[i].created!)),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black, 
                                  fontSize: Dimensions.fontSizeSmall
                                )
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return const Divider(
                          thickness: 1.0,
                        );
                      },
                    ),
                  ),
                );
              },            
            ),

          ],
        ),
      ),
    );
  }
}