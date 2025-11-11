import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saka/services/navigation.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:timelines_plus/timelines_plus.dart';

import 'package:saka/data/models/ecommerce/order/tracking.dart';
import 'package:saka/providers/ecommerce/ecommerce.dart';

class TrackingScreen extends StatelessWidget {
  final String waybill;

  const TrackingScreen({
    required this.waybill,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics()
      ),
      slivers: [

        SliverAppBar(
          centerTitle: true,
          title: Text("Tracking",
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.bold,
              color: ColorResources.black
            ),
          ),
          leading: BackButton(
            color: ColorResources.brown,
            onPressed: () {
              NS.pop();
            },
          ),
        ),

        FutureBuilder<TrackingModel>(
          future: context.read<EcommerceProvider>().trackingOrder(waybill: waybill), 
          builder: (BuildContext context, AsyncSnapshot<TrackingModel> snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
            return SliverFillRemaining(
              hasScrollBody: true,
              child: Center(
                child: SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: CircularProgressIndicator.adaptive()
                ),
              ),
            );
          }
        
          TrackingModel trackingModel = snapshot.data!;

          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  left: 16.0,
                  right: 16.0
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FixedTimeline.tileBuilder(
                      theme: TimelineThemeData(
                        color: ColorResources.purple
                      ),
                      builder: TimelineTileBuilder.connectedFromStyle(
                        contentsAlign: ContentsAlign.alternating,
                        oppositeContentsBuilder: (BuildContext context, int index) => const SizedBox(),
                        contentsBuilder: (BuildContext context, int index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(trackingModel.data.histories![index].desc,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault
                                ),
                              ),
                              
                              const SizedBox(height: 10.0),

                              Text(trackingModel.data.histories![index].date,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                              )
                            ],  
                          ))
                        ),
                        connectorStyleBuilder: (BuildContext context, int index) => ConnectorStyle.solidLine,
                        indicatorStyleBuilder: (BuildContext context, int index) => IndicatorStyle.dot, itemCount: trackingModel.data.histories!.length)),
                      ),
                    ),
                  ),
                ),
              );
              
            },
          )
        ],
      )
    );
  }
}