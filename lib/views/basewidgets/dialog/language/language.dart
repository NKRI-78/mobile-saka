import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/localization/localization.dart';
import 'package:saka/providers/splash/splash.dart';

import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    
    return Dialog(
      backgroundColor: ColorResources.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(getTranslated('CHOOSE_LANGUAGE', context),
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            )
          ),
        ),

        SizedBox(
          height: 150.0, 
          child: Consumer<SplashProvider>(
            builder: (BuildContext context, SplashProvider splashProvider, Widget? child) {
              List<String> valueList = [];
              for (var language in AppConstants.languages) {
                valueList.add(language.languageName!);
              }
              return CupertinoPicker(
                itemExtent: 40.0,
                useMagnifier: true,
                magnification: 1.2,
                scrollController: FixedExtentScrollController(initialItem: index),
                onSelectedItemChanged: (int i) {
                  index = i;
                },
                children: valueList.map((value) {
                  return Center(
                    child: Text(value, 
                      style: robotoRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeSmall
                      )
                    )
                  );
                }).toList(),
              );
            },
          )
        ),
        const Divider(
          height: Dimensions.paddingSizeExtraSmall, 
          color: ColorResources.hintColor
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(getTranslated('CANCEL', context), 
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeSmall
                  )
                ),
              )
            ),
            Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: const VerticalDivider(
                color: ColorResources.grey,
                width: Dimensions.paddingSizeExtraSmall, 
              ),
            ),
            Expanded(
              child: TextButton(
              onPressed: () {
                Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                  AppConstants.languages[index].languageCode!,
                  AppConstants.languages[index].countryCode,
                ));
                Navigator.pop(context);
              },
              child: Text(getTranslated('OK', context), 
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontSize: Dimensions.fontSizeSmall
                )
              ),
            )
          ),
        ]),
      ]),
    );
  }
}