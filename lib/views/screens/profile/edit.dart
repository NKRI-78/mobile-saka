import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart' as s;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:saka/data/models/profile/profile.dart';
import 'package:saka/data/models/region/region.dart';

import 'package:saka/localization/language_constraints.dart';

import 'package:saka/providers/profile/profile.dart';

import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';

import 'package:saka/views/basewidgets/loader/circular.dart';
import 'package:saka/views/basewidgets/snackbar/snackbar.dart';

enum StatusBlood { none, a, b, ab, o }

class ProfileEditScreen extends StatefulWidget {
  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  ProfileData profileData = ProfileData();
  File? file;
  ImageSource? imageSource;
  String? sportType;

  late TextEditingController emailC;
  late TextEditingController fullnameC;
  late TextEditingController noAnggotaC;
  late TextEditingController noHpC;
  late TextEditingController addressC;

  s.SearchBarController<dynamic> searchBarProvince = s.SearchBarController<dynamic>();
  s.SearchBarController<dynamic> searchBarCity =  s.SearchBarController<dynamic>();

  String? province;
  String? city;
  String? codeProvince;
  String? codeCity;

  List<Province> provinces = [];
  List<City> cities = [];

  // Future<List<Province>> getRegionRegister() async {
  //   try {
  //     Dio dio = Dio();
  //     Response res = await dio.get("https://api-kosgoro.connexist.id/user-service/region");
  //     RegionRegisterModel regionRegisterModel = RegionRegisterModel.fromJson(res.data);
  //     setState(() {     
  //       provinces = [];
  //       cities = [];
  //     });
  //     List<Province> provinsi = regionRegisterModel.provinsi!;
  //     List<City> kabupatenKota = regionRegisterModel.kabupatenKota!;
  //     setState(() {
  //       provinces.addAll(provinsi);
  //       cities.addAll(kabupatenKota);
  //     });
  //   } on DioError catch(e) {
  //     ShowSnackbar.snackbar(context, "${e.response!.data}", "", ColorResources.error);
  //   } catch(stacktrace) {
  //     debugPrint(stacktrace.toString());
  //   }
  //   return provinces;
  // }

  Future<void> uploadPic() async {
    imageSource = await showDialog<ImageSource>(context: context, builder: (context) => 
      AlertDialog(
        title: Text(getTranslated("SOURCE_IMAGE", context),
        style: robotoRegular.copyWith(
          color: ColorResources.brown,
          fontWeight: FontWeight.w600, 
          fontSize: Dimensions.fontSizeSmall
        ),
      ),
      actions: [
        MaterialButton(
          child: Text(getTranslated("CAMERA", context),
            style: robotoRegular.copyWith(
              color: ColorResources.black,
              fontSize: Dimensions.fontSizeSmall
            )
          ),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        MaterialButton(
          child: Text(getTranslated("GALLERY", context),
            style: robotoRegular.copyWith(
              color: ColorResources.black,
              fontSize: Dimensions.fontSizeSmall
            ),
          ),
          onPressed: () => Navigator.pop(context, ImageSource.gallery))
        ],
      )
    );
    if(imageSource == ImageSource.camera) {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 480.0, 
        maxWidth: 640.0,
        imageQuality: 70
      );
      if(pickedFile != null) {
        setState(() => file = File(pickedFile.path));
        File? cropped = await ImageCropper().cropImage(
          sourcePath: file!.path,
        );  
        if(cropped != null) {
          File f = File(cropped.path);
          setState(() => file = f);
        } else {
          setState(() => file = null);
        }
      }
    } else {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 480.0, 
        maxWidth: 640.0,
        imageQuality: 70
      );
      if(pickedFile != null) {
        setState(() => file = File(pickedFile.path));
        File? cropped = await ImageCropper().cropImage(
          sourcePath: file!.path,
        );  
        if(cropped != null) {
          File f = File(cropped.path);
          setState(() => file = f);
        } else {
          setState(() => file = null);
        }
      }
    }
  }

  Future<List<Province>> getAllProvince(String province) async {
    await Future.delayed(Duration(seconds: province.length == 4 ? 2 : 2));
    return provinces.where((item) => item.nama!.toLowerCase().contains(province.toLowerCase())).toList();
  }

  Future<List<City>> getAllCity(String city) async {
    await Future.delayed(Duration(seconds: city.length == 4 ? 2 : 2));
    var filteredCityList = cities.where((el) => el.provinsiId == codeProvince).toList();
    return filteredCityList.where((item) => item.nama!.toLowerCase().contains(city.toLowerCase())).toList();
  }

  Future<void> save(BuildContext context) async {
    String address = addressC.text;
    String fullname = fullnameC.text;
    String phone = noHpC.text;
    if(fullname.isEmpty) {
      ShowSnackbar.snackbar(context, "Nama Lengkap tidak boleh kosong", "", ColorResources.error);
      return;
    }
    if(phone.isEmpty) {
      ShowSnackbar.snackbar(context, "No HP tidak boleh kosong", "", ColorResources.error);
      return;
    }
    profileData.fullname = fullname;
    profileData.address = address;
    profileData.province = province;
    profileData.codeProvince = codeProvince;
    profileData.city = city;
    profileData.codeCity = codeCity;
    
    await context.read<ProfileProvider>().updateProfile(context, profileData, file);
  }
   
  @override
  void initState() {
    super.initState();
    emailC = TextEditingController();
    fullnameC = TextEditingController();
    noAnggotaC = TextEditingController();
    noHpC = TextEditingController();
    addressC = TextEditingController();

    Future.delayed(Duration.zero, () async {
      // getRegionRegister();
      if(mounted) {
        context.read<ProfileProvider>().getUserProfile(context);
      }
      fullnameC.text = context.read<ProfileProvider>().userProfile.fullname!;
      emailC.text = context.read<ProfileProvider>().getUserEmail;
      noHpC.text = context.read<ProfileProvider>().getUserPhoneNumber;
      addressC.text = context.read<ProfileProvider>().userProfile.address!;
      setState(() { 
        province =  context.read<ProfileProvider>().userProfile.province;
        city =  context.read<ProfileProvider>().userProfile.lanud;
      });
    });
  }

  @override 
  void dispose() {
    emailC.dispose();
    fullnameC.dispose();
    noAnggotaC.dispose();
    noHpC.dispose();
    addressC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.brown,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(getTranslated("EDIT_PROFILE", context),
          style: robotoRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeSmall
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          Stack(
            clipBehavior: Clip.none,
            children: [

              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  color: ColorResources.brown
                ),
                clipper: CustomClipPath(),
              ),

              Align(  
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 40.0, left: 30.0),
                  child: Stack(
                    children: [
                      Consumer<ProfileProvider>(
                        builder: (BuildContext context, ProfileProvider profileProvider,  Widget? child) {
                          return profileProvider.profileStatus == ProfileStatus.loading 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.black,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Center(
                                  child: Text("...",
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.white
                                    )
                                  ),
                                ),
                                width: 100.0,
                                height: 100.0,
                              ),
                            )
                          : profileProvider.profileStatus == ProfileStatus.error 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorResources.black,
                                  borderRadius: BorderRadius.circular(50.0),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/logo.png'),
                                    fit: BoxFit.cover
                                  )
                                ),
                                width: 100.0,
                                height: 100.0,
                              ),
                            )
                          : file == null 
                          ? CachedNetworkImage(
                              imageUrl: "${profileProvider.userProfile.profilePic}",
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorResources.black,
                                      borderRadius: BorderRadius.circular(50.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover
                                      )
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                );
                              },
                              placeholder: (BuildContext context, String url) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.primaryOrange,
                                      borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.asset('assets/images/logo.png'),
                                  ),
                                );
                              },
                              errorWidget: (BuildContext context, String url, dynamic error) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                      color: ColorResources.primaryOrange,
                                      borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    width: 100.0,
                                    height: 100.0,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Image.asset('assets/images/logo.png')
                                    ),
                                  ),
                                );
                              },
                            ) 
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Container(
                              decoration: BoxDecoration(
                                color: ColorResources.black,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              width: 100.0,
                              height: 100.0,
                              child: Image.file(
                              file!,
                              fit: BoxFit.cover,
                            )),
                          );
                        },
                      ),         
                      Positioned(
                        right: 5.0,
                        bottom: 0.0,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: ColorResources.primaryOrange,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: InkWell(
                            onTap: uploadPic,
                            child: Icon(
                              Icons.camera_alt,
                              size: 12.0,
                              color: ColorResources.white   
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            
              Align(  
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 60.0, left: 145.0, right: 10.0),
                  child: TextField(
                    cursorColor: ColorResources.primaryOrange,
                    controller: fullnameC,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: robotoRegular.copyWith(
                        color: ColorResources.white
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorResources.white
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorResources.white
                        )
                      ),
                    ),
                    style: robotoRegular.copyWith(
                      color: ColorResources.white
                    ),
                  )
                ),
              ),

            ],
          ),

          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Card(
              elevation: 3.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      inputComponent(context, getTranslated("ADDRESS", context), addressC, false),
                      SizedBox(height: 10.0),
                    ],
                  ),
                )
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                FittedBox(
                  child: Container(
                    width: 150.0,
                    height: 30.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: ColorResources.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      onPressed: () => Navigator.of(context).pop(), 
                      child: Text(getTranslated("BACK", context),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.white
                        ),
                      )
                    ),
                  ),
                ),
                Consumer<ProfileProvider>(
                  builder: (BuildContext context, ProfileProvider profileProvider, Widget? child) {
                    return FittedBox(
                      child: Container(
                        width: 150.0,
                        height: 30.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: ColorResources.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            )
                          ),
                          onPressed: () => save(context), 
                          child: profileProvider.updateProfileStatus == UpdateProfileStatus.loading 
                          ? Loader(
                            color: ColorResources.white,
                          ) 
                          : Text(getTranslated("SAVE", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: ColorResources.white
                            ),
                          )
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )

        ],
      ),
    );
  }

  modal(String typeInput) {
    if(province != "-" || province != null || province != "") {
      codeProvince  = provinces.firstWhere((item) => item.nama == province).kode;
    }
    var citiesFiltered = cities.where((item) => item.provinsiId ==  codeProvince).toList();

    if(typeInput == "city")
      return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorResources.primaryOrange,
            ),
            width: double.infinity,
            height: 50.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTranslated("SELECT_CITY", context),
                    style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w600
                  )
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),              
              height: MediaQuery.of(context).size.height / 2.0,
              child: s.SearchBar(
                searchBarPadding: EdgeInsets.symmetric(horizontal: 8.0),
                headerPadding: EdgeInsets.symmetric(horizontal: 8.0),
                listPadding: EdgeInsets.symmetric(horizontal: 8.0),
                onSearch: (val) {
                  return getAllCity(val!);
                },
                searchBarController: searchBarCity,
                debounceDuration: Duration(milliseconds: 500),
                placeHolder: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) {
                    return Divider();
                  },
                  itemCount: citiesFiltered.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if(i == citiesFiltered.length) {
                      return SizedBox(height: 20.0);
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          city = citiesFiltered[i].nama;
                          codeCity = citiesFiltered[i].kode;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, left:12.0),
                        child: Text(citiesFiltered[i].nama!,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    );
                  },
                ),
                cancellationWidget: Text("Batal",
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
                emptyWidget: Container(
                margin: EdgeInsets.only(top: 5.0, left: 12.0),
                child: Text( "Data tidak ditemukan",
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600
                    )
                  )
                ),
                header: Row(),
                onCancelled: () {},
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                crossAxisCount: 2,
                onItemFound: (dynamic kota, int i) {

                  return Container(
                    child: ListTile(
                      title: Text(kota.nama,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      onTap: () {
                        setState(() {
                          city = kota.nama;
                          codeCity = kota.kode;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );

                },
              ),
            ),
          )
        ],
      );
    });

    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorResources.primaryOrange,
            ),
            width: double.infinity,
            height: 50.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(getTranslated("SELECT_PROVINCE", context),
                    style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  )
                )
              ]
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorResources.white
            ),
            height: MediaQuery.of(context).size.height / 2.0,
            child: s.SearchBar(
              searchBarPadding: EdgeInsets.symmetric(horizontal: 8.0),
              headerPadding: EdgeInsets.symmetric(horizontal: 8.0),
              listPadding: EdgeInsets.symmetric(horizontal: 8.0),
              onSearch: (val) {
                return getAllProvince(val!);
              },
              searchBarController: searchBarProvince,
              debounceDuration: Duration(milliseconds: 500),
              placeHolder: ListView.separated(
                separatorBuilder: (BuildContext context, int i) {
                  return Divider();
                },
                itemCount: provinces.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if(i == provinces.length) {
                    return SizedBox(height: 20.0);
                  }
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        codeProvince = provinces[i].kode;
                        province = provinces[i].nama;
                        city = null;
                        codeCity = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0, left:12.0),
                        child: Text(provinces[i].nama!,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    );
                  },
                ),
              cancellationWidget: Text("Batal",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              ),
              emptyWidget: Container(
              margin: EdgeInsets.only(top: 5.0, left: 12.0),
              child: Text( "Data tidak ditemukan",
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  )
                )
              ),
              header: Row(),
              onCancelled: () {},
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              onItemFound: (dynamic provinsi, int i) {

                return ListTile(
                  title: Text(provinsi.nama,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight:FontWeight.w600
                    )
                  ),
                  onTap: () {
                    setState(() {
                      codeProvince = provinsi.kode;
                      province = provinsi.nama;
                      city = null;
                      codeCity = null;
                    });
                    Navigator.pop(context);
                  },
                );

              },
            ),
          )
        ],
      );
    });
  }

  Widget inputComponent(BuildContext context, String label, TextEditingController textEditingController, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall
          ),
        ),
        TextField(
          readOnly: readOnly,
          controller: textEditingController,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall
          ),
          decoration: InputDecoration(
            isDense: true,
            hintStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            ),
          ),
        ),
      ],
    );
  }
}


class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 140);
    path.quadraticBezierTo(size.width / 2, size.height, 
    size.width, size.height - 140);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
