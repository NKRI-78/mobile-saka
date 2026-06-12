import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:saka/data/models/event/event.dart';

import 'package:saka/providers/event/event.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

class DetailEventScreen extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final bool join;
  final List<Join> joins;
  final String imageUrl;
  final DateTime date;

  const DetailEventScreen({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.join,
    required this.joins,
    required this.imageUrl,
    required this.date,
  });

  @override
  DetailEventPageState createState() => DetailEventPageState();
}

class DetailEventPageState extends State<DetailEventScreen> {
  late ScrollController scrollController;

  String? imageUrl;
  String? title;
  String? content;
  String? titleMore;
  DateTime? date;

  bool lastStatus = true;

  void scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return scrollController.hasClients && scrollController.offset > (250 - kToolbarHeight);
  }

  DateTime _toLocalEventDate(DateTime value) {
    if (value.isUtc) {
      return value.toLocal();
    }

    return value;
  }

  String _formatEventDate(DateTime value) {
    final DateTime localDate = _toLocalEventDate(value);

    return DateFormat('dd MMM yyyy HH:mm').format(localDate);
  }

  String _formatLocation(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Lokasi belum tersedia';
    }

    return trimmed;
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(scrollListener);

    if (widget.title.length > 24) {
      titleMore = widget.title.substring(0, 24);
    } else {
      titleMore = widget.title;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageUrl = widget.imageUrl;
    title = widget.title;
    content = widget.content;
    date = _toLocalEventDate(widget.date);

    final eventProvider = context.watch<EventProvider>();

    final currentEvent = eventProvider.eventData.cast<EventData?>().firstWhere(
      (e) => e?.eventId == widget.id,
      orElse: () => null,
    );

    final bool isJoined = currentEvent?.join ?? widget.join;
    final List<Join> participantList = currentEvent?.joins ?? widget.joins;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: isShrink ? Colors.black : Colors.white),
            pinned: true,
            expandedHeight: 250.0,
            leading: GestureDetector(
              onTap: eventProvider.eventJoinStatus == EventJoinStatus.loading
                  ? () {}
                  : () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isShrink ? null : Colors.black54,
                ),
                child: Center(
                  child: Platform.isIOS
                      ? Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: const Icon(Icons.arrow_back_ios),
                        )
                      : const Icon(Icons.arrow_back),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: "$imageUrl",
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (BuildContext context, String url, error) => Center(
                          child: Image.asset(
                            "assets/images/profile.png",
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: AnimatedOpacity(
                opacity: isShrink ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Text(
                  "${titleMore!}...",
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5.0),
                          child: AnimatedOpacity(
                            opacity: isShrink ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              title!,
                              textAlign: TextAlign.start,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _formatEventDate(date!),
                            style: robotoRegular.copyWith(
                              color: Colors.grey,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1.5),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Expanded(
                                child: Text(
                                  _formatLocation(currentEvent?.location ?? ''),
                                  style: robotoRegular.copyWith(
                                    color: Colors.grey,
                                    fontSize: Dimensions.fontSizeDefault,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: isJoined
                                    ? () {}
                                    : () async {
                                        await context.read<EventProvider>().joinEvent(
                                          eventId: widget.id,
                                        );
                                      },
                                isLoading: eventProvider.eventJoinStatus == EventJoinStatus.loading,
                                height: 40.0,
                                btnColor: isJoined
                                    ? ColorResources.greyDarkPrimary
                                    : ColorResources.primaryOrange,
                                isBoxShadow: false,
                                isBorder: false,
                                isBorderRadius: true,
                                btnTxt: "Gabung Event",
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return const Divider();
                                        },
                                        padding: const EdgeInsets.all(20.0),
                                        itemCount: participantList.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: participantList[i].profilePic,
                                                imageBuilder: (context, imageProvider) {
                                                  return CircleAvatar(
                                                    maxRadius: 20.0,
                                                    backgroundImage: imageProvider,
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  return const CircleAvatar(
                                                    maxRadius: 20.0,
                                                    backgroundImage: AssetImage(
                                                      'assets/images/default_avatar.jpg',
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, url) {
                                                  return const CircleAvatar(
                                                    maxRadius: 20.0,
                                                    backgroundImage: AssetImage(
                                                      'assets/images/default_avatar.jpg',
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 10.0),
                                              Text(
                                                participantList[i].fullname,
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Peserta (${participantList.length})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    const Divider(height: 4.0, thickness: 1.0),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Text(
                        content!,
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(height: 1.8),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
