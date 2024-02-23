import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/data/models/event/event.dart';

import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/color_resources.dart';

import 'package:saka/providers/event/event.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
    this.eventName, 
    this.eventDesc,
    this.eventLocation,
    this.eventImage,
    this.eventId,
    this.from, 
    this.to, 
    this.background, 
    this.isAllDay,
    this.startHour,
    this.endHour
  );

  String eventName;
  String eventDesc;
  String eventLocation;
  String eventImage;
  int eventId;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String startHour;
  String endHour;
}

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  int yearNow = DateTime.now().year;
  int monthNow = DateTime.now().month;
  int dayNow = DateTime.now().day;

  List<Meeting> getDataSource(BuildContext context, List<EventData> events) {
    List<Meeting> meetings = [];
    for (int i = 0; i < events.length; i++) {
      meetings.add(Meeting(
        events[i].summary!,
        events[i].description!,
        events[i].location!,
        events[i].path!,
        events[i].eventId!,
        events[i].eventDate!,
        events[i].eventDate!,
        ColorResources.brown,
        true,
        events[i].start!,
        events[i].end!
      ));
    }
    return meetings;
  }

  late EventProvider ep;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        ep.getEvent(context);
      }
    });
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
    return Builder(
      builder: (BuildContext context) {
        ep = context.read<EventProvider>();
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: ColorResources.white,
            title: Text("Event",
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Consumer<EventProvider>(
                builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
                  if(eventProvider.eventStatus == EventStatus.loading) {
                    return const Expanded(
                      child: Loader(
                        color: ColorResources.brown,
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(
                      left: Dimensions.marginSizeSmall, 
                      right: Dimensions.marginSizeSmall
                    ),
                    child: SfCalendar(
                      initialSelectedDate: DateTime.now(),
                      minDate: DateTime(yearNow, monthNow - 12, dayNow),
                      maxDate: DateTime(yearNow, monthNow + 1, dayNow),
                      initialDisplayDate: null,
                      allowAppointmentResize: true,
                      showDatePickerButton: true,
                      headerHeight: 60.0,
                      todayHighlightColor: ColorResources.brown,
                      headerStyle: CalendarHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: robotoRegular.copyWith(
                          color: ColorResources.brown
                        ),
                        backgroundColor: Colors.white
                      ),
                      dataSource: MeetingDataSource(getDataSource(context, eventProvider.eventData)),             
                      viewHeaderStyle: ViewHeaderStyle(
                        backgroundColor: ColorResources.brown,
                        dayTextStyle: robotoRegular.copyWith(
                          color: ColorResources.white,
                          fontSize: Dimensions.fontSizeExtraSmall
                        ),
                      ),
                      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                        DateTime now = DateTime.now();
                        DateTime date = DateTime(now.year, now.month, now.day);
                        if(details.appointments.isNotEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text(details.date.day.toString(),
                                    textAlign: TextAlign.center,
                                    style: robotoRegular.copyWith(
                                      color: details.date == date 
                                      ? ColorResources.blue 
                                      : ColorResources.brown,
                                      fontSize: Dimensions.fontSizeSmall
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: const BoxDecoration(
                                  color: ColorResources.success,
                                  shape: BoxShape.circle
                                ),
                              )
                            ],
                          );
                        }
                        if(details.date.isBefore(date)) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(details.date.day.toString(),
                              textAlign: TextAlign.center,
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            ),
                          );
                        }
                        if(details.date == date) {
                          return Center(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: ColorResources.white,
                                shape: BoxShape.circle
                              ),
                              child: Text(details.date.day.toString(),
                                textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(
                                  color: details.date == date 
                                  ? ColorResources.black
                                  : ColorResources.brown,
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4.5),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(details.date.day.toString(),
                            textAlign: TextAlign.center,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          ),
                        );
                      },
                      monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                        showTrailingAndLeadingDates: false,
                      ),
                      onTap: (CalendarTapDetails calendarTapDetails) {
                        if(calendarTapDetails.appointments!.isNotEmpty) {
                          Meeting meeting = calendarTapDetails.appointments![0];
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "${AppConstants.baseUrlFeedImg}/${meeting.eventImage}",
                                            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                              return Container(
                                                width: double.infinity,
                                                height: 200.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  image: DecorationImage(
                                                    image: imageProvider
                                                  )
                                                ),
                                              );
                                            },
                                            errorWidget: (BuildContext context, String url, dynamic error) {
                                              return Container(
                                                width: double.infinity,
                                                height: 200.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/default_image.png')
                                                  )
                                                ),
                                              );
                                            },
                                            placeholder: (BuildContext context, dynamic url) {
                                              return Container(
                                                width: double.infinity,
                                                height: 200.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/images/default_image.png')
                                                  )
                                                ),
                                              );
                                            },
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(getTranslated("START", context),
                                                      style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeDefault,
                                                        fontWeight: FontWeight.w600
                                                      )
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(meeting.startHour,
                                                      style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeSmall,
                                                      )
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(getTranslated("END", context),
                                                      style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeDefault,
                                                        fontWeight: FontWeight.w600
                                                      )
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(meeting.endHour,
                                                      style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeSmall,
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(top: 10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(getTranslated("DESCRIPTION", context),
                                                  style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                                const SizedBox(height: 6.0),
                                                Text(meeting.eventDesc,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeSmall
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Consumer<EventProvider>(
                                          //   builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
                                          //     return SizedBox(
                                          //       width: double.infinity,
                                          //       child:TextButton(
                                          //         style: TextButton.styleFrom(
                                          //           backgroundColor: ColorResources.brown
                                          //         ),
                                          //         onPressed: () async {
                                          //           await eventProvider.joinEvent(context, eventId: meeting.eventId);
                                          //         },
                                          //         child: eventProvider.eventJoinStatus == EventJoinStatus.loading 
                                          //         ? const Loader(
                                          //             color: ColorResources.white,
                                          //           ) 
                                          //         : Text(getTranslated("JOIN", context),
                                          //           style: robotoRegular.copyWith(
                                          //             color: ColorResources.white,
                                          //             fontSize: Dimensions.fontSizeSmall
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     );
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            );
                          },
                            animationType: DialogTransitionType.scale,
                            curve: Curves.fastOutSlowIn,
                            duration: const Duration(seconds: 1),
                          ); 
                        }
                      }, 
                      timeZone:'SE Asia Standard Time',
                      view: CalendarView.month,
                      selectionDecoration: BoxDecoration(
                        border: Border.all(
                          color: ColorResources.brown
                        ),
                        shape: BoxShape.circle,
                      ),
                      showNavigationArrow: true,
                    ),
                  );
                },
              ),

            ],
          )
        );
      },
    );
  }
}
