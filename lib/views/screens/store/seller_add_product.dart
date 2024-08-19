import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:chips_choice/chips_choice.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/utils/extension.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

class TambahJualanPage extends StatefulWidget {
  final String idStore;

  const TambahJualanPage({
    Key? key,
    required this.idStore,
  }) : super(key: key);
  @override
  _TambahJualanPageState createState() => _TambahJualanPageState();
}

class _TambahJualanPageState extends State<TambahJualanPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  late TextEditingController nameStuffC;
  late TextEditingController priceC;
  late TextEditingController stockC;
  late TextEditingController weightC;
  late TextEditingController minOrderC;

  List<String> kindStuff = [
    "Berbahaya",
    "Mudah Terbakar",
    "Cair",
    "Mudah Pecah"
  ];

  List<dynamic> kindStuffSelected = [];

  String typeConditionName = "NEW";
  int typeCondition = 0;
  String? idCategoryparent;

  ImageSource? imageSource;

  List<Asset> images = [];
  List<File> files = [];
  List<File> before = [];

  void pickImage() async {
    var imageSource = await showDialog<ImageSource>(context: context, 
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: robotoRegular.copyWith(
            color: ColorResources.primaryOrange
          ),
        ),
        actions: [
          MaterialButton(
            child: Text("Kamera",
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text( "Galeri",
              style: robotoRegular.copyWith(
                color: ColorResources.primaryOrange
              ),
            ),
            onPressed: uploadPic,
          )
        ],
      )
    );
    if (imageSource != null) {
      XFile? file = await ImagePicker().pickImage(source: imageSource, maxHeight: 720);
      File f = File(file!.path);
      setState(() {
        before.add(f);
        files = before.toSet().toList();
      });
    }
  }
  
  void uploadPic() async {
    List<Asset> resultList = [];
    if(files.isEmpty) {
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 5)
          )
        ),
        androidOptions: AndroidOptions(
          maxImages: 5
        ),
        selectedAssets: [],
      );
    } else if(files.length == 4) { 
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 1)
          )
        ),
        androidOptions: AndroidOptions(
          maxImages: 1
        ),
        selectedAssets: [],
      );
    } else if(files.length == 3) { 
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 2)
          )
        ),
        androidOptions: AndroidOptions(
          maxImages: 2
        ),
        selectedAssets: [],
      );
    } else if(files.length == 2) { 
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 3)
          )
        ),
        androidOptions: AndroidOptions(
          maxImages: 3
        ),
        selectedAssets: [],
      );
    } else { 
      resultList = await MultiImagePicker.pickImages(
        iosOptions: const IOSOptions(
          settings: CupertinoSettings(
            selection: SelectionSetting(max: 4)
          )
        ),
        androidOptions: AndroidOptions(
          maxImages: 4
        ),
        selectedAssets: [],
      );
    } 
    Navigator.of(context, rootNavigator: true).pop();
    for (Asset imageAsset in resultList) {
      final filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
      File tempFile = File(filePath!);
      setState(() {
        images = resultList;
        before.add(tempFile);
        files = before.toSet().toList();
      });
    }
  }

  Future<void> submit() async {
    try {
      if(context.read<StoreProvider>().categoryAddProductTitle!.isEmpty){
        ShowSnackbar.snackbar(context, "Kategori Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(nameStuffC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Nama Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(priceC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Harga Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(minOrderC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Minimal Order Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(stockC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Stok Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(weightC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Berat Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(typeConditionName.isEmpty) {
        ShowSnackbar.snackbar(context, "Kondisi Barang belum diisi", "", ColorResources.error);
        return;
      }
      if(files.isEmpty) {
        ShowSnackbar.snackbar(context, "Gambar belum diisi", "", ColorResources.error);
        return;
      } 

      context.read<StoreProvider>().setStatePostAddDataProductStore(PostAddDataProductStoreStatus.loading);
      
      for (int i = 0; i < files.length; i++) {
        String? body = await context.read<StoreProvider>().getMediaKey(context);
        File file = File(files[i].path);
        Uint8List bytes = files[i].readAsBytesSync();
        String digestFile = sha256.convert(bytes).toString();
        String imageHash = base64Url.encode(HEX.decode(digestFile));
        await context.read<StoreProvider>().uploadImageProduct(context, body!, imageHash, file);
      }

      await context.read<StoreProvider>().postDataProductStore(
        context,
        nameStuffC.text.toTitleCase(),
        int.parse(priceC.text.replaceAll(RegExp(r'[^\w\s]+'), "")),
        files,
        int.parse(weightC.text),
        int.parse(stockC.text),
        typeConditionName,
        kindStuffSelected,
        int.parse(minOrderC.text),
        widget.idStore,
      );
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<bool> onWillPop() {
    NS.pop(context);
    return Future.value(true);
  }

  @override 
  void initState() {
    super.initState();

    nameStuffC = TextEditingController();
    priceC = TextEditingController();
    stockC = TextEditingController();
    weightC = TextEditingController();
    minOrderC = TextEditingController();
  }

  @override 
  void dispose() {
    nameStuffC.dispose();
    priceC.dispose();
    stockC.dispose();
    weightC.dispose();
    minOrderC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorResources.backgroundColor,
        appBar: AppBar(
        backgroundColor: ColorResources.primaryOrange,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: onWillPop,
        ),
        centerTitle: true,
        elevation: 0,
        title: Text( "Jual Barang",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
            color: ColorResources.white
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              inputFieldCategoryStuff(context, "Kategori Barang *", "Kategori Barang"),
              const SizedBox(height: 15.0),
              inputFieldNameStuff(context, nameStuffC),
              const SizedBox(height: 15.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldPriceStuff(context, priceC)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldMinOrder(context, minOrderC)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 120.0,
                    child: inputFieldStock(context, stockC)
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputFieldWeight(context, weightC),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text("Kondisi *",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                )
              ),
              const SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: [ 
                  SizedBox(
                    height: 30.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ['Baru', 'Bekas'].length,
                      itemBuilder: (BuildContext context, int i) {
                        return Container(
                          margin: EdgeInsets.only(left: i == 0 ? 0.0 : 10.0),
                          child: ChoiceChip(
                            label: Text(['Baru', 'Bekas'][i],
                              style: robotoRegular.copyWith(
                                color: typeCondition == i 
                                ? ColorResources.white
                                : ColorResources.primaryOrange
                              ),
                            ),
                            selectedColor: ColorResources.primaryOrange,
                            selected: typeCondition == i,
                            onSelected: (bool selected) {
                              setState(() {
                                typeCondition = (selected ? i : null)!;
                                typeConditionName = ['Baru', 'Bekas'][i] == "Baru" ? "NEW" : "USED";
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ),
              const SizedBox(
                height: 10.0,
              ),
              ChipsChoice.multiple(
                // choiceActiveStyle: const C2ChoiceStyle(
                //   borderColor: ColorResources.primaryOrange,
                //   color: ColorResources.primaryOrange
                // ),
                wrapped: true,
                padding: EdgeInsets.zero,
                errorBuilder: (context) => Container(),
                placeholder: "",
                value: kindStuffSelected,
                onChanged: (val) => setState(() => kindStuffSelected = val),
                choiceItems: C2Choice.listFrom<int, String>(
                  source: kindStuff,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ), 
                // choiceStyle: const C2ChoiceStyle(
                //   borderColor: ColorResources.primaryOrange,
                //   color: ColorResources.primaryOrange
                // ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              inputFieldDescriptionStore(context),
              const SizedBox(
                height: 15.0,
              ),
              Text("Gambar Barang *",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                )
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 100.0,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5)
                  ),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                  child: files.isEmpty
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                color: Colors.grey.withOpacity(0.5)
                              ),
                              child: Center(
                                child: files.isEmpty
                                ? Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 35,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      image: FileImage(files.first),
                                      placeholder: const AssetImage("assets/images/logo/saka.png")
                                    ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Upload Gambar Barang",
                                style: robotoRegular.copyWith(
                                  fontSize: 12.0,
                                )
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text("Maksimum 5 gambar, ukuran minimal 300x300px berformat JPG atau PNG",
                                style: robotoRegular.copyWith(
                                  fontSize: 12.0,
                                  color: Colors.grey[600]
                                )
                              ),
                            ],
                          ))
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: files.length + 1,
                        itemBuilder: (context, index) {
                          if (index < files.length) {
                            return Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey[400]!
                                ),
                                color: Colors.grey[350]
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    image: FileImage(files[index]),
                                    placeholder: const AssetImage("assets/images/logo/saka.png")
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                if (files.length < 5) {
                                  pickImage();
                                } else if (files.length >= 5) {
                                  setState(() {
                                    files.clear();
                                    before.clear();
                                    images.clear();
                                  });
                                }
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey[400]!
                                ),
                                color: files.length < 5 ? Colors.grey[350] : Colors.red),
                                child: Center(
                                  child: Icon(
                                    files.length < 5 ? Icons.camera_alt : Icons.delete,
                                    color: files.length < 5 ? Colors.grey[600] : ColorResources.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    CustomButton(
                      isBorder: false,
                      isBoxShadow: false,
                      isBorderRadius: true,
                      isLoading: context.watch<StoreProvider>().postAddDataProductStoreStatus == PostAddDataProductStoreStatus.loading 
                      ? true 
                      : false,
                      btnColor: ColorResources.primaryOrange,
                      btnTextColor: ColorResources.white,
                      onTap: submit, 
                      btnTxt: "Jual Barang"
                    )
                  ],
                )
              ),
            )
          ],
        )
      ),
    );
  }

  Widget inputFieldCategoryStuff(BuildContext context, String title, String hintText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: 13.0,
            )
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: Consumer<StoreProvider>(
            builder: (BuildContext context, StoreProvider sp, Widget? child) {
              return TextFormField(
                readOnly: true,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return Consumer(
                        builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                          return Container(
                          height: MediaQuery.of(context).size.height * 0.96,
                          color: Colors.transparent,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ColorResources.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)
                                )
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                NS.pop(context);
                                              },
                                              child: const Icon(
                                                Icons.close
                                              )
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 16),
                                              child: Text("Kategori Barang",
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  color: ColorResources.black
                                                )
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 3.0,
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          separatorBuilder: (BuildContext context, int i) => const Divider(
                                            color: ColorResources.dimGrey,
                                            thickness: 0.1,
                                          ),
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: sp.categoryProductList.length,
                                          itemBuilder: (BuildContext context, int i) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [ 
                                                Container(
                                                  margin: const EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(sp.categoryProductList[i].name!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.w600
                                                        )
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          sp.changeCategoryAddProductTitle(storeProvider.categoryProductList[i].name!, sp.categoryProductList[i].id!);
                                                          NS.pop(context);
                                                        },
                                                        child: const Text("Pilih",
                                                          style: robotoRegular,
                                                        ),
                                                      )                                              
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: sp.categoryProductList[i].childs!.length,
                                                    itemBuilder:(BuildContext context, int z) {
                                                      return Container(
                                                        margin: const EdgeInsets.only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Text(sp.categoryProductList[i].childs![z].name!,
                                                              style: robotoRegular,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                sp.changeCategoryAddProductTitle(storeProvider.categoryProductList[i].childs![z].name!, storeProvider.categoryProductList[i].childs![z].id!);
                                                                NS.pop(context);
                                                              },
                                                              child: const Text("Pilih",
                                                                style: robotoRegular,
                                                              ),
                                                            )
                                                          ],
                                                        ) 
                                                      );
                                                    },
                                                  ),
                                                )
                                              ]
                                            );                                                                      
                                          },
                                        )  
                                      )                                
                                    ],
                                  ),
                                ],
                              ),
                            )
                          );
                        }, 
                      );
                    }
                  );
                },
                cursorColor: ColorResources.black,
                keyboardType: TextInputType.text,
                style: robotoRegular,
                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                decoration: InputDecoration(
                  hintText: sp.categoryAddProductTitle != "" 
                  ?  sp.categoryAddProductTitle
                  : "Kategori Barang",
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                  isDense: true,
                  hintStyle: robotoRegular.copyWith(
                    color: sp.categoryAddProductTitle != "" 
                    ? ColorResources.black  
                    : Theme.of(context).hintColor
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5
                    ),
                  ),
                ),
              );
            },
          )
        )
      ]
    );
  }
}

Widget inputFieldNameStuff(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Nama Barang *",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: const Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: "Masukan Nama Barang",
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0, 
              horizontal: 15.0
            ),
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldPriceStuff(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Harga *",
          style: robotoRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: const Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.number,
          style: robotoRegular,
          inputFormatters: [
            CurrencyTextInputFormatter(
              decimalDigits: 0,
              symbol: "",
              locale: 'id',
            )
          ],
          decoration: InputDecoration(
          fillColor: ColorResources.white,
          prefixIcon: SizedBox(
            width: 50,
            child: Center(
              child: Text("Rp",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontWeight: FontWeight.w600
                ),
              )),
            ),
            hintText: "0",
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldMinOrder(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Min Order *",
          style: robotoRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: const Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.number,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldStock(BuildContext context, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Stok *",
          style: robotoRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: const Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.number,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}

Widget inputFieldDescriptionStore(BuildContext context) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Deskripsi Barang", 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      InkWell(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Consumer(
                builder: (BuildContext context, StoreProvider storeProvider,  Widget? child) {
                  return Container(
                  height: MediaQuery.of(context).size.height * 0.96,
                  color: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorResources.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0)
                        )
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, 
                                  top: 16.0, bottom: 8.0
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        NS.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.close
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 16.0),
                                      child: Text("Masukan Deskripsi",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        )
                                      )
                                    ),
                                    storeProvider.descAddSellerStore != null
                                    ? GestureDetector(
                                        onTap: () {
                                          NS.pop(context);
                                        },
                                        child: const Icon(
                                          Icons.done,
                                          color: ColorResources.primaryOrange
                                        )
                                      )
                                    : Container(),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 3,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: ColorResources.white,
                                  borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: TextFormField(
                                  autofocus: true,
                                  initialValue: storeProvider.descAddSellerStore,
                                  onChanged: (val) {
                                    storeProvider.changeDescAddSellerStore(val);
                                  },
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: "Masukan Deskripsi Barang Anda",
                                    hintStyle: robotoRegular.copyWith(
                                      color: storeProvider.descAddSellerStore != null
                                      ? ColorResources.black
                                      : Theme.of(context).hintColor
                                    ),
                                    fillColor: ColorResources.white,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  style: robotoRegular
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  );
                }, 
              );
            }
          );
        },
        child: Consumer<StoreProvider>(
          builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
            return Container(
              height: 120.0,
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Text(storeProvider.descAddSellerStore == "" 
              ? "Masukan Deskripsi Barang Anda" 
              : storeProvider.descAddSellerStore!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault, 
                  color: storeProvider.descAddSellerStore != "" 
                  ? ColorResources.black 
                  : Theme.of(context).hintColor
                )
              )
            );
          },
        )
      ),
    ],
  );             
}

Widget inputFieldWeight(BuildContext context, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Berat *",
          style: robotoRegular.copyWith(
            fontSize: 13.0,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              spreadRadius: 1.0, 
              blurRadius: 3.0, 
              offset: const Offset(0.0, 1.0)
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.number,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "0",
            isDense: true,
            suffixIcon: SizedBox(
              width: 80.0,
              child: Center(
                child: Text("Gram",
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            hintStyle: robotoRegular.copyWith(
              color: Theme.of(context).hintColor
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 0.5
              ),
            ),
          ),
        ),
      )
    ]
  );
}