// ignore_for_file: use_build_context_synchronously
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog_updated/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

import 'package:saka/services/navigation.dart';
import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/inbox/inbox.dart';
import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/images.dart';

import 'package:saka/views/screens/inbox/detail.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  InboxScreenState createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _tabName = 'sos'; // hanya 'sos' atau 'other'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    // load awal
    Future.microtask(() {
      if (!mounted) return;
      context.read<InboxProvider>().getInbox(context, _tabName);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _switchTab(int index) async {
    setState(() {
      _tabName = (index == 0) ? 'sos' : 'other';
    });
    await context.read<InboxProvider>().getInbox(context, _tabName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: ColorResources.brown,
              title: Text(
                getTranslated('INBOX', context),
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.white,
                ),
              ),
              elevation: 0,
              pinned: false,
              centerTitle: true,
              floating: true,
              automaticallyImplyLeading: false,
            ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                onTap: _switchTab,
                unselectedLabelColor: Colors.grey,
                labelColor: ColorResources.white,
                labelStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BubbleTabIndicator(
                  indicatorHeight: 32.0,
                  indicatorRadius: 6.0,
                  indicatorColor: ColorResources.brown,
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                tabs: const [
                  Tab(text: 'SOS'),
                  Tab(text: 'Lainnya'),
                ],
              ),
            ),
          ];
        },
        body: _InboxList(type: _tabName),
      ),
    );
  }
}

class _InboxList extends StatelessWidget {
  final String type;
  const _InboxList({required this.type});

  Future<void> _refresh(BuildContext context) async {
    await context.read<InboxProvider>().getInbox(context, type);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InboxProvider>(
      builder: (context, inboxProvider, _) {
        final status = inboxProvider.inboxStatus;

        if (status == InboxStatus.loading) {
          return const Center(child: Loader(color: ColorResources.primaryOrange));
        }

        if (status == InboxStatus.error) {
          return Center(
            child: Text(
              getTranslated('THERE_WAS_PROBLEM', context),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          );
        }

        if (status == InboxStatus.empty) {
          // tetap bisa pull-to-refresh walau kosong
          return RefreshIndicator(
            backgroundColor: ColorResources.brown,
            color: ColorResources.white,
            onRefresh: () => _refresh(context),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Text(
                      'Belum ada pesan',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // success
        final items = inboxProvider.inboxes;
        return RefreshIndicator(
          backgroundColor: ColorResources.brown,
          color: ColorResources.white,
          onRefresh: () => _refresh(context),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final it = items[i];
              final isEmergency = (it.subject == 'Emergency');

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Card(
                  elevation: 0,
                  color: (it.read ?? false) ? ColorResources.white : const Color(0xFFE3E3E3),
                  child: ListTile(
                    onTap: () async {
                      // tandai read
                      await context.read<InboxProvider>().updateInbox(context, it.inboxId!, type);

                      if (isEmergency) {
                        // preload profil
                        context.read<ProfileProvider>().getSingleUser(context, it.senderId!);
                        _showEmergencyDialog(context, it.body ?? '');
                      } else {
                        NS.push(
                          context,
                          InboxDetailScreen(
                            inboxId: it.inboxId,
                            type: it.type ?? '',
                            body: it.body ?? '',
                            subject: it.subject,
                            field1: it.field1,
                            field2: it.field2,
                            field3: it.field3,
                            field4: it.field4,
                            field5: it.field5,
                            field6: it.field6,
                            field7: it.field7,
                            created: it.created,
                            read: it.read,
                            recepientId: it.recepientId,
                            senderId: it.senderId,
                            updated: it.updated,
                            typeInbox: it.type,
                          ),
                        );
                      }
                    },
                    isThreeLine: false,
                    dense: false,
                    leading: isEmergency
                        ? Image.asset(Images.sos, width: 25, height: 25)
                        : Icon(Icons.info, color: ColorResources.brown),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        it.subject ?? '...',
                        style: robotoRegular.copyWith(
                          fontWeight: (it.read ?? false) ? FontWeight.normal : FontWeight.bold,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // body
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            it.body ?? '...',
                            overflow: isEmergency ? TextOverflow.fade : TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: robotoRegular.copyWith(
                              height: 1.6,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ),
                        // date
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            it.created != null
                                ? DateFormat('dd MMM yyyy HH:mm').format(it.created!)
                                : '-',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEmergencyDialog(BuildContext context, String message) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                final st = profileProvider.singleUserDataStatus;

                Widget avatar;
                if (st == SingleUserDataStatus.loading) {
                  avatar = const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white),
                    ),
                  );
                } else if (st == SingleUserDataStatus.error) {
                  avatar = const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: 30,
                  );
                } else {
                  avatar = CachedNetworkImage(
                    imageUrl: profileProvider.singleUserData.profilePic ?? '',
                    imageBuilder: (_, img) => CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: img,
                      radius: 30,
                    ),
                    errorWidget: (_, __, ___) => const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      radius: 30,
                    ),
                    placeholder: (_, __) => const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(ColorResources.white),
                      ),
                    ),
                  );
                }

                String name = '...';
                String phone = '...';
                if (st == SingleUserDataStatus.loaded) {
                  name = profileProvider.singleUserData.fullname ?? '-';
                  phone = profileProvider.singleUserData.phoneNumber ?? '-';
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    avatar,
                    const SizedBox(height: 16),

                    // info user
                    _InfoRowCard(label: 'Nama', value: name),
                    _InfoRowCard(label: 'No HP', value: phone),

                    // pesan
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            message,
                            textAlign: TextAlign.justify,
                            style: robotoRegular.copyWith(
                              height: 1.4,
                              fontSize: Dimensions.fontSizeDefault,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 600),
    );
  }
}

class _InfoRowCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRowCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
              Text(value, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ],
          ),
        ),
      ),
    );
  }
}
