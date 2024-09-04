import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';


class InboxDetailScreen extends StatefulWidget {
  final String? inboxId;
  final String? recepientId; 
  final String? senderId;
  final String? subject;
  final String? body;
  final String? type;
  final String? typeInbox;
  final String? field1;
  final String? field2;
  final String? field3;
  final String? field4;
  final String? field5;
  final String? field6;
  final String? field7;
  final bool? read;
  final DateTime? created;
  final DateTime? updated;

  const InboxDetailScreen({
    required this.inboxId,
    required this.recepientId, 
    required this.senderId,
    required this.subject,
    required this.body,
    required this.type,
    required this.typeInbox,
    required this.field1,
    required this.field2,
    required this.field3,
    required this.field4,
    required this.field5,
    required this.field6,
    required this.field7,
    required this.read,
    required this.created,
    required this.updated,
    Key? key
  }) : super(key: key);

  @override
  State<InboxDetailScreen> createState() => InboxDetailScreenState();
}

class InboxDetailScreenState extends State<InboxDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [

          SliverAppBar(
            backgroundColor: ColorResources.primaryOrange,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: CupertinoNavigationBarBackButton(
              color: ColorResources.white,
              onPressed: () {
                NS.pop(context);
              },
            ),
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(widget.subject!,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600,
                color: ColorResources.white
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([

              Container(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault, 15.0, 
                  Dimensions.paddingSizeDefault, 20.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  mainAxisSize: MainAxisSize.min,
                  children: [

                      Text(DateFormat('dd MMM yyyy kk:mm').format(widget.created!.toLocal()), 
                        style: poppinsRegular.copyWith(
                          color: ColorResources.black, 
                          fontSize: Dimensions.fontSizeDefault
                        )
                      ),
                 
                    ]
                  ),
                ),

              ]
            )
          ),
        ],
      )
    );
  }

}