import 'package:flutter/material.dart';

class Product{
  final String? productID;
  final String? namePrdct;
  final String? pricePrdct;
  String? sizePrdct;
  String? colorPrdct;
  final int? qty;

  Product({
    this.productID, this.namePrdct, this.pricePrdct, this.sizePrdct, this.colorPrdct, this.qty
  });

}