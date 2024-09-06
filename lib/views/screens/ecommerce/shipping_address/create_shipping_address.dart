import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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

import 'package:provider/provider.dart';

class CreateShippingAddressScreen extends StatefulWidget {

  const CreateShippingAddressScreen({
    Key? key, 
  }) : super(key: key);

  @override
  CreateShippingAddressScreenState createState() => CreateShippingAddressScreenState();
}

class CreateShippingAddressScreenState extends State<CreateShippingAddressScreen> {
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
    
    await ep.createShippingAddress(
      label: typeAddress,
      address: detailAddress, 
      city: city, postalCode: postalCode, 
      province: province, district: district,
      subdistrict: subdistrict,
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
  }

  @override 
  void dispose() {

    detailAddressC.dispose();
    typeAddressC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        title: Text("Buat Alamat",
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
            color: ColorResources.black, 
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
                  ? Container()
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
                  inputFieldSubdistrict(context, subdistrict),
                  const SizedBox(height: 25.0),

                  Consumer<EcommerceProvider>(
                    builder: (_, notifier, __) {
                      return CustomButton(
                        onTap: submit,
                        isLoading: notifier.createShippingAddressStatus == CreateShippingAddressStatus.loading 
                        ? true 
                        : false,
                        isBorderRadius: true,
                        btnColor: ColorResources.purple,
                        btnTextColor: ColorResources.white,
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
                                    final List<ProvinceData> provinces = snapshot.data!;

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
          ),
        )
      ],
    );          
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
                ShowSnackbar.snackbar("Pilih Kota Anda Terlebih Dahulu", "", ColorResources.error);
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
                                      final List<DistrictData> districts = snapshot.data!;
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
                                                // postalCodeC = TextEditingController(text: subdistricts[i].postalCode.toString());
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
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1.0, 
                blurRadius: 3.0, 
                offset: const Offset(0.0, 1.0)
              )
            ],
          ),
          child: TextFormField(
            onTap: () {
              if (district == "") {
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
                                      final List<SubdistrictData> subdistricts = snapshot.data!;
                                      
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
                ShowSnackbar.snackbar("Pilih Provinsi Anda terlebih dahulu", "", ColorResources.error);
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
                                    builder: (context, snapshot) {
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
