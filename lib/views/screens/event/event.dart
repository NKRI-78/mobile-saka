import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/services/navigation.dart';
import 'package:saka/views/screens/event/detail.dart';

import 'package:saka/providers/event/event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen> {

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  late EventProvider ep;
  
  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {   

    final kEvents = LinkedHashMap<DateTime, List<Map<String, dynamic>>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(ep.events);
  
    return kEvents[day] ?? [];

  }

  void onDaySelected(DateTime selectedDayParam, DateTime focusedDayParam) {
    if (!isSameDay(selectedDay, selectedDayParam)) {
      setState(() {
        selectedDay = selectedDayParam;
        focusedDay = focusedDayParam;
      });

      ep.updateSelectedDate(selectedDayParam);
      ep.addSelectedEvents(getEventsForDay(selectedDayParam));
    }
  }


  Future<void> getData() async {
    if(!mounted) return;
      ep.getEvent();
  }

  @override
  void initState() {
    super.initState();

    ep = context.read<EventProvider>();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    DateTime kToday = DateTime.now();
    DateTime kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    DateTime kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorResources.white,
        title: Text("Kegiatan",
          style: robotoRegular.copyWith(
            color: ColorResources.black,
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.fontSizeDefault
          ),
        ),
      ),
      body: Consumer<EventProvider>(
         builder: (context, EventProvider notifier,  Widget? child) {
           return CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics() 
            ),
            slivers: [

              if(notifier.eventStatus == EventStatus.loading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator()
                    )
                  )
                ),

              if(notifier.eventStatus == EventStatus.loaded)
                SliverToBoxAdapter(
                  child: TableCalendar<Map<String, dynamic>>(
                    locale: 'id_ID',
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: focusedDay,
                    daysOfWeekHeight: 20.0,
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        return events.isNotEmpty 
                        ? Container(
                          margin: EdgeInsets.only(
                            top: 45.0,
                            left: 15.0,
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 5.0,
                                height: 5.0,
                                margin: EdgeInsets.only(
                                  left: 1.0,
                                  right: 1.0
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox();
                      },
                      todayBuilder: (context, _, __) {
                        return Container(
                          alignment: Alignment.center,
                          width: 45.0,
                          height: 45.0,
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff5690FF),
                            border: Border.all(
                              color: const Color(0xffFFFFFF),
                              width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Text("${DateTime.now().day}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (_, day, __) {
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: EdgeInsets.zero,
                          child: Text("${day.day}",
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (_, __, focusedDay) {
                        return Container(
                          alignment: Alignment.center,
                          width: 45.0,
                          height: 45.0,
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff5690FF),
                              width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Text("${focusedDay.day}",
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        );
                      },
                    ),
                    headerStyle: HeaderStyle(
                      leftChevronIcon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: kElevationToShadow[4]
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.chevron_left,
                          size: 30.0,
                          color: Colors.black,  
                        )
                      ),
                      rightChevronIcon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: kElevationToShadow[4]
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.chevron_right,
                          size: 30.0,
                          color: Colors.black,
                        )
                      ),
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      formatButtonVisible: false,
                    ),
                    selectedDayPredicate: (DateTime day) => isSameDay(selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    eventLoader: getEventsForDay,
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: true,
                    ),
                    onDaySelected: onDaySelected,
                    onPageChanged: (DateTime val) {
                      focusedDay = val;
                    },
                  ),
                ),
                            
              if(notifier.eventStatus == EventStatus.loaded)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int i) {
                      return GestureDetector(
                        onTap: () {
                          NS.push(context, DetailEventScreen(
                            id: notifier.selectedEvents[i]["id"],
                            join: notifier.selectedEvents[i]["join"],
                            joins: notifier.selectedEvents[i]["joins"],
                            title: notifier.selectedEvents[i]["name"], 
                            content: notifier.selectedEvents[i]["content"], 
                            imageUrl: notifier.selectedEvents[i]["attachment"], 
                            date: notifier.selectedEvents[i]["createdAt"]
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 15.0, 
                            left: 30.0,
                            right: 30.0,
                            bottom: 15.0
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: kElevationToShadow[3],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CachedNetworkImage(
                                imageUrl: notifier.selectedEvents[i]["attachment"].toString(),
                                imageBuilder: (_, imageProvider) {
                                  return Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  );
                                },
                                errorWidget: (__, ___, _) {
                                  return Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/default_image.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (_, __) {
                                  return Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage('assets/images/default_image.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 350.0,
                                padding: const EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            notifier.selectedEvents[i]["name"].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.navigate_next,
                                      size: 30.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: notifier.selectedEvents.length,
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: ListView.builder(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: notifier.selectedEvents.length,
                //     itemBuilder: (BuildContext context, int i) {
                //       return GestureDetector(
                //         onTap: () {
                //           NS.push(context, DetailEventScreen(
                //             title: notifier.selectedEvents[i]["name"], 
                //             content: notifier.selectedEvents[i]["content"], 
                //             imageUrl: notifier.selectedEvents[i]["attachment"], 
                //             date: notifier.selectedEvents[i]["createdAt"]
                //           ));
                //         },
                //         child: Container(
                //           margin: EdgeInsets.only(
                //             top: 15.0,
                //             left: 30.0,
                //             right: 30.0,
                //             bottom: 15.0
                //           ),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(30.0),
                //             boxShadow: kElevationToShadow[3]
                //           ),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                        
                //               CachedNetworkImage(
                //                 imageUrl: notifier.selectedEvents[i]["attachment"].toString(),
                //                 imageBuilder: (_, imageProvider) {
                //                   return Container(
                //                     height: 200.0,
                //                     decoration: BoxDecoration(
                //                       borderRadius: const BorderRadius.only(
                //                         topLeft: Radius.circular(30.0),
                //                         topRight: Radius.circular(30.0)
                //                       ),
                //                       image: DecorationImage(
                //                         image: imageProvider,
                //                         fit: BoxFit.fitWidth
                //                       )
                //                     ),
                //                   );
                //                 },
                //                 errorWidget: (__, ___, _) {
                //                   return Container(
                //                     height: 200.0,
                //                     decoration: BoxDecoration(
                //                       borderRadius: const BorderRadius.only(
                //                         topLeft: Radius.circular(30/0),
                //                         topRight: Radius.circular(30.0)
                //                       ),
                //                       image: DecorationImage(
                //                         image: AssetImage('assets/images/default_image.png'),
                //                         fit: BoxFit.fitWidth
                //                       )
                //                     ),
                //                   );
                //                 },
                //                 placeholder: (_, __) {
                //                   return Container(
                //                     height: 200.0,
                //                     decoration: BoxDecoration(
                //                       borderRadius: const BorderRadius.only(
                //                         topLeft: Radius.circular(30.0),
                //                         topRight: Radius.circular(30.0)
                //                       ),
                //                       image: DecorationImage(
                //                         image: AssetImage('assets/images/default_image.png'),
                //                         fit: BoxFit.fitWidth
                //                       )
                //                     ),
                //                   );
                //                 },
                //               ),
                        
                //               Container(
                //                 width: 350.0,
                //                 padding:const  EdgeInsets.all(10.0),
                //                 margin: EdgeInsets.only(
                //                   left: 15.0,
                //                   right: 15.0
                //                 ),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   mainAxisSize: MainAxisSize.max,
                //                   children: [
                                        
                //                     Expanded(
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         mainAxisSize: MainAxisSize.min,
                //                         children: [
                                                                
                //                           Text(notifier.selectedEvents[i]["name"].toString(),
                //                             overflow: TextOverflow.ellipsis,
                //                             style: TextStyle(
                //                               fontWeight: FontWeight.bold,
                //                               fontSize: 14.0
                //                             ),
                //                           ),
                                      
                //                         ],
                //                       ),
                //                     ),
                                        
                //                     const Icon(
                //                       Icons.navigate_next,
                //                       size: 30.0,
                //                     )
                                        
                //                   ],
                //                 ),
                //               )
                //             ],
                //           )
                //         ),
                //       );
                //     }
                //   ),
                // )
           
            ],
          );
        }
      )
    );
  }
}
