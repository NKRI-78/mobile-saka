import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/maps/google_maps_place_picker.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/region/region.dart';
import 'package:saka/providers/store/store.dart';

import 'package:saka/data/models/store/seller_store.dart';
import 'package:saka/data/models/store/region.dart';
import 'package:saka/data/models/store/region_subdistrict.dart';

import 'package:saka/views/screens/store/store_index.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class EditStorePage extends StatefulWidget {
  final String idStore;
  final String nameStore;
  final String description;
  final String province;
  final String city;
  final String subDistrict;
  final String village;
  final String postalCode;
  final String address;
  final String email;
  final String phone;
  final List<double> location;
  final List<SupportedCourier> supportedCouriers;
  final Picture picture;
  final bool status;

  const EditStorePage({
    Key? key,
    required this.idStore,
    required this.nameStore,
    required this.description,
    required this.province,
    required this.city,
    required this.subDistrict,
    required this.village,
    required this.postalCode,
    required this.address,
    required this.email,
    required this.phone,
    required this.location,
    required this.supportedCouriers,
    required this.picture,
    required this.status,
  }) : super(key: key);
  @override
  _EditStorePageState createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? f1;

  late TextEditingController nameStoreC;
  late TextEditingController provinceC;
  late TextEditingController cityC;
  late TextEditingController postCodeC;
  late TextEditingController villageC;
  late TextEditingController addressC;
  late TextEditingController emailC;
  late TextEditingController phoneC;
  
  bool statusToko = false;
  
  String? idProvince;
  String? province;
  String? idCity;
  String? idSubDistrictId;
  String? subDistrictName;
  String? cityName;
  String? path;

  List<String> isChecked = [];
  List<double> lokasi = [];
  List<SupportedCourier>? supportedCouriers;

  Future<void> pickImage() async {
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Pilih sumber gambar",
          style: robotoRegular.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.teal
          ),
        ),
        actions: [
          MaterialButton(
            child: Text("Camera",
              style: robotoRegular.copyWith(color: ColorResources.primaryOrange),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text("Gallery",
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
      setState(() => f1 = f);
    }
  }

  Future<bool> onWillPop() {
    NS.push(context, const StoreScreen());
    return Future.value(true);
  }

  Future<void> submit() async {
    try {
      if(nameStoreC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Nama Toko tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(province == null || province == "") {
        ShowSnackbar.snackbar(context, "Provinsi tidak boleh kosong", "", ColorResources.error);
        return;
      } 
      if(cityName == null || cityName == "") {
        ShowSnackbar.snackbar(context, "Kota tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(postCodeC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Kode Pos tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(subDistrictName == null || subDistrictName!.isEmpty){
        ShowSnackbar.snackbar(context, "Kecamatan ridak boleh kosong", "", ColorResources.error);
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
      if(f1 != null) {
        // String? body = await getIt<FeedRepo>().getMediaKey(context);
        // File? file = File(f1!.path);
        // Uint8List bytes = f1!.readAsBytesSync();
        // String digestFile = sha256.convert(bytes).toString();
        // String imageHash = base64Url.encode(HEX.decode(digestFile));
        // await Provider.of<StoreProvider>(context, listen: false).uploadImageProduct(
        //   context,
        //   body!,
        //   imageHash,
        //   file
        // );
      }
      await context.read<StoreProvider>().postEditDataStore(
        context, 
        widget.idStore, 
        nameStoreC.text, 
        province!, 
        cityName!, 
        subDistrictName!,
        villageC.text,
        postCodeC.text, 
        addressC.text,  
        emailC.text,
        phoneC.text,
        statusToko,
        f1
      );
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> onWillpop() {
    NS.pop(context);
    return Future.value(true);
  }

  Future<void> getData() async {
    provinceC = TextEditingController();
    cityC = TextEditingController();
    villageC = TextEditingController();
    if(mounted) {
      nameStoreC = TextEditingController(text: "...");
      postCodeC = TextEditingController(text: "...");
      addressC = TextEditingController(text: "...");
      emailC = TextEditingController(text: "...");
      phoneC = TextEditingController(text: "...");
      await context.read<StoreProvider>().getDataStore(context);
      nameStoreC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.name);
      villageC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.village);
      postCodeC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.postalCode);
      addressC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.address);
      emailC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.email);
      phoneC = TextEditingController(text: context.read<StoreProvider>().sellerStoreModel.body!.phone);
      statusToko = context.read<StoreProvider>().sellerStoreModel.body!.open!;
      province = context.read<StoreProvider>().sellerStoreModel.body!.province;
      cityName = context.read<StoreProvider>().sellerStoreModel.body!.city;
      subDistrictName = context.read<StoreProvider>().sellerStoreModel.body!.subDistrict;
      path = context.read<StoreProvider>().sellerStoreModel.body!.picture!.path;
      context.read<StoreProvider>().isCheckedKurir = [];
      for (int i = 0; i < context.read<StoreProvider>().sellerStoreModel.body!.supportedCouriers!.length; i++) {
        context.read<StoreProvider>().isCheckedKurir.add(context.read<StoreProvider>().sellerStoreModel.body!.supportedCouriers![i].id!);
      }
    }
    if(mounted) {
      context.read<StoreProvider>().getDataCouriers(context);
    }
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override 
  void dispose() {
    nameStoreC.dispose();
    postCodeC.dispose();
    addressC.dispose();
    emailC.dispose();
    phoneC.dispose();
    provinceC.dispose();
    cityC.dispose();
    villageC.dispose();

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
        backgroundColor: ColorResources.white,
        appBar: AppBar(
          title: Text("Ubah Toko",
            style: robotoRegular.copyWith(
              color: ColorResources.white, 
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: ColorResources.primaryOrange,
          leading: CupertinoNavigationBarBackButton(
            color: ColorResources.white,
            onPressed: () {
              NS.pop(context);
            },
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<StoreProvider>(
                builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                          f1 == null 
                          ? Center(
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: CachedNetworkImage(
                                    imageUrl: "$path",
                                    fit: BoxFit.cover,
                                    placeholder: (BuildContext context, String url) => const Loader(color: ColorResources.primaryOrange),
                                      errorWidget: (BuildContext context, String url, dynamic error) => ClipOval(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ColorResources.primaryOrange
                                        ),
                                        child: const Icon(
                                          Icons.store,
                                          size: 30.0,
                                          color: ColorResources.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                )
                              ),
                            ) 
                          : Center(
                              child: Container(
                              width: 80.0,
                              height: 80.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: Image.file(f1!)
                              ),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              )
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 90.0,
                              height: 90.0,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await pickImage();
                                      },
                                      child: Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 5.0
                                            ),
                                          ],
                                          color: ColorResources.primaryOrange,
                                          borderRadius: BorderRadius.circular(40.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.photo_camera,
                                              color: ColorResources.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Status Toko",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              )
                            ),
                            FlutterSwitch(
                              showOnOff: true,
                              activeTextColor: ColorResources.white,
                              inactiveTextColor: ColorResources.white,
                              activeColor: ColorResources.primaryOrange,
                              width: 90.0,
                              activeText: "Buka",
                              inactiveText: "Tutup",
                              value: statusToko,
                              onToggle: (val) {
                                setState(() {
                                  statusToko = val;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        inputFieldStoreName(context, storeProvider, "Nama Toko", nameStoreC, "Nama Toko"),
                        const SizedBox(height: 15.0),
                        inputFieldProvince(context, storeProvider, "Provinsi", "Provinsi"),
                        const SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            inputFieldCity(context, "Kota", "Kota"),    
                            const SizedBox(width: 15.0), 
                            inputFieldPostCode(context, storeProvider, "Kode Pos", postCodeC, "Kode Pos"),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        inputFieldSubDistrict(context),
                        const SizedBox(height: 15.0),
                        inputFieldKelurahanDesa(context, storeProvider, "Kelurahan / Desa", villageC, "Kelurahan / Desa"),
                        const SizedBox(height: 15.0),
                        inputFieldEmailAddress(context, "E-mail Address", emailC, "E-mail Address"),
                        const SizedBox(height: 15.0),
                        inputFieldPhoneNumber(context, "Nomor HP", phoneC, "Nomor HP"),
                        const SizedBox(height: 15.0),
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
                        inputFieldCourier(context, storeProvider),
                        const SizedBox(height: 15.0),
                        inputFieldAddress(context, storeProvider),
                        const SizedBox(height: 15.0),
                        inputFieldDetailAddress(context, storeProvider, "Detail Alamat Toko", addressC, "Ex: Jl. Benda Raya"),
                        const SizedBox(height: 15.0),
                        inputFieldDescriptionStore(context, storeProvider),
                        const SizedBox(height: 25.0),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:  ColorResources.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: storeProvider.editStoreStatus == EditStoreStatus.loading 
                            ? const Loader(
                              color: ColorResources.white,
                            ) 
                            : Text("Simpan",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.white
                              )
                            ),
                          ),
                          onPressed: submit 
                        )
                      ],
                    )
                  );
                },
              )
            )
          ],
        ),
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
            onTap: storeProvider.editStoreStatus == EditStoreStatus.loading ? null : () {
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
                                            margin: const EdgeInsets.only(left: 16.0),
                                            child: Text("Pilih Provinsi Anda",
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
                                                cityName = null;
                                                subDistrictName = null;
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
            },
            style: robotoRegular,
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
            style: robotoRegular,
            onTap: () {
              if (idProvince == null) {
                Fluttertoast.showToast(
                  msg: "Pilih Pronvisi Anda Terlebih Dahulu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: ColorResources.black
                );
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
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      thickness: 3,
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

  Widget inputFieldSubDistrict(BuildContext context) {
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
            onTap: () {
              if (idCity == null) {
                Fluttertoast.showToast(
                  msg: "Pilih Kota Anda Terlebih Dahulu",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: ColorResources.black
                );
              } 
              else {  
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
                                              margin: const EdgeInsets.only(left: 16.0),
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
              enabledBorder: const  OutlineInputBorder(
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

  Widget inputFieldDescriptionStore(BuildContext context, StoreProvider storeProvider) {
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
        onTap: storeProvider.editStoreStatus == EditStoreStatus.loading ? null : () {
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
                                    storeProvider.descStore!.isNotEmpty
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
                                  autofocus: true,
                                  initialValue: storeProvider.descStore,
                                  onChanged: (val) {
                                    storeProvider.changeDescStore(val);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Masukan Deskripsi Toko Anda",
                                    hintStyle: robotoRegular.copyWith(
                                      color: storeProvider.descStore!.isNotEmpty 
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
              child: Text(storeProvider.descStore!.isEmpty 
              ? "Masukan Deskripsi Toko Anda" 
              : storeProvider.descStore!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault, 
                  color: storeProvider.descStore!.isNotEmpty 
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

Widget inputFieldCourier(BuildContext context, StoreProvider storeProvider) {
  return Consumer<StoreProvider>(
    builder: (BuildContext context, StoreProvider warungProvider, Widget? child) {
      return InkWell(
        onTap: warungProvider.editStoreStatus == EditStoreStatus.loading ? null : () {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            context: context,
            builder: (BuildContext ctx) {
            return Consumer<StoreProvider>(
              builder: (BuildContext context, StoreProvider warungProviderChild, Widget? child) {
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
                                      child: const Text(
                                        "Pilih Jasa Pengiriman",
                                        style: robotoRegular,
                                      )
                                    )
                                  ],
                                ),
                                storeProvider.isCheckedKurir.isNotEmpty
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
                              itemCount: warungProviderChild.couriersModelList.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int i) {
                                return CheckboxListTile(
                                  title: Text( warungProviderChild.couriersModelList[i].name!),
                                  activeColor: ColorResources.green,
                                  value: warungProviderChild.isCheckedKurir.contains(warungProviderChild.couriersModelList[i].id),
                                  onChanged: (bool? val) {   
                                    warungProviderChild.changeCourier(val!, warungProviderChild.couriersModelList[i].id!);                                                                                 
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
      child: warungProvider.isCheckedKurir.isEmpty
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
          children: warungProvider.isCheckedKurir.map((e) {
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
          }).toList()),
        )
      ),
    );
  });
}

Widget inputFieldKecamatan(BuildContext context, StoreProvider storeProvider, String title, TextEditingController controller, String hintText) {
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
          readOnly: storeProvider.editStoreStatus == EditStoreStatus.loading ? true : false,
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

Widget inputFieldStoreName(BuildContext context, StoreProvider storeProvider, String title, TextEditingController controller, String hintText) {
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
          readOnly: storeProvider.editStoreStatus == EditStoreStatus.loading ? true : false,
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

Widget inputFieldDetailAddress(BuildContext context, StoreProvider storeProvider, String title, TextEditingController controller, String hintText) {
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
          readOnly: storeProvider.editStoreStatus == EditStoreStatus.loading ? true : false,
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
          readOnly: storeProvider.editStoreStatus == EditStoreStatus.loading ? true : false,
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
                            fontSize: Dimensions.fontSizeDefault,
                            color: Colors.grey[600]
                          )
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: storeProvider.editStoreStatus == EditStoreStatus.loading 
                      ? null
                      : () {
                        NS.push(context, PlacePicker(
                          apiKey: AppConstants.apiKeyGmaps,
                          useCurrentLocation: true,
                          onPlacePicked: storeProvider.editStoreStatus == EditStoreStatus.loading ? null : (result) async {
                            await locationProvider.updateCurrentPosition(context, result); 
                            NS.pop(context);
                          },
                          autocompleteLanguage: "id",
                        ));
                      },
                      child: Text("Ubah Lokasi",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.primaryOrange
                        )
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                child: Text( locationProvider.getCurrentNameAddress == "Location no Selected" 
                  ? "Location no Seleected" 
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


Widget inputFieldPostCode(BuildContext context, StoreProvider storeProvider, String title, TextEditingController controller, String hintText) {
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
            readOnly: storeProvider.editStoreStatus == EditStoreStatus.loading ? true : false,
            style: robotoRegular,
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
