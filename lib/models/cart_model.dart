import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  late final String? cartID;
  String? productID;
  String? namePrdct;
  String? pricePrdct;
  String? initialPrice;
  int? qty;
  String? colorPrdct;
  String? sizePrdct;
  String? imagePrdct;
  String? userID;


  Cart({
     this.cartID,
     this.productID,
     this.namePrdct,
     this.pricePrdct,
     this.initialPrice,
     this.qty,
     this.colorPrdct,
     this.sizePrdct,
      this.imagePrdct,
    this.userID
  });

}