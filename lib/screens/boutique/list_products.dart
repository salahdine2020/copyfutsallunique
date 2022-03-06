import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/custom_app_bar.dart';
import 'package:futsal_unique/common_widgets/shopping_bag.dart';
import 'package:futsal_unique/models/category_model.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
import 'package:futsal_unique/screens/boutique/list_collections.dart';
import 'package:futsal_unique/screens/boutique/single_product.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ListProducts extends StatelessWidget {
  final Category category;
  const ListProducts({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: CustomAppBar(),
          actions: [
            ShopBag(),
          ],
        ),

        body: ListView(
          /*crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,*/
          children: [
            Container(
                margin: EdgeInsets.only(left: 16.0, top: 30),
                child: TopOfScreen(category.nameCat.toString(), context)),
            Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Divider(thickness: 3.0,endIndent: 300.0,color: colorButton,)),
            SizedBox(height: 50),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("categories").doc(category.categoryID)
                    .collection("products").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotPrdcts ){
                  if(snapshotPrdcts.hasError){
                    return Center(child: Text('Oops... Une erreur s\'est produite'));
                  }
                  if(snapshotPrdcts.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(color: colorButton,));
                  } else {
                    return GridView.count(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: .63,
                      padding: const EdgeInsets.all(12),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 20,
                      children: snapshotPrdcts.data!.docs.map((DocumentSnapshot prdctDoc) {
                        Map<String, dynamic> data = prdctDoc.data() as Map<String, dynamic>;
                        return buildCard(data, cartProvider);
                      }).toList(),
                    );
                  }
                }),

          ],
        )
    );
  }

  Widget TopOfScreen(String cat_name, context) {
    return RichText(
      text: TextSpan(
        text: cat_name.toUpperCase(),
        style: GoogleFonts.graduate(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: kWhiteColorBlackOpacity,
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> data, CartProvider cartProvider) {
    return GestureDetector(
        onTap: () => Get.to(() => SingleProduct(data: data, cat_name: category.nameCat.toString())),
        child: Badge(
          badgeColor: colorButton,
          position: BadgePosition.topStart(),
          padding: EdgeInsets.all(16.0),
          showBadge: (data['percentDiscount'] == 0)? false : true,
          badgeContent: Text(data['percentDiscount'].toString()+'%', style: textStyleWhite),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      offset: Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Center(
                        child: Image.network(
                          data['imagePrdct'],
                          width: 150,
                          //height: 120,
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("\€" + data['pricePrdct'].toString(),
                          style: kFontSize18TextStyle.copyWith(color: Colors.grey, decoration:
                          (data['percentDiscount']) == 0 ? TextDecoration.none :TextDecoration.lineThrough),
                      ),
                    ),
                    Expanded(
                      child: Text((data['percentDiscount']) == 0 ? ""
                          : "€"+cartProvider.getProductPriceWithSale(data['percentDiscount'],double.parse(data['pricePrdct'])).toString() ,
                        style: kFontSize18TextStyle.copyWith(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Expanded(child: IconButton(
                        icon: Icon(LineIcons.addToShoppingCart, color: colorButton, size: 35,),
                        onPressed: () {
                          Get.to(() => SingleProduct(data: data, cat_name: category.nameCat.toString()));
                        }),
                    )
                  ],
                ),
                Expanded(
                  child: Text(
                      data['namePrdct'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kFontSize18FontWeight600TextStyle
                  ),
                ),
                Expanded(
                  child: Text(
                      data['brandPrdct'],
                      style: kFontSize18TextStyle.copyWith(color: Colors.grey)
                  ),
                ),
              ],
            ),
          ),
        )
      //     ? Container(
      //   padding: const EdgeInsets.all(8.0),
      //   decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(15),
      //       boxShadow: [
      //         BoxShadow(
      //             color: Colors.grey.withOpacity(.5),
      //             offset: Offset(3, 2),
      //             blurRadius: 7)
      //       ]),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Center(
      //         child: ClipRRect(
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(15),
      //               topRight: Radius.circular(15),
      //             ),
      //             child: Center(
      //               child: Image.network(
      //                 data['imagePrdct'],
      //                 width: 150,
      //                 //height: 120,
      //               ),
      //             )),
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Expanded(
      //             child: Text(
      //               "\€" + data['pricePrdct'].toString(),
      //               style: kFontSize18TextStyle.copyWith(fontSize: 18),
      //             ),
      //           ),
      //           Expanded(child: IconButton(
      //               icon: Icon(LineIcons.addToShoppingCart, color: colorButton, size: 35,),
      //               onPressed: () {
      //                 Get.to(() => SingleProduct(data: data, cat_name: category.nameCat.toString()));
      //               }),
      //           )
      //         ],
      //       ),
      //       Expanded(
      //         child: Text(
      //             data['namePrdct'],
      //             maxLines: 1,
      //             overflow: TextOverflow.ellipsis,
      //             style: kFontSize18FontWeight600TextStyle
      //         ),
      //       ),
      //       Expanded(
      //         child: Text(
      //             data['brandPrdct'],
      //             style: kFontSize18TextStyle.copyWith(color: Colors.grey)
      //         ),
      //       ),
      //     ],
      //   ),
      // )
      //
      //     :
    );
  }
}
