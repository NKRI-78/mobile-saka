import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:saka/data/models/ecommerce/region/city.dart';
import 'package:saka/data/models/ecommerce/region/district.dart';
import 'package:saka/data/models/ecommerce/region/province.dart';
import 'package:saka/data/models/ecommerce/region/subdistrict.dart';

import 'package:saka/providers/ecommerce/ecommerce.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/button/custom.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

class EditShippingAddressScreen extends StatefulWidget {
  final String id;

  const EditShippingAddressScreen({
    required this.id,
    super.key, 
  });

  @override
  EditShippingAddressScreenState createState() => EditShippingAddressScreenState();
}

class EditShippingAddressScreenState extends State<EditShippingAddressScreen> {
  late EcommerceProvider ep;
  
  Timer? debounce;

  late TextEditingController detailAddressC;
  late TextEditingController typeAddressC;
  late TextEditingController postalCodeC;

  String province = "";
  String city = "";
  String district = "";
  String subdistrict = "";
  
  bool defaultLocation = false;
  bool isCheck = true;
  List<String> typeTempat = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  Future<void> getData() async {

    if(!mounted) return;
      await ep.getShippingAddressSingle(id: widget.id);
    
    setState(() {
      detailAddressC = TextEditingController(text: ep.shippingAddressDetailData.address);
      typeAddressC = TextEditingController(text: ep.shippingAddressDetailData.name);
      postalCodeC = TextEditingController(text: ep.shippingAddressDetailData.postalCode);
  
      province = ep.shippingAddressDetailData.province!;
      city = ep.shippingAddressDetailData.city!;
      district = ep.shippingAddressDetailData.district!;
      subdistrict = ep.shippingAddressDetailData.subdistrict!;
    });

    if(!mounted) return;
      await ep.getProvince(search: "");

    if(!mounted) return;
      await ep.getCity(provinceName: province, search: "");

    if(!mounted) return;
      await ep.getDistrict(cityName: city, search: "");

    if(!mounted) return;
      await ep.getSubdistrict(districtName: district, search: "");
  }

  @override
  void initState() {
    super.initState();

    detailAddressC = TextEditingController();  
    typeAddressC = TextEditingController();
    postalCodeC = TextEditingController();

    ep = context.read<EcommerceProvider>();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {

    debounce?.cancel();

    detailAddressC.dispose();
    typeAddressC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        title: Text("Ubah Alamat",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: ColorResources.black,
          onPressed: () {
            NS.pop();
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [

          Container(
            margin: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                inputFieldDetailAddress(context, "Alamat",  detailAddressC, "Alamat"),
                
                const SizedBox(
                  height: 15.0,
                ),
                
                inputFieldLocationAddress(context),
                const SizedBox(
                  height: 15.0,
                ),
            
                isCheck
                ? SizedBox()
                : Container(
                    height: 35.0,
                    margin: const EdgeInsets.only(bottom: 15),
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
                                    fontSize: 14,
                                  )
                                )
                              )
                            ),
                        ))
                      ],
                    )
                  ),
                
                inputFieldProvince(context, "Provinsi", province),
                
                const SizedBox(
                  height: 15.0,
                ),
            
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    inputFieldCity(context, "Kota", city),    
                    const SizedBox(width: 15.0), 
                    inputFieldPostCode(context, "Kode Pos", postalCodeC, "Kode Pos"),
                  ],
                ),
                
                const SizedBox(height: 15.0),
                
                inputFieldDistrict(context, district),
                
                const SizedBox(height: 15.0),
                
                inputFieldSubdistrict(context, subdistrict),
                
                const SizedBox(height: 15.0),
            
                 CustomButton(
                  onTap: () async {
                    String detailAddress = detailAddressC.text;
                    String typeAddress = typeAddressC.text;
                    String postalCode = postalCodeC.text;

                    if(detailAddress.trim().isEmpty) { 
                      ShowSnackbar.snackbar("Detail alamat wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(typeAddress.trim().isEmpty) {
                      ShowSnackbar.snackbar("Lokasi wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(province.trim().isEmpty) {
                      ShowSnackbar.snackbar("Provinsi wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(city.trim().isEmpty){
                      ShowSnackbar.snackbar("Kota wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(postalCodeC.text.trim().isEmpty) {
                      ShowSnackbar.snackbar("Kode pos wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(district.trim().isEmpty) {
                      ShowSnackbar.snackbar("Daerah wajib diisi", "", ColorResources.success);
                      return;
                    }
                    if(subdistrict.trim().isEmpty) {
                      ShowSnackbar.snackbar("Kecamatan wajib diisi", "", ColorResources.success);
                      return;
                    }
                    
                    await ep.updateShippingAddress(
                      id: widget.id, label: typeAddress, address: detailAddress, 
                      city: city, postalCode: postalCode, 
                      province: province, district: district, subdistrict: subdistrict
                    );
                  },
                  isLoading: context.watch<EcommerceProvider>().updateShippingAddressStatus == UpdateShippingAddressStatus.loading 
                  ? true 
                  : false,
                  isBorderRadius: true,
                  btnColor: ColorResources.purple,
                  btnTxt: "Simpan",
                )
            
              ],
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
            color:ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1), 
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
                  return  Container(
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
                                            NS.pop();
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

                              Container(
                                margin: EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 16.0,
                                  left: 16.0,
                                  right: 16.0
                                ),
                                child: TextField(
                                  onChanged: (String val) async {
                                    if (debounce?.isActive ?? false) debounce?.cancel();
                                    debounce = Timer(const Duration(milliseconds: 500), () async {
                                      ep.getProvince(search: val);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Cari Provinsi",
                                    hintStyle: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.black
                                    ),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                )
                              ),

                              Expanded(
                                flex: 40,
                                  child: Consumer<EcommerceProvider>(
                                  builder: (_, notifier, __) {
                                    return notifier.provinces.isEmpty 
                                    ?  Center(
                                        child: Text("Provinsi tidak ditemukan",
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: ColorResources.black
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: notifier.provinces.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        ProvinceData provinceData = notifier.provinces[i];

                                        return ListTile(
                                          title: Text(provinceData.provinceName),
                                          onTap: () async {
                                            setState(() {
                                              province = provinceData.provinceName;
                                              subdistrict = "";
                                              city = "";
                                            });
                                            await ep.getCity(provinceName: province, search: "");
                                            NS.pop();
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 1,
                                        );
                                      },
                                    );   
                                  },
                                ),
                              ),

                          ],
                        ),
                      ]
                    )
                  )
                );
              }
            ).then((_) async {
              await ep.getProvince(search: "");
            });
          },
          readOnly: true,
          cursorColor: ColorResources.black,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              color: ColorResources.black
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
        ))
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
            color:ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              if (province == "") {
                ShowSnackbar.snackbar("Pilih provinsi Anda terlebih dahulu", "", ColorResources.error);
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
                                              NS.pop();
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

                                Container(
                                  margin: EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 16.0,
                                    left: 16.0,
                                    right: 16.0
                                  ),
                                  child: TextField(
                                    onChanged: (String val) async {
                                      if (debounce?.isActive ?? false) debounce?.cancel();
                                        debounce = Timer(const Duration(milliseconds: 500), () async {
                                          ep.getCity(provinceName: province, search: val);
                                        });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Cari Kota",
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black
                                      ),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  )
                                ),

                                Expanded(
                                  flex: 40,
                                  child: Consumer<EcommerceProvider>(
                                    builder: (_, notifier, __) {
                                    return notifier.city.isEmpty 
                                      ? Center(
                                          child: Text("Kota tidak ditemukan",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: notifier.city.length,
                                          itemBuilder: (BuildContext context, int i) {
                                          CityData cityData = notifier.city[i];

                                          return ListTile(
                                            title: Text(cityData.cityName),
                                            onTap: () async {
                                              setState(() {
                                                city = cityData.cityName;
                                                subdistrict = "";
                                                postalCodeC = TextEditingController(text: "");
                                              });
                                              await ep.getDistrict(cityName: city, search: "");
                                              NS.pop();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
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
                  }
                ).then((_) async {
                  await ep.getCity(provinceName: province, search: "");
                });
              } 
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: ColorResources.black
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
  
  Widget inputFieldDistrict(BuildContext context, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Daerah",
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
            color:ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              if (city == "") {
                ShowSnackbar.snackbar("Pilih Daerah Anda Terlebih Dahulu", "", ColorResources.error);
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
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
                                              NS.pop();
                                            },
                                            child: const Icon(
                                              Icons.close
                                            )
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 16),
                                            child: Text("Pilih Daerah Anda",
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

                                Container(
                                  margin: EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 16.0,
                                    left: 16.0,
                                    right: 16.0
                                  ),
                                  child: TextField(
                                    onChanged: (String val) async {
                                      if (debounce?.isActive ?? false) debounce?.cancel();
                                        debounce = Timer(const Duration(milliseconds: 500), () async {
                                          ep.getDistrict(cityName: city, search: val);
                                        });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Cari Daerah",
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black
                                      ),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  )
                                ),
                                
                                Expanded(
                                  flex: 40,
                                  child: Consumer<EcommerceProvider>(
                                    builder: (_, notifier, __) {
                                    return notifier.district.isEmpty 
                                      ? Center(
                                          child: Text("Daerah tidak ditemukan",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: notifier.district.length,
                                          itemBuilder: (BuildContext context, int i) {
                                          DistrictData districtData = notifier.district[i];

                                          return ListTile(
                                            title: Text(districtData.districtName),
                                            onTap: () async {
                                              setState(() {
                                                district = districtData.districtName;
                                              });
                                              await ep.getSubdistrict(districtName: district, search: "");
                                              NS.pop();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );   
                                    },
                                  )
                                ),

                              ],
                            ),
                          ]
                        )
                      )
                    );
                  },
                ).then((_) async {
                  await ep.getDistrict(cityName: city, search: "");
                });
              }
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: ColorResources.black
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

  Widget inputFieldSubdistrict(BuildContext context, String hintText) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Kecamatan",
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
            color:ColorResources.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              if (city == "") {
                ShowSnackbar.snackbar("Pilih Daerah Anda Terlebih Dahulu", "", ColorResources.error);
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (BuildContext context) {
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
                                              NS.pop();
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

                                Container(
                                  margin: EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 16.0,
                                    left: 16.0,
                                    right: 16.0
                                  ),
                                  child: TextField(
                                    onChanged: (String val) async {
                                      if (debounce?.isActive ?? false) debounce?.cancel();
                                        debounce = Timer(const Duration(milliseconds: 500), () async {
                                          ep.getSubdistrict(districtName: district, search: val);
                                        });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Cari Kecamatan",
                                      hintStyle: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.black
                                      ),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  )
                                ),

                                Expanded(
                                  flex: 40,
                                  child: Consumer<EcommerceProvider>(
                                    builder: (_, notifier, __) {
                                    return notifier.subdistrict.isEmpty 
                                      ? Center(
                                          child: Text("Kecamatan tidak ditemukan",
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: notifier.subdistrict.length,
                                          itemBuilder: (BuildContext context, int i) {
                                          
                                          SubdistrictData subdistrictData = notifier.subdistrict[i];

                                          return ListTile(
                                            title: Text(subdistrictData.subdistrictName),
                                            onTap: () {
                                              setState(() {
                                                subdistrict = subdistrictData.subdistrictName;
                                                postalCodeC = TextEditingController(text: subdistrictData.zipCode.toString());
                                              });
                                              NS.pop();
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );   
                                    },
                                  )
                                ),

                            ],
                          ),
                        ])
                      )
                    );
                  },
                ).then((_) async {
                  await ep.getSubdistrict(districtName: district, search: "");
                });
              }
            },
            readOnly: true,
            cursorColor: ColorResources.black,
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              isDense: true,
              hintStyle: robotoRegular.copyWith(
                color: ColorResources.black
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
              color:ColorResources.white,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1), 
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
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                hintText: "Ex: Rumah",
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                isDense: true,
                hintStyle: robotoRegular.copyWith(
                  color:ColorResources.white
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
              color:ColorResources.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1), 
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                isDense: true,
                hintStyle: robotoRegular.copyWith(
                  color:ColorResources.white
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

  Widget inputFieldDetailAddress(BuildContext context, String title, TextEditingController controller, String hintText) {
    return StatefulBuilder(
      builder: (BuildContext context, Function setState) {
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
                color:ColorResources.white,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1), 
                    spreadRadius: 1.0, 
                    blurRadius: 3.0, 
                    offset: const Offset(0.0, 1.0)
                  )
                ],
              ),
              child: const SizedBox()
              
              // TypeAheadField(
              //   textFieldConfiguration: TextFieldConfiguration(
              //     cursorColor: ColorResources.black,
              //     controller: controller,
              //     keyboardType: TextInputType.text,
              //     inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              //     decoration:  InputDecoration(
              //       hintText: hintText,
              //       contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              //       isDense: true,
              //       hintStyle: robotoRegular.copyWith(
              //         color:ColorResources.white
              //       ),
              //       focusedBorder: const OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.grey,
              //           width: 0.5
              //         ),
              //       ),
              //       enabledBorder: const OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.grey,
              //           width: 0.5
              //         ),
              //       ),
              //     ),
              //   ),
              //   suggestionsCallback: (String pattern) async {
              //     return context.read<EcommerceProvider>().getAutocomplete(pattern);
              //   },
              //   itemBuilder: (BuildContext context, PredictionModel suggestion) {
              //     return ListTile(
              //       leading: const Icon(Icons.location_city),
              //       title: Text(suggestion.description,
              //         style: robotoRegular.copyWith(
              //           fontSize: Dimensions.fontSizeDefault,
              //           color: ColorResources.black
              //         ),
              //       ),
              //     );
              //   },
              //   onSuggestionSelected: (PredictionModel suggestion) {
              //     setState(() {
              //       controller.text = suggestion.description;
              //     });
              //   },
              // ),
            )
          ]
        );
      },
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
              color:ColorResources.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1), 
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                isDense: true,
                hintStyle: robotoRegular.copyWith(
                  color:ColorResources.white
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
