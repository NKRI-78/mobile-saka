import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/views/screens/feed/widgets/create_post_text.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/profile/profile.dart';

class InputPostWidget extends StatefulWidget {
  const InputPostWidget({
    Key? key, 
  }) : super(key: key);
  @override
  InputPostWidgetState createState() => InputPostWidgetState();
}

class InputPostWidgetState extends State<InputPostWidget> {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          16.0, 20.0, 
          16.0, 0.0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              mainAxisSize: MainAxisSize.max,
              children: [ 

                Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return CachedNetworkImage(
                      imageUrl: profileProvider.ar.getUserAvatar()!,
                      imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: imageProvider,
                        radius: 20.0,
                      ),
                      placeholder: (BuildContext context, String url) => const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        radius: 20.0,
                      ),
                      errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                        radius: 20.0,
                      )
                    );
                  }
                ),
                
                const SizedBox(width: 8.0),

                Expanded(
                  child: TextField(
                    readOnly: true,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                          color: ColorResources.black
                        ),
                      ),
                      
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                          color: ColorResources.black,
                        ),
                      ),
                      hintText: getTranslated("WRITE_POST", context),
                      hintStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.black
                      )
                    ),
                    onTap: () {
                      NS.push(context, const CreatePostText());
                    },
                  ),
                )

              ]
            ),

          ],
        ),
      ),
    );
  }
  
}