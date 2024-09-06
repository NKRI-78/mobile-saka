import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:provider/provider.dart';
import 'package:saka/data/models/ecommerce/googlemaps/googlemaps.dart';
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
    Key? key, 
  }) : super(key: key);

  @override
  EditShippingAddressScreenState createState() => EditShippingAddressScreenState();
}

class EditShippingAddressScreenState extends State<EditShippingAddressScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late EcommerceProvider ep;

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
  }

  Future<void> submit() async {
    String detailAddress = detailAddressC.text;
    String typeAddress = typeAddressC.text;
    String postalCode = postalCodeC.text;

    if(detailAddress.trim().isEmpty) { 
      ShowSnackbar.snackbar("Field address detail is required", "", ColorResources.error);
      return;
    }
    if(typeAddress.trim().isEmpty) {
      ShowSnackbar.snackbar("Field location is required", "", ColorResources.error);
      return;
    }
    if(province.trim().isEmpty) {
      ShowSnackbar.snackbar("Field province is required", "", ColorResources.error);
      return;
    }
    if(city.trim().isEmpty){
      ShowSnackbar.snackbar("Field city is required", "", ColorResources.error);
      return;
    }
    if(postalCodeC.text.trim().isEmpty) {
      ShowSnackbar.snackbar("Field postal code is required", "", ColorResources.error);
      return;
    }
    if(district.trim().isEmpty) {
      ShowSnackbar.snackbar("Field district is required", "", ColorResources.error);
      return;
    }
    if(subdistrict.trim().isEmpty) {
      ShowSnackbar.snackbar("Field subdistrict is required", "", ColorResources.error);
      return;
    }
    
    await ep.updateShippingAddress(
      id: widget.id, label: typeAddress, address: detailAddress, 
      city: city, postalCode: postalCode, 
      province: province, district: district, subdistrict: subdistrict
    );

    NS.pop(context);
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
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.black,
          onPressed: () {
            NS.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [

          Container(
            margin: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
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
                          )).toList()
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
                  
                  inputFieldSubDistrict(context, subdistrict),
                  
                  const SizedBox(height: 15.0),

                  Consumer<EcommerceProvider>(
                    builder: (_, notifier, __) {
                      return  CustomButton(
                        onTap: submit,
                        isLoading: notifier.updateShippingAddressStatus == UpdateShippingAddressStatus.loading 
                        ? true 
                        : false,
                        isBorderRadius: true,
                        btnColor: ColorResources.purple,
                        btnTxt: "Simpan",
                      );
                    },
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
            color:ColorResources.white,
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
                                child: FutureBuilder<List<ProvinceData>>(
                                  future: ep.getProvince(),
                                  builder: (BuildContext context, AsyncSnapshot<List<ProvinceData>> snapshot) {
                                  if (snapshot.hasData) {
                                    final List<ProvinceData> provinces = ep.provinces;

                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: provinces.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return ListTile(
                                          title: Text(provinces[i].provinceName),
                                          onTap: () {
                                            setState(() {
                                              province = provinces[i].provinceName;
                                              postalCodeC = TextEditingController(text: "");
                                              subdistrict = "";
                                              city = "";
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
                                  return Center(
                                    child: SizedBox(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircularProgressIndicator()
                                    ),
                                  );
                                }
                              )
                            ),
                          ],
                        ),
                      ]
                    )
                  )
                );
              }
            );
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
                color: Colors.grey.withOpacity(0.1), 
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
                                  child: FutureBuilder<List<CityData>>(
                                    future: ep.getCity(provinceName: province),
                                    builder: (BuildContext context, AsyncSnapshot<List<CityData>> snapshot ) {
                                      if (snapshot.hasData) {
                                        final List<CityData> cities = ep.city;
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:cities.length,
                                          itemBuilder: (BuildContext context, int i) {
                                            return ListTile(
                                              title: Text(cities[i].cityName),
                                              onTap: () {
                                                setState(() {
                                                  city = cities[i].cityName;
                                                  subdistrict = "";
                                                  postalCodeC = TextEditingController(text: "");
                                                });
                                                NS.pop(context);
                                              },
                                            );
                                          },
                                          separatorBuilder: (BuildContext context, int i) {
                                            return const Divider(
                                              thickness: 1,
                                            );
                                          },
                                        );
                                      }
                                      return Center(
                                        child: SizedBox(
                                          width: 32.0,
                                          height: 32.0,
                                          child: CircularProgressIndicator()
                                        ),
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
                );
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
                color: Colors.grey.withOpacity(0.1), 
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
                                              NS.pop(context);
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
                                Expanded(
                                flex: 40,
                                child: FutureBuilder<List<DistrictData>>(
                                  future: ep.getDistrict(cityName: city),
                                  builder: (BuildContext context, AsyncSnapshot<List<DistrictData>> snapshot) {
                                    if (snapshot.hasData) {
                                      
                                      final List<DistrictData> districts = ep.district;

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: districts.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return ListTile(
                                            title: Text(districts[i].districtName),
                                            onTap: () {
                                              setState(() {
                                                district = districts[i].districtName;
                                              });
                                              NS.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int i) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );
                                    }
                                    return Center(
                                      child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: CircularProgressIndicator()
                                      ),
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

  Widget inputFieldSubDistrict(BuildContext context, String hintText) {
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
                color: Colors.grey.withOpacity(0.1), 
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
                                child: FutureBuilder<List<SubdistrictData>>(
                                  future: ep.getSubdistrict(districtName: district),
                                  builder: (BuildContext context, AsyncSnapshot<List<SubdistrictData>> snapshot) {
                                    if (snapshot.hasData) {
                                      final List<SubdistrictData> subdistricts = ep.subdistrict;
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: subdistricts.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return ListTile(
                                            title: Text(subdistricts[i].subdistrictName),
                                            onTap: () {
                                              setState(() {
                                                subdistrict = subdistricts[i].subdistrictName;
                                                postalCodeC = TextEditingController(text: subdistricts[i].zipCode.toString());
                                              });
                                              NS.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int i) {
                                          return const Divider(
                                            thickness: 1,
                                          );
                                        },
                                      );
                                    }
                                    return Center(
                                      child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: CircularProgressIndicator()
                                      ),
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
            color:ColorResources.white,
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
                    color: Colors.grey.withOpacity(0.1), 
                    spreadRadius: 1.0, 
                    blurRadius: 3.0, 
                    offset: const Offset(0.0, 1.0)
                  )
                ],
              ),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  cursorColor: ColorResources.black,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                  decoration:  InputDecoration(
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
                suggestionsCallback: (String pattern) async {
                  return context.read<EcommerceProvider>().getAutocomplete(pattern);
                },
                itemBuilder: (BuildContext context, PredictionModel suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(suggestion.description,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.black
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (PredictionModel suggestion) {
                  setState(() {
                    controller.text = suggestion.description;
                  });
                },
              ),
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
