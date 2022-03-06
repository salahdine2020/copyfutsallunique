import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/models/cart_model.dart';
import 'package:collection/collection.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get_core/src/get_main.dart';
class CartProvider with ChangeNotifier {

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  double _totalWithShipping = 0.0;
  double get totalWithShipping => _totalWithShipping;

  double _prdctPriceWithSale = 0.0;
  double get prdctPriceWithSale => _prdctPriceWithSale;

  List<Cart>? _cart = [];
  List<Cart>? get cart => _cart;

  Future<double> getCostShipping() async{
    final collShipping = await FirebaseFirestore.instance.collection("shipping").get();
    final snapshot =  collShipping.docs[0];
    double shippingPrice = double.parse(snapshot['costShipping']);
    return shippingPrice;
  }


  void updateQuantity(Cart oldCartItem, Cart newCartItem) async {

    _cart!.contains(oldCartItem) ?_cart![_cart!.indexWhere((element) => element == oldCartItem)] = newCartItem : _cart ;
    notifyListeners();
  }

  void addCart(Cart cart, BuildContext context) async{

    List<Cart>? items = getCart();

    Cart? item = items?.firstWhereOrNull((element) => ((element.cartID == cart.cartID)
        && (element.productID == cart.productID) && (element.sizePrdct == cart.sizePrdct)
        && (element.colorPrdct == cart.colorPrdct) && (element.imagePrdct == cart.imagePrdct)
        && (element.namePrdct == cart.namePrdct) && (element.userID == cart.userID)));
    if(item == null) {
      // TODO ajouter produit ds le panier
      print('not exist');
      _cart?.add(cart);
      addTotalPrice(double.parse(cart.pricePrdct.toString()));
      addCounter();
    } else {
      // TODO afficher un message
      print('exist');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${cart.namePrdct} est déjà ajouté au panier!", style: textStyleWhite,textAlign: TextAlign.center,),
      elevation: 8.0,
      backgroundColor: colorButton,
      behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),));
    }
    print('${items?.length.toString()} item added');
    notifyListeners();
  }

  void removeCart(Cart cart) {
    _cart?.remove(cart);
    notifyListeners();
  }

  List<Cart>? getCart() {
    return _cart;
  }

  void addTotalPrice(double pricePrdct) {
    _totalPrice += pricePrdct;
    notifyListeners();
  }

  double getTotalPriceWithShipping(double _shippingPrice){
    _totalWithShipping = _shippingPrice + _totalPrice;
    return _totalWithShipping;
  }

  double getProductPriceWithSale(int percentage, double pricePrdct){
    double discount = (pricePrdct * percentage ) / 100;
    _prdctPriceWithSale = pricePrdct - discount;
    return _prdctPriceWithSale;
  }

  void removeTotalPrice(double pricePrdct) {
    _totalPrice -= pricePrdct;
    //_setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    notifyListeners();
  }

  int getCounter() {
    return _counter;
  }

  void clear() {
    _cart = [];
    _counter = 0;
    _totalPrice = 0.0;
    notifyListeners();
  }

}