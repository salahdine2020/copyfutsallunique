import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
import 'package:futsal_unique/screens/boutique/cart.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ShopBag extends StatelessWidget {
  const ShopBag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => CartScreen());
            print('cart screen');
          },
          child: Center(
            child: Badge(
              badgeColor: colorButton,
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  //print('cart ==== ${value.getCart()![3].namePrdct}');
                  return Text(value.getCounter().toString(),
                    style: TextStyle(color: Colors.white,),);
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              child: Icon(LineIcons.shoppingBag, color: Colors.black,size: 35,),
            ),
          ),
        ),
        SizedBox(width: 20.0,)
      ],
    );
  }
}
