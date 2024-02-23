import 'package:flutter/material.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/screens/dashboard/dashboard.dart';

class CashOutSuccessScreen extends StatelessWidget {
  final String? title;

  const CashOutSuccessScreen({Key? key, 
    this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            const Icon(
              Icons.verified,
              color: ColorResources.white,
              size: 100.0,
            ),
            
            const SizedBox(height: 20.0),

            Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
              child: Text("Permintaan Anda akan segera kami proses,",
                softWrap: true,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.white
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
              child: Text("Notifikasi akan masuk ke Inbox Anda.",
                softWrap: true,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.white
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            SizedBox(
              width: 140.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return 0;
                      }
                      return 0;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                },
                child: Text("OK",
                  style: robotoRegular.copyWith(
                    color: ColorResources.white
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}