import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import 'package:saka/providers/store/store.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/helper.dart';
import 'package:saka/utils/extension.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/data/models/store/product_store.dart';

class EditProductStorePage extends StatefulWidget {
  final bool detailProduct;
  final String idProduct;
  final String typeProduct;
  final String path;

  const EditProductStorePage({
    Key? key,
    this.detailProduct = false,
    required this.idProduct,
    required this.typeProduct,
    required this.path,
  }) : super(key: key);
  @override
  _EditProductStorePageState createState() => _EditProductStorePageState();
}

class _EditProductStorePageState extends State<EditProductStorePage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameStuffC;
  late TextEditingController priceC;
  late TextEditingController stockC;
  late TextEditingController weightC;
  late TextEditingController minOrderC;

  String typeConditionName = "NEW";
  int typeCondition = 0;
  int typeStuff = 0;
  String? idCategoryparent;
  String? descStuff;

  ImageSource? imageSource;
  List<Asset> images = [];
  List<File> files = [];
  List<File> before = [];
  List<File> temp = [];
  List<String> kindStuff = [];
  List<dynamic> kindStuffSelected = [];
  List<PictureProductStore> pictures = [];

  Future<void> getData() async {
    nameStuffC = TextEditingController(text: '...');
    priceC = TextEditingController(text: '...');
    stockC = TextEditingController(text: '...');
    weightC = TextEditingController(text: '...');
    minOrderC = TextEditingController(text: '...');
    await context.read<StoreProvider>().getDataSingleProduct(
      context, 
      widget.idProduct, 
      widget.path,
      widget.typeProduct, 
    );
    kindStuff = [
      "Berbahaya",
      "Mudah Terbakar",
      "Cair",
      "Mudah Pecah"
    ];
    kindStuffSelected = [
      context.read<StoreProvider>().productSingleStoreModel.body!.harmful! ? 0 : -1,
      context.read<StoreProvider>().productSingleStoreModel.body!.flammable! ? 1 : -1,
      context.read<StoreProvider>().productSingleStoreModel.body!.liquid! ? 2 : -1,
      context.read<StoreProvider>().productSingleStoreModel.body!.fragile! ? 3 : -1
    ];
    nameStuffC = TextEditingController(text: context.read<StoreProvider>().productSingleStoreModel.body!.name);
    priceC = TextEditingController(text: Helper.formatCurrency((context.read<StoreProvider>().productSingleStoreModel.body!.price! - context.read<StoreProvider>().productSingleStoreModel.body!.adminCharge!), useSymbol: false));
    stockC = TextEditingController(text: context.read<StoreProvider>().productSingleStoreModel.body!.stock.toString());       
    weightC = TextEditingController(text: context.read<StoreProvider>().productSingleStoreModel.body!.weight.toString());
    minOrderC = TextEditingController(text: context.read<StoreProvider>().productSingleStoreModel.body!.minOrder.toString());
    typeConditionName = context.read<StoreProvider>().productSingleStoreModel.body!.condition!;
    pictures = context.read<StoreProvider>().productSingleStoreModel.body!.pictures!;
    for (PictureProductStore picture in pictures) {
      setState(() {
        before.add(File(picture.path!));
      });
    }
    typeCondition = typeConditionName == "NEW" ? 0 : 1;
  }

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
            child: Text("Galeri",
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
    if(before.isEmpty) {
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
    } else if(before.length == 4) { 
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
    } else if(before.length == 3) { 
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
    } else if(before.length == 2) { 
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
    } else if(before.length == 1) { 
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
    for (var imageAsset in resultList) {
      String? path = await LecleFlutterAbsolutePath.getAbsolutePath(uri: imageAsset.identifier);
      File f = File(path!);
      setState(() {
        images = resultList;
        before.add(f);
        files = before.toSet().toList();
      });
    }
  }

  Future<void> submit() async {
    try {
      if(Provider.of<StoreProvider>(context, listen: false).categoryEditProductTitle == null || Provider.of<StoreProvider>(context, listen: false).categoryEditProductTitle!.isEmpty) {
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
      if(typeConditionName == "") {
        ShowSnackbar.snackbar(context, "Kondisi Barang belum diisi", "", ColorResources.error);
        return;
      }

      context.read<StoreProvider>().setStatePostEditDataProductStore(PostEditDataProductStoreStatus.loading);
      
      if(files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          if(files[i].path.contains("/")) {
            if(files[i].path.split("/")[1] != "commerce") {
              String? body = await Provider.of<StoreProvider>(context, listen: false).getMediaKey(context);
              File file = File(files[i].path);
              Uint8List bytes = files[i].readAsBytesSync();
              String digestFile = sha256.convert(bytes).toString();
              String imageHash = base64Url.encode(HEX.decode(digestFile));
              await context.read<StoreProvider>().uploadImageProduct(context, body!, imageHash, file);
            }
          } else {
            String? body = await context.read<StoreProvider>().getMediaKey(context);
            File file = File(files[i].path);
            Uint8List bytes = files[i].readAsBytesSync();
            String digestFile = sha256.convert(bytes).toString();
            String imageHash = base64Url.encode(HEX.decode(digestFile));
            await context.read<StoreProvider>().uploadImageProduct(context, body!, imageHash, file);
          }
        }
      }

      await context.read<StoreProvider>().postEditDataProductStore(
        context,
        widget.idProduct,
        nameStuffC.text.toTitleCase(),
        int.parse(priceC.text.replaceAll(RegExp(r'[^\w\s]+'), "")),
        files,
        int.parse(weightC.text),
        int.parse(stockC.text),
        typeConditionName,
        int.parse(minOrderC.text),
        kindStuffSelected
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

    getData();
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
          elevation: 0.0,
          title: Text("Ubah Barang",
            style: robotoRegular.copyWith(
              color: ColorResources.white,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
        ),
        body: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey,
                child: Consumer<StoreProvider>(
                  builder: (BuildContext context, StoreProvider warungProvider, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      label: Text(['Baru', 'Bekas'][i]),
                                      labelStyle: robotoRegular.copyWith(
                                        color: typeCondition == i 
                                        ? ColorResources.white
                                        : ColorResources.primaryOrange
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
                        const SizedBox(height: 10.0),
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
                          // choiceStyle: FlexiChipStyle(
                          //   borderColor: ColorResources.primaryOrange,
                          //   color: ColorResources.primaryOrange
                          // ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        inputFieldDescriptionStuff(context),
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
                          child: before.isNotEmpty && files.isEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: before.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i < before.length) {
                                  return Container(
                                    height: 80.0,
                                    width: 80.0,
                                    margin: const EdgeInsets.only(right: 4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey[400]!),
                                        color: Colors.grey[350]
                                      ),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: "${before[i].path}",
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (BuildContext context, String url) {
                                            return Image.asset("assets/images/logo/saka.png");
                                          } ,
                                          errorWidget: (BuildContext context, String url, dynamic error) {
                                            return Image.asset("assets/images/logo/saka.png");
                                          },
                                        )
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      if (files.length < 5) {
                                        pickImage();
                                      }
                                      if (files.length >= 5) {
                                        setState(() {
                                          files.clear();
                                          before.clear();
                                          images.clear();
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 80.0,
                                      width: 80.0,
                                      margin: const EdgeInsets.only(right: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(color: Colors.grey[400]!),
                                          color: before.length < 5
                                          ? Colors.grey[350] 
                                          : ColorResources.error
                                        ),
                                        child: Center(
                                        child: Icon(
                                          before.length < 5 ? Icons.camera_alt
                                            : Icons.delete,
                                          color: before.length < 5
                                            ? Colors.grey[600]
                                            : ColorResources.white,
                                          size: 35.0,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          : files.isEmpty
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  if (i < files.length) {
                                    return Container(
                                      height: 80.0,
                                      width: 80.0,
                                      margin: const EdgeInsets.only(right: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey[400]!),
                                        color: Colors.grey[350]
                                      ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: "${files[i].path}",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (BuildContext context, String url) {
                                              return Image.asset("assets/images/logo/saka.png");
                                            } ,
                                            errorWidget: (BuildContext context, String url, dynamic error) {
                                              return Image.asset("assets/images/logo/saka.png");
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        if(files.length < 5) {
                                          uploadPic();
                                        } else {
                                          ShowSnackbar.snackbar(context, "Maksimal Gambar Barang 5", "", ColorResources.error);
                                        }
                                      },
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        margin: const EdgeInsets.only(right: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey[400]!),
                                          color: Colors.grey[350]),
                                        child: Center(
                                          child: Icon(Icons.camera_alt,
                                            color: Colors.grey[600],
                                            size: 35.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: files.length + 1,
                                itemBuilder: (BuildContext context, int i) {
                                  if (i < files.length) {
                                    return Container(
                                      height: 80.0,
                                      width: 80.0,
                                      margin: const EdgeInsets.only(right: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey[400]!),
                                          color: Colors.grey[350]
                                        ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: files[i].path.contains('/') 
                                          ? files[i].path.split("/")[1] == "commerce" 
                                          ? CachedNetworkImage(
                                              imageUrl: "${files[i].path}",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (BuildContext context, String url) {
                                                return Image.asset("assets/images/logo/saka.png");
                                              } ,
                                              errorWidget: (BuildContext context, String url, dynamic error) {
                                                return Image.asset("assets/images/logo/saka.png");
                                              },
                                            )
                                          : FadeInImage(
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                              image: FileImage(files[i]),
                                              placeholder: const AssetImage("assets/images/logo/saka.png")
                                            ) 
                                          : Container()
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        if (before.length < 5) {
                                          pickImage();
                                        }
                                        if (before.length >= 5) {
                                          setState(() {
                                            files.clear();
                                            before.clear();
                                            images.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        margin: const EdgeInsets.only(right: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(color: Colors.grey[400]!),
                                            color: files.length < 5
                                            ? Colors.grey[350] 
                                            : ColorResources.error
                                          ),
                                          child: Center(
                                          child: Icon(
                                            files.length < 5 ? Icons.camera_alt
                                              : Icons.delete,
                                            color: files.length < 5
                                              ? Colors.grey[600]
                                              : ColorResources.white,
                                            size: 35.0,
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
                          isLoading: context.watch<StoreProvider>().postEditDataProductStoreStatus == PostEditDataProductStoreStatus.loading 
                          ? true 
                          : false,
                          btnColor: ColorResources.primaryOrange,
                          btnTextColor: ColorResources.white,
                          onTap: submit, 
                          btnTxt: "Jual Barang"
                        )
                      ],
                    );            
                  },
                ) 
              ),
            )
          ],
        )
      )    
    );
  }
}

Widget inputFieldCategoryStuff(BuildContext context, String title, String hintText) {
  return Column(
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
          builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
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
                                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                                      child: Row(
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
                                          itemCount: storeProvider.categoryProductList.length,
                                          itemBuilder: (BuildContext context, int i) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [ 
                                                Container(
                                                  margin: const EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(storeProvider.categoryProductList[i].name!,
                                                        style: robotoRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          fontWeight: FontWeight.w600
                                                        )
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          storeProvider.changeCategoryEditProductTitle(
                                                            storeProvider.categoryProductList[i].name!, 
                                                            storeProvider.categoryProductList[i].id!
                                                          );
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
                                                    itemCount: storeProvider.categoryProductList[i].childs!.length,
                                                    itemBuilder:(BuildContext context, int z) {
                                                      return Container(
                                                        margin: const EdgeInsets.only(top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(storeProvider.categoryProductList[i].childs![z].name!,
                                                              style: robotoRegular,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                storeProvider.changeCategoryEditProductTitle(storeProvider.categoryProductList[i].childs![z].name!, storeProvider.categoryProductList[i].childs![z].id!);
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
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                hintText: storeProvider.categoryEditProductTitle ?? "Kategori Barang",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, 
                  horizontal: 15.0
                ),
                isDense: true,
                hintStyle: robotoRegular.copyWith(
                  color: storeProvider.categoryEditProductTitle == null 
                  ? Theme.of(context).hintColor 
                  : ColorResources.black
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
          borderRadius: BorderRadius.circular(6.0),
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
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: "Masukan Nama Barang",
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
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

Widget inputFieldDescriptionStuff(BuildContext context) {
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
                                      child: Text("Masukan Deskripsi",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.black
                                        )
                                      )
                                    ),
                                    storeProvider.descEditSellerStore != null
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
                                  initialValue: storeProvider.descEditSellerStore,
                                  onChanged: (val) {
                                    storeProvider.changeDescEditSellerStore(val);
                                  },
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText:  "Masukan Deskripsi Barang Anda",
                                    hintStyle: robotoRegular.copyWith(
                                      color: storeProvider.descEditSellerStore != null
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
              child: Text(storeProvider.descEditSellerStore == "" 
              ? "Masukan Deskripsi Barang Anda" 
              : storeProvider.descEditSellerStore!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault, 
                  color: storeProvider.descEditSellerStore != "" 
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