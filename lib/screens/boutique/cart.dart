import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/custom_app_bar.dart';
import 'package:futsal_unique/models/cart_model.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
import 'package:futsal_unique/screens/boutique/list_collections.dart';
import 'package:futsal_unique/screens/boutique/services/stripe_payment.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ScrollController scrollController = ScrollController();
  double? costShipping;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    cart.getCostShipping().then((cost){
      if(mounted){
        setState(() {
          costShipping = cost;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Consumer<CartProvider>(
        builder: (context, value, child){
          return Visibility(
            visible: value.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
            child: Material(
              elevation: 18.0,
              child: Container(
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Color(0xFF96ffcf),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
                   child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sous-Total: ",
                                    style: KGraduateTextStyleTitle.copyWith(fontSize: 14),
                                  ),
                                  Text('€${value.getTotalPrice().toStringAsFixed(2)}',
                                      style: KGraduateTextStyleTitle.copyWith(fontSize: 14))
                                ],
                              ),
                            ),
                            Expanded(child: Divider(thickness: 2.0,)),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Livraison:",
                                  style: KGraduateTextStyleTitle.copyWith(fontSize: 14),
                                ),
                                Text('€' + costShipping.toString(),
                                    style: KGraduateTextStyleTitle.copyWith(fontSize: 14)),
                              ],
                            )),
                            Expanded(child: Divider(thickness: 2.0,)),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// costShipping is double
                                  Text(
                                    "Total: €" + value.getTotalPriceWithShipping(double.parse(costShipping.toString())).toStringAsFixed(2),
                                    style: KGraduateTextStyleTitle,
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      await makePaymentOrder(cart.getCart(), (cart.totalWithShipping * 100).toStringAsFixed(0), context, cart);
                                    },
                                    child: Text(
                                        "Payer Maintenant!",
                                        style:
                                        KLatoTextStyleTextButton.copyWith(color: Colors.black)),
                                    style: OutlinedButton.styleFrom(
                                      shape: StadiumBorder(),
                                      textStyle: KLatoTextStyleText,
                                      side: BorderSide(width: 2.0, color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
              ),
            ),
          );
        },
      ),
      body: (cart.getCart()?.length == 0)?
      Padding(
        padding: EdgeInsets.only(top:50.0, left: 18.0, right: 18.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25.0, right: 15.0),
              child: Row(
                children: [
                  CustomAppBar(),
                  Spacer()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(50.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/empty-cart.png"),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            Text('Votre panier est vide',
                style: kFontColorBlack54TextStyle.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 36),textAlign: TextAlign.center),
            SizedBox(height: 30.0),
            Text('Vous n\'avez ajouté\naucun produit à votre panier!',
              style: kFontColorBlack54TextStyle.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 26),textAlign: TextAlign.center,),
            SizedBox(height: 50.0),
            InkWell(
              onTap: (){
                Get.to(() => ListCollection());
              },
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(30),
                color: colorButton,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Commencer les achats'.toUpperCase(), style: kFontColorWhiteSize18TextStyle,),
                ),
              ),
            )
          ],
        )
        ,
      )
          :ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        controller: scrollController,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
              ),
              Container(
                height: 250.0,
                width: double.infinity,
                color: Color(0xFF3cdc96),
              ),
              Positioned(
                bottom: 600.0,
                right: 150.0,
                child: Container(
                  height: 400.0,
                  width: 400.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200.0),
                    color: Color(0xFF96ffcf),
                  ),
                ),
              ),
              Positioned(
                bottom: 650,
                left: 170.0,
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200.0),
                    color: Color(0xFF96ffcf).withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                child: CustomAppBar(),
              ),
              Positioned(
                top: 75.0,
                left: 15.0,
                child: RichText(
                  text: TextSpan(
                    text: 'Shopping Cart',
                    style: GoogleFonts.graduate(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: kWhiteColorBlackOpacity,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child:
                Padding(
                  padding: const EdgeInsets.only(top:150.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cart.getCart()!.length,
                      itemBuilder: (context, index) {
                        return itemCard(cart.getCart()![index].namePrdct, cart.getCart()![index].colorPrdct,
                            cart.getCart()![index].sizePrdct, cart.getCart()![index].pricePrdct,
                            cart.getCart()![index].imagePrdct, cart.getCart()![index].qty, cart.getCart()![index], cart);
                      }),
                ),
              ),
              SizedBox(height: 250),
            ],
          ),
        ],
        //),
        //],
      ),
    );
  }

  Widget itemCard(itemName, color, size, price, imagePath, qty, Cart cart, CartProvider cartProvider) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 3.0,
          child: Container(
            padding: EdgeInsets.only(left: 15.0, right: 10.0),
            width: MediaQuery.of(context).size.width - 20.0,
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25.0,
                  width: 25.0,
                  child: IconButton(
                      onPressed: () {
                        cartProvider.removeCart(cart);
                        cartProvider.removeCounter();
                        cartProvider.removeTotalPrice(double.parse(price));
                      },
                      icon: Icon(
                        LineIcons.timesCircleAlt,
                        color: Colors.grey.shade400,
                      )),
                ),
                SizedBox(width: 10.0),
                Container(
                  height: 150.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imagePath),
                        fit: BoxFit.contain,
                      )),
                ),
                //SizedBox(width: 4.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          itemName,
                          style:
                          kFontWeightBoldTextStyle.copyWith(fontSize: 15.0),
                        ),
                        SizedBox(width: 4.0),
                      ],
                    ),
                    SizedBox(height: 7.0),
                    Text("Taille: " + size,
                        style: kFontWeightBoldTextStyle.copyWith(
                            fontSize: 14.0, color: Colors.grey)),
                    SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Couleur: ",
                            style: kFontWeightBoldTextStyle.copyWith(
                                fontSize: 14.0, color: Colors.grey)),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: colorButton),
                              shape: BoxShape.circle,
                              color: Color(int.parse(color))
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.0,),
                    Text(
                      '\€' + price.toString(),
                      style: kFontWeightBoldTextStyle.copyWith(
                          fontSize: 20.0, color: colorButton),
                    )
                  ],
                ),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: (qty < 2)? null : () {

                      int quantity = qty;
                      double? price = double.parse(cart.initialPrice.toString());
                      quantity --;

                      double? newPrice = quantity * price;
                      cartProvider.updateQuantity(cart, Cart(
                          cartID: cart.cartID,
                          productID: cart.productID,
                          namePrdct: cart.namePrdct,
                          pricePrdct: newPrice.toString(),
                          initialPrice: cart.initialPrice,
                          qty: quantity,
                          colorPrdct: color,
                          sizePrdct: size,
                          imagePrdct: cart.imagePrdct));
                      newPrice = 0;
                      quantity = 0;
                      cartProvider.removeTotalPrice(double.parse(cart.initialPrice.toString()));
                    },
                    elevation: 2.0,
                    fillColor: colorButton,
                    constraints: BoxConstraints(minWidth: 25.0, minHeight: 25.0),
                    child: Icon(
                      LineIcons.minus,
                      size: 13.0,
                      color: Colors.white,
                    ),
                    //padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                Expanded(
                    child: Center(
                      child: Text(
                        qty.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )),
                Expanded(child:  RawMaterialButton(
                  onPressed: (){
                    int quantity = qty;
                    double? price = double.parse(cart.initialPrice.toString());
                    quantity ++;

                    double? newPrice = quantity * price;
                    cartProvider.updateQuantity(cart, Cart(
                        cartID: cart.cartID,
                        productID: cart.productID,
                        namePrdct: cart.namePrdct,
                        pricePrdct: newPrice.toString(),
                        initialPrice: cart.initialPrice,
                        qty: quantity,
                        colorPrdct: color,
                        sizePrdct: size,
                        imagePrdct: cart.imagePrdct));
                    newPrice = 0;
                    quantity = 0;
                    cartProvider.addTotalPrice(double.parse(cart.initialPrice.toString()));
                  },
                  elevation: 2.0,
                  fillColor: colorButton,
                  constraints: BoxConstraints(minWidth: 25.0, minHeight: 25.0),
                  child: Icon(
                    LineIcons.plus,
                    size: 13.0,
                    color: Colors.white,
                  ),
                  //padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
              ],
            ),
          ),
        ),
      );
  }
}
