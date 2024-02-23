
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class EditNoteProductPage extends StatefulWidget {
  final String productId;
  final String note;

  const EditNoteProductPage({
    Key? key,
    required this.productId,
    required this.note,
  }) : super(key: key);
  @override
  _EditNoteProductPageState createState() => _EditNoteProductPageState();
}

class _EditNoteProductPageState extends State<EditNoteProductPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  late TextEditingController noteC;

  @override
  void initState() {
    super.initState();

    noteC = TextEditingController(text: widget.note);
    noteC.addListener(() {
      setState(() {});
    });
  }

  @override 
  void dispose() {
    noteC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("Tulis Catatan",
          style: robotoRegular.copyWith(
            color: ColorResources.black, 
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: ColorResources.white,
        titleSpacing: 0,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.primaryOrange,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(10.0)),
              child: TextFormField(
                controller: noteC,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Tulis catatan untuk barang ini",
                  fillColor: ColorResources.white,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return "Catatan tidak boleh kosong";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                style: robotoRegular
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60.0,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: ColorResources.white,
              ),
                child: SizedBox(
                  height: 55.0,
                  width: double.infinity,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ),
                  child: Center(
                    child: Text("Submit",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, 
                        color: ColorResources.white
                      )
                    ),
                  ),
                  onPressed: () async {
                    await context.read<StoreProvider>().postEditNoteCart(context, widget.productId, noteC.text);
                    Navigator.pop(context, true);
                  },
                )
              )
            )
          )
        ],
      ),
    );
  }
}
