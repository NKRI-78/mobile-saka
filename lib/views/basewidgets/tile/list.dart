import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/views/screens/ppob/cashout/setaccount.dart';
import 'package:saka/providers/ppob/ppob.dart';
import 'package:saka/views/basewidgets/appbar/custom_appbar.dart';

class ListTileComponent extends StatefulWidget {
  final String? title;
  final List? items;

  const ListTileComponent({Key? key, 
    this.title,
    this.items
  }) : super(key: key);

  @override
  _ListTileComponentState createState() => _ListTileComponentState();
}

class _ListTileComponentState extends State<ListTileComponent> {
  
  int? selected;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomAppBar(
              title: widget.title!, 
              isBackButtonExist: true
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: StatefulBuilder(
                  builder: (BuildContext context, Function s) {
                    return ListView.separated(
                      itemCount: widget.items!.length,
                      separatorBuilder: (BuildContext context, int i) {
                        return const Divider();
                      },
                      itemBuilder: (BuildContext context, int i) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CashoutSetAccountScreen(
                                    title: widget.title,
                                  )),
                                );
                                s(() {
                                  Provider.of<PPOBProvider>(context, listen: false).changePaymentMethod(widget.items![i].name, widget.items![i].code.toString());
                                  selected = i;                   
                                });
                              },
                              dense: true,
                              leading: Text(widget.items![i].name),
                              trailing: Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  shape: BoxShape.circle
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    color: selected == i ? Colors.grey : Colors.transparent,
                                    border: Border.all(color: Colors.transparent),
                                    shape: BoxShape.circle
                                  )
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    );
                  }
                )
              )
            )

          ],
        ),
      ),
    );
  }
}
