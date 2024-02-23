
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:saka/services/navigation.dart';

import 'package:saka/data/models/store/cart_add.dart';

import 'package:saka/utils/dimensions.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/helper.dart';
import 'package:saka/utils/constant.dart';

import 'package:saka/views/screens/store/delivery.dart';
import 'package:saka/views/screens/store/detail_product.dart';
import 'package:saka/views/screens/store/edit_note.dart';

import 'package:saka/views/basewidgets/snackbar/snackbar.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

import 'package:saka/providers/store/store.dart';

class CartProdukPage extends StatefulWidget {
  const CartProdukPage({Key? key}) : super(key: key);

  @override
  _CartProdukPageState createState() => _CartProdukPageState();
}

class _CartProdukPageState extends State<CartProdukPage> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  
  late TextEditingController noteC;

  Future<void> getData() async {
    if(mounted) {
      await context.read<StoreProvider>().getCartInfo(context);
    }
  }

  Future<void> increment(String storeId, String productId, int count) async {
    await context.read<StoreProvider>().postEditQuantityCart(context, storeId, productId, count, "increment");
  }

  Future<void> decrement(String storeId, String productId, int count) async {
    if (count >= 1) {
      await context.read<StoreProvider>().postEditQuantityCart(context, storeId, productId, count, "decrement");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await context.read<StoreProvider>().postDeleteProductCart(context, productId);
      ShowSnackbar.snackbar(context, "Barang telah dihapus", "", ColorResources.success);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }   
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    noteC = TextEditingController();    
    noteC.addListener(() {
      setState(() {});
    });

    getData();
  }

  @override
  void dispose() {
    noteC.dispose();

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
        backgroundColor: ColorResources.white,
        leading: CupertinoNavigationBarBackButton(
          color: ColorResources.primaryOrange,
          onPressed: () {
            NS.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Text("Keranjang",
          style: robotoRegular.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorResources.primaryOrange
          ),
        ),
      ),
      body: getCart(),
    );
  }

  Widget getCart() {
    return Consumer<StoreProvider>(
      builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
        if(storeProvider.cartStatus == CartStatus.loading) {
          return const Loader(
            color: ColorResources.primaryOrange,
          );
        }
        if(storeProvider.cartStatus == CartStatus.empty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Keranjang belanjaanmu kosong",
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text("Isi keranjangmu dengan barang impianmu",
                    textAlign: TextAlign.center,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault, 
                      color: ColorResources.black
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text("Mulai Belanja",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault, 
                          color: ColorResources.white
                        )
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true)),
                  )
                ]
              )
            ),
          );
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                left: 16.0, 
                right: 16.0,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 160.0,
                    child: CheckboxListTile(
                      activeColor: ColorResources.success,
                      title: Text("Pilih semua",
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      value: storeProvider.cartData.isActive,
                      onChanged: (bool? val) {
                        storeProvider.cartDataIsActive(val);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  storeProvider.cartData.isActive!
                  ? GestureDetector(
                    onTap: () async {
                      for(StoreElement storeEl in storeProvider.cartData.stores!) {
                        for (StoreElementItem storeElItem in storeEl.items!) {
                          await context.read<StoreProvider>().postDeleteProductCart(context, storeElItem.productId!);
                        }
                      }  
                      ShowSnackbar.snackbar(context, "Barang telah dihapus", "", ColorResources.success);
                    },
                    child: Text("Hapus",
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ) : Container()
                ],
              ) 
            ),
            Container(
              margin: const EdgeInsets.only(top: 60.0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: storeProvider.cartData.stores!.length,
                itemBuilder: (BuildContext context, int i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        activeColor: ColorResources.success,
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Container(
                              height: 30.0,
                              width: 30.0,
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                color: ColorResources.primaryOrange
                              ),
                              child: const Center(
                                child: Icon(Icons.store, 
                                color: ColorResources.white
                              )
                              )
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(storeProvider.cartData.stores![i].store!.name!,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                                Text(storeProvider.cartData.stores![i].store!.city!,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.primaryOrange,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                        value: storeProvider.cartData.stores![i].isActive,
                        onChanged: (bool? val) {
                          storeProvider.cartStoreElementIsActive(val, i);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ...storeProvider.cartData.stores![i].items!.map((item) {
                        return CheckboxListTile( 
                          activeColor: ColorResources.success,
                          contentPadding: EdgeInsets.zero,
                          value: item.isActive,
                          onChanged: (bool? val) {
                            int storeElementItemIdx = storeProvider.cartData.stores![i].items!.indexOf(item);
                            storeProvider.cartStoreElementItemIsActive(val, i, storeElementItemIdx);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                NS.push(context,  DetailProductPage(
                                  productId: item.product!.id!,
                                  typeProduct: "commerce",
                                  path: "",
                                ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.0,
                                    height: 70.0,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                              child: CachedNetworkImage(
                                                imageUrl: "${AppConstants.baseUrlFeedImg}${item.product!.pictures!.first.path}",
                                                fit: BoxFit.cover,
                                                placeholder: (BuildContext context, String url) =>
                                                Center(
                                                  child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[200]!,
                                                  highlightColor: Colors.grey[100]!,
                                                  child: Container(
                                                    color: ColorResources.white,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )),
                                                errorWidget: (BuildContext context, String url, dynamic error) => Center(child: Image.asset( "assets/images/logo/saka.png",fit: BoxFit.cover,
                                                )),
                                              ),
                                            )),
                                          item.product!.discount != null
                                          ? Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                height: 20.0,
                                                width: 25.0,
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  bottomRight: Radius.circular(12.0),
                                                  topLeft: Radius.circular(12.0)
                                                ),
                                                color: Colors.red[900]),
                                                child: Center(
                                                  child: Text(item.product!.discount.discount.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "") + "%",
                                                    style: robotoRegular.copyWith(
                                                      color: ColorResources.white,
                                                      fontSize: Dimensions.fontSizeDefault,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          item.product!.name!.length > 75
                                          ? Text(item.product!.name!.substring(0, 80) + "...",
                                              maxLines: 2,
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                              ),
                                            )
                                          : Text(
                                              item.product!.name!,
                                              maxLines: 2,
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(Helper.formatCurrency(item.product!.price!),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  NS.push(context, EditNoteProductPage(
                                    productId: item.productId!,
                                    note: item.note!,
                                  ));
                                },
                                child: Text(
                                  item.note == "" ? "Tulis catatan untuk barang ini" : item.note!,
                                  style: robotoRegular.copyWith(
                                    color: ColorResources.primaryOrange,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        deleteProduct(item.productId!);
                                      },
                                      child: Icon(Icons.delete,
                                      color: Colors.red[300])
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Wrap(
                                      children: [
                                        SizedBox(
                                          width: 125.0,
                                          height: 35.0,
                                          child: Focus(
                                            onFocusChange: (bool hasFocus) {
                                              String qty = item.controller!.text;
                                              if(qty  == "") {
                                                item.controller!.text = "1";
                                                item.controller!.selection = TextSelection.fromPosition(
                                                  TextPosition(offset: item.controller!.text.length)
                                                );
                                              }
                                            },
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              controller: item.controller,
                                              onChanged: (String qty) {
                                                if(int.parse(qty) >= item.product!.stock!) {
                                                  item.controller!.text = item.product!.stock.toString();
                                                  storeProvider.resetQty(
                                                    qty: item.product!.minOrder.toString(),
                                                    storeId: item.storeId!,
                                                    productId: item.productId!
                                                  );
                                                  item.controller!.selection = TextSelection.fromPosition(
                                                    TextPosition(offset: item.controller!.text.length)
                                                  );
                                                } else if(int.parse(qty) < item.product!.minOrder!) {
                                                  item.controller!.text = item.product!.minOrder.toString();
                                                  item.controller!.selection = TextSelection.fromPosition(
                                                    TextPosition(offset: item.controller!.text.length)
                                                  );
                                                } else {
                                                  storeProvider.onChangeQty(
                                                    qty: qty, 
                                                    price: item.price!, 
                                                    storeId: item.storeId!,
                                                    productId: item.productId!
                                                  );
                                                  item.controller!.selection = TextSelection.fromPosition(
                                                    TextPosition(offset: item.controller!.text.length)
                                                  );
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0
                                                ),
                                                filled: true,
                                                prefixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (item.quantity! > item.product!.minOrder!) {
                                                      var currval = int.parse(item.controller!.text);
                                                      setState(() {
                                                        currval = currval - 1;
                                                        item.controller!.text = (currval).toString();
                                                      });
                                                      decrement(item.storeId!, item.productId!, (currval));
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.do_not_disturb_on,
                                                    color: ColorResources.error,
                                                  )
                                                ),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (item.quantity! >= item.product!.stock!)  {
                                                      ShowSnackbar.snackbar(context, "Stok barang tidak ada", "", ColorResources.error);
                                                      return;
                                                    } else {
                                                      var currval = int.parse(item.controller!.text);
                                                      setState(() {
                                                        currval = currval + 1;
                                                        item.controller!.text = (currval).toString();
                                                      });
                                                      increment(item.storeId!, item.productId!, (currval));
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.add_circle,
                                                    color: ColorResources.success,
                                                  ),
                                                ),
                                                fillColor: ColorResources.white,
                                                border: const OutlineInputBorder(),
                                              ),
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeDefault,
                                                color: ColorResources.black,
                                              ),
                                            ),
                                          )
                                        ),
                                        const SizedBox(
                                          width: 3.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                            ]
                          )
                        );
                      }).toList()
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 4), 
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Harga",
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.primaryOrange,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                modalInputan();
                              },
                              child: Row(
                                children: [
                                  Text(Helper.formatCurrency(
                                    storeProvider.cartData.totalProductPrice! + storeProvider.cartData.serviceCharge!),
                                    style: robotoRegular.copyWith(
                                      color: ColorResources.black,
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  const Icon(
                                    Icons.expand_less,
                                    color: ColorResources.black
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if(storeProvider.cartData.numOfItems == 0) {
                          ShowSnackbar.snackbar(context, "Anda belum memilih barang", "", ColorResources.error);
                          return;
                        } else {
                          NS.push(context, const DeliveryScreen());
                        }
                      },
                      child: Container(
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: ColorResources.primaryOrange),
                        child: Center(
                          child: Text("Beli (" + storeProvider.cartData.numOfItems.toString() + ")",
                            style: robotoRegular.copyWith(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeExtraLarge,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              )
            )
          ],
        );
      }
    );
  }

  void modalInputan() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
          color: ColorResources.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0)
            )
          ),
          child: Column(
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
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            NS.pop(context);
                          },
                          child: const Icon(Icons.close)
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16.0),
                          child: Text("Ringkasan Belanja",
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w600,
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
              Consumer<StoreProvider>(
                builder: (BuildContext context, StoreProvider storeProvider, Widget? child) {
                  if(storeProvider.cartStatus == CartStatus.loading) {
                    return Container();
                  } 
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Harga (" + storeProvider.cartData.numOfItems.toString() + " barang)",
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault
                                )
                              ),
                              Text(Helper.formatCurrency(storeProvider.cartData.totalProductPrice! + storeProvider.cartData.serviceCharge!),
                                style: robotoRegular.copyWith(
                                  color: ColorResources.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ]
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Bayar",
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault
                              )
                            ),
                            Text(
                              Helper.formatCurrency(storeProvider.cartData.totalProductPrice! + storeProvider.cartData.serviceCharge!),
                              style: robotoRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ]
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          )
        );
      },
    );
  }

  Widget loadingList(int index) {
    return  Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: index,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 12.0,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResources.white
                ),
              ),
              Container(
                width: 120,
                height: 12.0,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResources.white
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
