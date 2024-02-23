import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';

import 'package:saka/providers/region/region.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/views/screens/store/add_address.dart';
import 'package:saka/views/screens/store/edit_address.dart';

class SelectAddressPage extends StatefulWidget {
  final String title;

  const SelectAddressPage({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future<void> getData() async {
    if(mounted) {
      await context.read<RegionProvider>().getDataAddress(context);
    }
  }

  @override 
  void initState() {
    super.initState();

    getData();
  }

  @override 
  void dispose() {
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
        title: Text(widget.title,
          style: robotoRegular.copyWith(
            color: ColorResources.black, 
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: ColorResources.white,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.black,
          onPressed: () {
            NS.pop(context);
          },
        )
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Consumer(
            builder: (BuildContext context, RegionProvider regionProvider, Widget? child) {
              if(regionProvider.getAddressStatus == GetAddressStatus.loading) {
                return const Loader(
                  color: ColorResources.primaryOrange,
                );
              }
              return regionProvider.addressList.isEmpty
              ? emptyAddress()
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0, top: 16.0),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: regionProvider.addressList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          ProgressDialog pr = ProgressDialog(context: context);
                          if (widget.title != "Daftar Alamat") {
                            pr.show(
                              max: 2,
                              msg: "Mohon Tunggu...",
                              borderRadius: 10.0,
                              backgroundColor: ColorResources.white,
                              progressBgColor: ColorResources.primaryOrange
                            );
                            await context.read<RegionProvider>().selectedAddress(context, regionProvider.addressList, i);                          
                            pr.close();
                            NS.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(regionProvider.addressList[i].name!,
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                        const SizedBox(height: 5),
                                        Text(regionProvider.addressList[i].phoneNumber!,
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: Dimensions.fontSizeDefault,
                                          )
                                        ),
                                        const SizedBox(height: 3),
                                        Text(regionProvider.addressList[i].address!,
                                          style: robotoRegular.copyWith(
                                            color: ColorResources.black,
                                            fontSize: 14,
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  widget.title != "Daftar Alamat"
                                  ? regionProvider.addressList[i].defaultLocation == true
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: ColorResources.primaryOrange
                                      )
                                    : Container()
                                  : Container()
                                ],
                              ),
                              const SizedBox(height: 14.0),
                              GestureDetector(
                                onTap: () {
                                  NS.push(context, EditAlamatPage(
                                    idAddress: regionProvider.addressList[i].id,
                                    typeAddress: regionProvider.addressList[i].name,
                                    province: regionProvider.addressList[i].province,
                                    city: regionProvider.addressList[i].city,
                                    village: regionProvider.addressList[i].village,
                                    postalCode: regionProvider.addressList[i].postalCode,
                                    address: regionProvider.addressList[i].address,
                                    subDistrict: regionProvider.addressList[i].subdistrict,
                                    phoneNumber: regionProvider.addressList[i].phoneNumber,
                                    defaultLocation: regionProvider.addressList[i].defaultLocation,
                                  ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 2.0,
                                      color: Colors.grey[350]!,
                                    )
                                  ),
                                  child: Center(
                                    child: Text("Ubah Alamat",
                                      style: robotoRegular.copyWith(
                                        color: ColorResources.primaryOrange,
                                        fontSize: Dimensions.fontSizeDefault,
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
            }
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorResources.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text("Tambah Alamat Baru",
                      style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault, 
                      color: ColorResources.white
                    )),
                  ),
                  onPressed: () {
                    NS.push(context, const TambahAlamatPage());
                  },
                )
              )
            )
          )
        ],
      )
    );
  }

  Widget emptyAddress() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Anda belum mengisi alamat",
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black,
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(height: 5.0),
            Text("Isi alamat anda dengan menambah alamat baru",
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault, 
                color: ColorResources.black
              ),
            ),
          ]
        )
      ),
    );
  }
}