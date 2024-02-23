import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:saka/maps/google_maps_place_picker.dart';

import 'package:saka/data/models/store/region.dart';
import 'package:saka/data/models/store/region_subdistrict.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/button/custom.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/providers/location/location.dart';
import 'package:saka/providers/profile/profile.dart';
import 'package:saka/providers/store/store.dart';
import 'package:saka/providers/region/region.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/constant.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

class TambahAlamatPage extends StatefulWidget {
  const TambahAlamatPage({Key? key}) : super(key: key);

  @override
  _TambahAlamatPageState createState() => _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController detailAddressC;
  late TextEditingController typeAddressC;
  late TextEditingController subDistrictC; 
  late TextEditingController phoneC;
  late TextEditingController villageC;
  late TextEditingController postCodeC;

  String? province;
  String? cityName;
  String? idCity;
  String? idSubDistrictId;
  String? subDistrictName;
  String?idProvince;
  bool isCheck = true;
  List<String> typeTempat = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  Future<void> submit() async {
    try {
      if(detailAddressC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Detail Alamat tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(typeAddressC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Alamat tidak boleh kosong", "", ColorResources.error);
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
        ShowSnackbar.snackbar(context, "Kecamatan tidak boleh kosong", "", ColorResources.error);
        return;
      }
      if(villageC.text.trim().isEmpty) {
        ShowSnackbar.snackbar(context, "Kelurahan / Desa tidak boleh kosong", "", ColorResources.error);
        return;
      }
      await context.read<RegionProvider>().postDataAddress(
        context, 
        typeAddressC.text, 
        detailAddressC.text, 
        province!, 
        cityName!, 
        subDistrictName!,
        villageC.text, 
        postCodeC.text, 
      );
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    detailAddressC = TextEditingController();
    typeAddressC = TextEditingController();
    subDistrictC = TextEditingController();
    phoneC = TextEditingController();
    villageC = TextEditingController();
    postCodeC = TextEditingController();

    phoneC.text = context.read<ProfileProvider>().getUserPhoneNumber;
    typeAddressC.addListener(() {
      setState(() {});
    });
  }

  @override 
  void dispose() {
    detailAddressC.dispose();
    typeAddressC.dispose();
    subDistrictC.dispose();
    phoneC.dispose();
    villageC.dispose();
    postCodeC.dispose();

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
        backgroundColor: ColorResources.primaryOrange,
        title: Text("Tambah Alamat Baru",
          style: robotoRegular.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorResources.white
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputFieldAddress(context),
                  const SizedBox(
                    height: 15.0,
                  ),
                  inputFieldDetailAddress(context, "Detail Alamat", detailAddressC, "Detail Alamat"),
                  const SizedBox(
                    height: 15.0,
                  ),
                  inputFieldLocationAddress(context),
                  const SizedBox(
                    height: 15.0,
                  ),
                  isCheck
                  ? Container()
                  : Container(
                      height: 35.0,
                      margin: const EdgeInsets.only(bottom: 15.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...typeTempat
                          .map((e) => GestureDetector(
                            onTap: () {
                              setState(() {
                                typeAddressC.text = e;
                                isCheck = true;
                              });
                            },
                            child: Container(
                              height: 20,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: ColorResources.white,
                                border: Border.all(
                                  color: Colors.grey[350]!
                                )
                              ),
                              child: Center(
                                child: Text(e,
                                  style: robotoRegular.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: Dimensions.fontSizeSmall,
                                  )
                                )
                              )
                            ),
                          )).toList()
                        ],
                      )
                    ),

                  inputFieldProvince(context, "Provinsi", "Provinsi"),
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
                  inputFieldSubDistrict(context),
                  const SizedBox(height: 15.0),
                  inputFieldKelurahanDesa(context, "Kelurahan / Desa", villageC, "Kelurahan / Desa"),
                  const SizedBox(height: 15.0),
                  inputFieldPhoneNumber(context, "Nomor HP", phoneC, "Nomor HP"),
                  const SizedBox(height: 25.0),
                  CustomButton(
                    isBorder: false,
                    isBoxShadow: false,
                    isBorderRadius: true,
                    onTap: submit,
                    btnTxt: "Simpan",
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget inputFieldProvince(BuildContext context, String title, String hintText) {
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
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Consumer<StoreProvider>(
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
                                                cityName = null;
                                              });
                                              NS.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1.0,
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
            readOnly: true,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: province ?? hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: province == null 
                ? ColorResources.white
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
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Consumer<StoreProvider>(
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
                                              child: Text("Pilih Kecamatan Anda",
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
                                        color: ColorResources.primaryOrange
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
                ? ColorResources.white
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
                color: ColorResources.white
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
                Fluttertoast.showToast(
                  msg: "Pilih provinsi Anda Terlebih Dahulu",
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
                                                margin: const EdgeInsets.only(left: 16),
                                                child: Text("Pilih Kota Anda",
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
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: cityName ?? hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: cityName == null 
                ? ColorResources.white 
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
            style: robotoRegular,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: ColorResources.white
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

  Widget inputFieldLocationAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Label Alamat",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          )
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorResources.white,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child:   Container(
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
              onTap: () {
              setState(() {
                  isCheck = false;
                });
              },
              cursorColor: ColorResources.black,
              controller: typeAddressC,
              keyboardType: TextInputType.text,
              style: robotoRegular,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                hintText: "Ex: Rumah",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, 
                  horizontal: 15.0
                ),
                isDense: true,
                hintStyle: robotoRegular.copyWith(
                  color: ColorResources.white
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
        )
      ],
    );
  }

}

Widget inputFieldKelurahanDesa(BuildContext context, String title, TextEditingController controller, String hintText) {
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
          style: robotoRegular,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: ColorResources.white
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

Widget inputFieldAddress(BuildContext context) {
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
                      onTap: () {
                        NS.push(context, PlacePicker(
                          apiKey: AppConstants.apiKeyGmaps,
                          useCurrentLocation: true,
                          onPlacePicked: (PickResult result) async {
                            await locationProvider.updateCurrentPosition(context, result); 
                            NS.pop(context);
                          },
                          autocompleteLanguage: "id"
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
              color: ColorResources.white
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
              color: ColorResources.white
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