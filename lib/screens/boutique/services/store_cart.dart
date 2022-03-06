import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/models/cart_model.dart';
import 'package:futsal_unique/screens/reservation/recap_reservation.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> StoreOrder(List<Cart>? cart, double totalPrice, context) async {
  try{
    final CollectionReference collOrder = FirebaseFirestore.instance.collection("orders");
    final newDocId = collOrder.doc().id;

    final now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    final DateTime finalDate = DateTime.parse(formattedDate);

    print('doc id is = $newDocId');
    final products = cart?.map((item) {
      return {
        'productID' : item.productID,
        'namePrdct' : item.namePrdct,
        'pricePrdct' : item.pricePrdct,
        'initialPrice' : item.initialPrice,
        'qty' : item.qty,
        'colorPrdct' : item.colorPrdct,
        'sizePrdct' : item.sizePrdct,
        'imagePrdct' : item.imagePrdct,
      };
    }).toList();
    collOrder.doc(newDocId).set({
      'cartID': newDocId,
      'cartItems': products,
      'totalPrice': totalPrice,
      'status': 'En attente',
      'timeCreated': finalDate,
      'userId': '',
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Commande envoyée avec succès!", style: textStyleWhite,textAlign: TextAlign.center,),
        elevation: 8.0,
        backgroundColor: colorButton,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),));
    });
  } catch(e) {
    print(e);
  }

}