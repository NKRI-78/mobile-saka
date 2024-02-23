import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/localization/localization.dart';
import 'package:saka/providers/splash/splash.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class LanguageDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    int index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    
    return Dialog(
      backgroundColor: ColorResources.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Text(getTranslated('CHOOSE_LANGUAGE', context), style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          )),
        ),

        SizedBox(
          height: 150.0, 
          child: Consumer<SplashProvider>(
            builder: (BuildContext context, SplashProvider splashProvider, Widget? child) {

            List<String> valueList = [];
            AppConstants.languages.forEach((language) => valueList.add(language.languageName!));

              return CupertinoPicker(
                itemExtent: 40,
                useMagnifier: true,
                magnification: 1.2,
                scrollController: FixedExtentScrollController(initialItem: index),
                onSelectedItemChanged: (int i) {
                  index = i;
                },
                children: valueList.map((value) {
                  return Center(child: Text(value, 
                    style: TextStyle(
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

        Divider(
          height: Dimensions.paddingSizeExtraSmall, 
          color: ColorResources.hintColor
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
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
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall),
                child: VerticalDivider(width: Dimensions.paddingSizeExtraSmall, 
                color: Theme.of(context).hintColor
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
                  fontSize:Dimensions.fontSizeSmall
                )
              ),
            )),
          ]
        ),

      ]),
    );
  }
}