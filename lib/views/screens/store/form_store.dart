import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:saka/maps/src/place_picker.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/data/models/store/region.dart';
import 'package:saka/data/models/store/region_subdistrict.dart';

import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/region/region.dart';
import 'package:saka/providers/store/store.dart';
import 'package:saka/providers/profile/profile.dart';

class FormStoreScreen extends StatefulWidget {
  const FormStoreScreen({Key? key}) : super(key: key);

  @override
  _FormStoreScreenState createState() => _FormStoreScreenState();
}

class _FormStoreScreenState extends State<FormStoreScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameStoreC;
  late TextEditingController descStoreC;
  late TextEditingController provinceC;
  late TextEditingController cityC;
  late TextEditingController villageC;
  late TextEditingController postCodeC;
  late TextEditingController addressC;
  late TextEditingController emailC;
  late TextEditingController phoneC;

  File? _file;

  String? idProvince;
  String? province;
  String? idCity;
  String? idSubDistrictId;
  String? subDistrictName;
  String? cityName;

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getDataCouriers(context);
    }
  }

  void pickImage() async {
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: robotoRegular.copyWith(
            color: ColorResources.primaryOrange
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              "Kamera",
              style: robotoRegular.copyWith(color: ColorResources.primaryOrange),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text(
              "Galeri",
              style: robotoRegular.copyWith(color: ColorResources.primaryOrange),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          )
        ],
      )
    );
    if (imageSource != null) {
      XFile? file = await ImagePicker().pickImage(source: imageSource, maxHeight: 720);
      File f = File(file!.path);
      setState(() => _file = f);      
    }
  }

  Future<void> submit() async {
    try {
      if(_file == null) {
        ShowSnackbar.snackbar(context, "Foto Profil tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(nameStoreC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Nama Toko tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(province == null || province!.isEmpty) {
        ShowSnackbar.snackbar(context, "Provinsi tidak boleh kosong", "", ColorResources.error);
        return;
      } 
      if(cityName == null || cityName!.isEmpty) {
        ShowSnackbar.snackbar(context, "Kota tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(postCodeC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Kode Post tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(subDistrictName == null || subDistrictName!.isEmpty ) {
        ShowSnackbar.snackbar(context, "Kecamatan tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(villageC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Kelurahan / Desa tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(emailC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Alamat E-mail tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(phoneC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Nomor HP tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(context.read<StoreProvider>().isCheckedKurir.isEmpty) {
        ShowSnackbar.snackbar(context, "Kurir tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(addressC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Detail alamat tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(descStoreC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Deskripsi toko tidak boleh kosong", "", ColorResources.error);
        return;
      }
      // String? body = await getIt<FeedRepo>().getMediaKey(context); 
      // Uint8List bytes = _file!.readAsBytesSync();
      // File file = File(_file!.path);
      // String digestFile = sha256.convert(bytes).toString();
      // String imageHash = base64Url.encode(HEX.decode(digestFile)); 
      // Provider.of<StoreProvider>(context, listen: false).setStateCreateStoreStatus(CreateStoreStatus.loading);
      // await Provider.of<StoreProvider>(context, listen: false).uploadImageProduct(
      //   context, 
      //   body!, 
      //   imageHash, 
      //   file
      // );
      // await context.read<StoreProvider>().postCreateDataStore(
      //   context, 
      //   file,
      //   nameStoreC.text, 
      //   province!, 
      //   cityName!, 
      //   villageC.text, 
      //   postCodeC.text, 
      //   addressC.text, 
      //   subDistrictName!,
      //   emailC.text,
      //   phoneC.text,
      //   descStoreC.text
      // );
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    
    nameStoreC = TextEditingController();
    descStoreC = TextEditingController();
    provinceC = TextEditingController();
    cityC = TextEditingController();
    villageC = TextEditingController();
    postCodeC = TextEditingController();
    addressC = TextEditingController();
    emailC = TextEditingController(text: context.read<ProfileProvider>().getUserEmail);
    phoneC = TextEditingController(text: context.read<ProfileProvider>().getUserPhoneNumber);
      
    descStoreC = TextEditingController();
    descStoreC.addListener(() {
      setState(() {});
    });

    getData();
  }

  @override 
  void dispose() {   
    nameStoreC.dispose();
    descStoreC.dispose();
    provinceC.dispose();
    cityC.dispose();
    villageC.dispose();
    postCodeC.dispose();
    addressC.dispose();
    emailC.dispose();
    phoneC.dispose();

    descStoreC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorResources.primaryOrange,
        centerTitle: true,
        elevation: 0.0,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop(context);
          },
        ),
        title: Text("Form Buka Toko",
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Consumer<StoreProvider>(
            builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: pickImage,
                      child: _file == null 
                      ? const CircleAvatar(
                          backgroundColor: ColorResources.white,
                          maxRadius: 50.0,
                          child: Icon(
                            Icons.store,
                            size: 80.0,
                            color: ColorResources.primaryOrange,
                          ),
                        )  
                      : CircleAvatar(
                          backgroundColor: ColorResources.white,
                          maxRadius: 50.0,
                          backgroundImage: FileImage(_file!)
                        )
                    ),
                    inputFieldStoreName(context, storeProvider, "Nama Toko", nameStoreC, "Nama Toko"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    inputFieldProvince(context, storeProvider, "Provinsi", "Provinsi"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        inputFieldCity(context, "Kota", "Kota"),    
                        const SizedBox(width: 15.0), 
                        inputFieldPostCode(context, "Kode Pos", postCodeC, "Kode Pos"),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    inputFieldSubDistrict(context, storeProvider),
                    const SizedBox(height: 15.0),
                    inputFieldKelurahanDesa(context, storeProvider, "Kelurahan / Desa", villageC, "Kelurahan / Desa"),
                    const SizedBox(height: 15.0),
                    inputFieldEmailAddress(context, "E-mail Address", emailC, "E-mail Address"),
                    const SizedBox(height: 15.0),
                    inputFieldPhoneNumber(context, "Nomor HP", phoneC, "Nomor HP"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Jasa Kurir", 
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        )
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text("Pilih Jasa Pengiriman",
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault, 
                          )
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Text("(Minimal 1 Jasa Pengiriman)",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault, 
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),          
                    inputFieldCourier(context, storeProvider),
                    const SizedBox(
                      height: 15.0,
                    ),
                    inputFieldAddress(context, storeProvider),
                    const SizedBox(
                      height: 15.0,
                    ),
                    inputFieldDetailAddress(context, "Detail Alamat Toko", addressC, "Ex: Jl. Benda Raya"),
                    const SizedBox(
                      height: 15.0,
                    ),
                    inputFieldDescriptionStore(context, storeProvider, descStoreC),    
                    const SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      height: 55.0,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ColorResources.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                        ),
                        child: Center(
                          child: storeProvider.createStoreStatus == CreateStoreStatus.loading 
                          ? const Loader(
                            color: ColorResources.white,
                          ) 
                          : Text("Submit",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.white
                            )
                          ),
                        ),
                        onPressed: submit
                      ),
                    )
                  ],
                )
              )
            );
          },
        )
      ],
    ),
  );
}

  Widget inputFieldProvince(BuildContext context, StoreProvider storeProvider, String title, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
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
            onTap: storeProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Consumer<StoreProvider>(
                    builder: (BuildContext context, StoreProvider storeProviderChild, Widget? child) {
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
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
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
                                            child: Text("Pilih Provinsi Anda",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                color: ColorResources.black
                                              )
                                            )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 3,
                                ),
                                Expanded(
                                  flex: 40,
                                  child: FutureBuilder<RegionModel?>(
                                    future: Provider.of<RegionProvider>(context, listen: false).getRegion(context, "province"),
                                    builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final RegionModel regionModel = snapshot.data!;
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: regionModel.body!.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(regionModel.body![index].name!),
                                            onTap: () {
                                              setState(() {
                                                idProvince = regionModel.body![index].id;
                                                province = regionModel.body![index].name;
                                                subDistrictName = null;
                                                cityName = null;
                                              });
                                              NS.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );
                                    }
                                    return const  Loader(
                                      color: ColorResources.primaryOrange,
                                    );
                                  }
                                )
                              ),
                            ],
                          ),
                        ])
                        )
                      );
                    },
                  );
                }
              );
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: provinceC,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: province ?? hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: province == null 
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
          ),
        )
      ],
    );          
  }

  Widget inputFieldCity(BuildContext context, String title, String hintText) {
    return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
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
            onTap: () {
              if (idProvince == null) {
                ShowSnackbar.snackbar(context, "Pilih provinsi Anda Terlebih Dahulu", "", ColorResources.error);
                return;
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer(
                      builder: (BuildContext context, StoreProvider storeProviderChild, Widget? child) {
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
                                      padding: const EdgeInsets.only(
                                        left: 16.0, 
                                        right: 16.0, 
                                        top: 16.0,
                                        bottom: 8.0
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              InkWell(
                                                onTap: () => NS.pop(context),
                                                child: const Icon(
                                                  Icons.close
                                                )
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(left: 16.0),
                                                child: Text("Pilih Kota Anda",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    color: ColorResources.black
                                                  )
                                                )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 3.0,
                                    ),
                                    Expanded(
                                      flex: 40,
                                      child: FutureBuilder<RegionModel?>(
                                        future: Provider.of<RegionProvider>(context, listen: false).getCity(context, idProvince!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final RegionModel regionModel = snapshot.data!;
                                            return ListView.separated(
                                              shrinkWrap: true,
                                              physics: const BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount:regionModel.body!.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(regionModel.body![index].name!),
                                                  onTap: () {
                                                    setState(() => idCity = regionModel.body![index].id);
                                                    setState(() => cityName = regionModel.body![index].name);
                                                    NS.pop(context);
                                                  },
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return const Divider(
                                                  thickness: 1,
                                                );
                                              },
                                            );
                                          }
                                          return const Loader(
                                            color: ColorResources.primaryOrange,
                                          );
                                        },
                                      )
                                    )
                                  ]
                                )
                              ]
                            )
                          )
                        );
                      },
                    );
                  }
                );
              } 
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: cityC,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: cityName ?? hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: cityName == null 
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
          ),
        ),
      ],
    ));
  }

  Widget inputFieldSubDistrict(BuildContext context, StoreProvider storeProvider) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text('Kecamatan',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
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
            onTap: storeProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
              if (idCity == null) {
                ShowSnackbar.snackbar(context, "Pilih Kota Anda Terlebih Dahulu", "", ColorResources.error);
                return;
              } 
              else {  
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: ColorResources.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer<StoreProvider>(
                      builder: (BuildContext context, StoreProvider storeProviderChild, Widget? child) {
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
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
                                              child: Text("Pilih Kecamatan Anda",
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeDefault,
                                                  color: ColorResources.black
                                                )
                                              )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 3,
                                  ),
                                  Expanded(
                                  flex: 40,
                                  child: FutureBuilder<RegionSubdistrictModel?>(
                                    future: Provider.of<RegionProvider>(context, listen: false).getSubdistrict(context, idCity!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final RegionSubdistrictModel regionModel = snapshot.data!;
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: regionModel.body!.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(regionModel.body![index].name!),
                                              onTap: () {
                                                setState(() {
                                                  idSubDistrictId = regionModel.body![index].id;
                                                  subDistrictName = regionModel.body![index].name;
                                                });
                                                NS.pop(context);
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider(
                                              thickness: 1,
                                            );
                                          },
                                        );
                                      }
                                      return const Loader(
                                        color: ColorResources.primaryOrange,
                                      );
                                    }
                                  )
                                ),
                              ],
                            ),
                          ])
                          )
                        );
                      },
                    );
                  }
                );
              }
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: subDistrictName ?? "Kecamatan",
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: subDistrictName == null 
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
          ),
        )
      ],
    );       
  }
}

Widget inputFieldPhoneNumber(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
          child: Text(title,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
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
            readOnly: true,
            cursorColor: ColorResources.black,
            controller: controller,
            keyboardType: TextInputType.text,
            style: robotoRegular,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: hintText,
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
      ],
    );
  }
  

Widget inputFieldPostCode(BuildContext context, String title, TextEditingController controller, String hintText) {
  return SizedBox(
    width: 150.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
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
            cursorColor: ColorResources.black,
            controller: controller,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: hintText,
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
        ),
      ],
    ),
  );
}

Widget inputFieldKecamatan(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [            
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
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
          cursorColor: ColorResources.black,
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          style: robotoRegular,
          decoration: InputDecoration(
            hintText: hintText,
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

Widget inputFieldDetailAddress(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
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
          cursorColor: ColorResources.black,
          controller: controller,
          keyboardType: TextInputType.text,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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

Widget inputFieldAddress(BuildContext context, StoreProvider storeProvider) {
  return Consumer<LocationProvider>(
    builder: (BuildContext context, LocationProvider locationProvider, Widget? child) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Alamat",
                          style: robotoRegular.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.black
                          )
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text("(Berdasarkan pinpoint)",
                          style: robotoRegular.copyWith(
                            fontSize: 12.0,
                            color: Colors.grey[600]
                          )
                        ),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: storeProvider.createStoreStatus == CreateStoreStatus.loading 
                      ? null 
                      : () {
                        NS.push(context, PlacePicker(
                          apiKey: AppConstants.apiKeyGmaps,
                          useCurrentLocation: true,
                          onPlacePicked: (result) async {
                            await locationProvider.updateCurrentPosition(context, result); 
                            NS.pop(context);
                          },
                          autocompleteLanguage: "id",
                        ));
                      },
                      child: Text("Ubah Lokasi",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.primaryOrange
                        )
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                child: Text( locationProvider.getCurrentNameAddress == "Location no Selected" 
                  ? "Location no Selected"
                  : locationProvider.getCurrentNameAddress,
                  style: robotoRegular.copyWith(
                    color: ColorResources.black,
                    fontSize: Dimensions.fontSizeDefault
                  )
                ),
              ),
            ]
          )
        )
      );
    },
  );
}

Widget inputFieldStoreName(BuildContext context, StoreProvider storeProvider,  String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Nama Toko",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: TextFormField(
          readOnly: storeProvider.createStoreStatus == CreateStoreStatus.loading ? true : false,
          cursorColor: ColorResources.black,
          controller: controller,
          keyboardType: TextInputType.text,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          maxLength: 30,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            isDense: true,
            filled: true,
            fillColor: ColorResources.white,
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
    ],
  );
}

Widget inputFieldCourier(BuildContext context, StoreProvider storeProvider) {
  return Consumer<StoreProvider>(
    builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
      return GestureDetector(
        onTap: storeProvider.createStoreStatus == CreateStoreStatus.loading 
        ? null 
        : () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext ctx) {
            return Consumer<StoreProvider>(
              builder: (BuildContext context, StoreProvider storeProviderChild, Widget? child) {
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
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Row(
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
                                      child: const Text(
                                        "Pilih Jasa Pengiriman",
                                        style: robotoRegular,
                                      )
                                    )
                                  ],
                                ),
                                storeProviderChild.isCheckedKurir.isNotEmpty
                                ? InkWell(
                                  onTap: () {
                                    NS.pop(ctx);
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
                          Expanded(
                            flex: 40,
                            child: ListView.builder(
                              itemCount: storeProviderChild.couriersModelList.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int i) {
                                return CheckboxListTile(
                                  title: Text( storeProviderChild.couriersModelList[i].name!),
                                  activeColor: ColorResources.green,
                                  value: storeProviderChild.isCheckedKurir.contains(storeProviderChild.couriersModelList[i].id),
                                  onChanged: (bool? val) {   
                                    storeProviderChild.changeCourier(val!, storeProviderChild.couriersModelList[i].id!);                                                                                 
                                  },
                                );
                              },
                            )
                          )                  
                          ],
                        ),
                      ],
                    )
                  )
                );
              }
            );                 
          },
        );                                            
      },
      child: storeProvider.isCheckedKurir.isEmpty
        ? Container(
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
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: Colors.grey.withOpacity(0.5)
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  child: Text("Masukan Jasa Pengiriman",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Colors.grey[600]
                    )
                  ),
                ),
              ]
            ),
          )
        )
      : Container(
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
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: storeProvider.isCheckedKurir.map((e) {
              return Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: Text(e.toUpperCase(),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: storeProvider.isCheckedKurir.isNotEmpty 
                    ? ColorResources.black
                    : Theme.of(context).hintColor
                  )
                ),
              );
            }).toList()
          ),
        )
      ),
    );
  });
}

Widget inputFieldKelurahanDesa(BuildContext context, StoreProvider storeProvider, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
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
          readOnly: storeProvider.createStoreStatus == CreateStoreStatus.loading ? true : false,
          cursorColor: ColorResources.black,
          controller: controller,
          style: robotoRegular,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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
    ],
  );
}

Widget inputFieldEmailAddress(BuildContext context, String title, TextEditingController controller, String hintText) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(title,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
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
          readOnly: true , 
          cursorColor: ColorResources.black,
          controller: controller,
          keyboardType: TextInputType.text,
          style: robotoRegular,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
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
    ],
  ); 
}



Widget inputFieldDescriptionStore(BuildContext context, StoreProvider storeProvider, TextEditingController controller) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text("Deskripsi Toko", 
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
      ),
      const SizedBox(
        height: 10.0,
      ),
      InkWell(
        onTap: storeProvider.createStoreStatus == CreateStoreStatus.loading ? null : () {
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
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
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
                                    controller.text.isNotEmpty
                                    ? InkWell(
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
                                  controller: controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Masukan Deskripsi Toko Anda",
                                    hintStyle: robotoRegular.copyWith(
                                      color: controller.text.isNotEmpty 
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
        child: Container(
          height: 120.0,
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Text(controller.text == '' 
          ? "Masukan Deskripsi Toko Anda" 
          : controller.text,
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, 
              color: controller.text.isNotEmpty 
              ? ColorResources.black 
              : Theme.of(context).hintColor
            )
          )
        ),
      ),
    ],
  );             
}