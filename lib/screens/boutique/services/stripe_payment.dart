
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
import 'package:futsal_unique/screens/boutique/services/store_cart.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic>? paymentIntentDataOrder;
Future<void> makePaymentOrder(cart, String price, context, CartProvider cartProvider) async {
  try {
    print('res === ${price}');
    paymentIntentDataOrder =
    await createPaymentIntent(price.toString(), 'EUR');

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentDataOrder!['client_secret'],
            applePay: true,
            googlePay: true,
            testEnv: true,
            style: ThemeMode.dark,
            primaryButtonColor: colorButton,
            merchantCountryCode: 'US',
            merchantDisplayName: 'FUTSAL')).then((value){
    });

    ///now finally display payment sheeet
    displayPaymentSheet(cart, price, context, cartProvider);
  } catch (e, s) {
    print('exception:$e $s');
  }
}

displayPaymentSheet(cart, String price, context, cartProvider) async {

  try {
    double totalPrice = double.parse(price) / 100;
    await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentDataOrder!['client_secret'],
          confirmPayment: true,
        )).then((newValue){


      print('payment intent'+paymentIntentDataOrder!['id'].toString());
      print('payment intent'+paymentIntentDataOrder!['client_secret'].toString());
      print('payment intent'+paymentIntentDataOrder!['amount'].toString());
      print('payment intent'+paymentIntentDataOrder.toString());

      StoreOrder(cart, totalPrice, context);
      cartProvider.clear();
      paymentIntentDataOrder = null;

    }).onError((error, stackTrace){
      print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
    });


  } on StripeException catch (e) {
    print('Exception/DISPLAYPAYMENTSHEET==> $e');
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Paiement Echoué"),
        ));
  } catch (e) {
    print('$e');
  }
}

createPaymentIntent(String price, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': price,
      'currency': currency,
      'payment_method_types[]': 'card'
    };
    print(body);
    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
          'Bearer sk_test_51KGiusCLfjhlLMobZK4ACuepejgWVqTQmY6PstSvPIgYbH8xJsK5JFldrb8UpYRc1xtZswWNSX5ALDyYUm0cALCv00AEBh5yIQ',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    print('Create Intent reponse ===> ${response.body.toString()}');
    return jsonDecode(response.body);
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
}

calculateAmount(String amount) {
  final a =(int.parse(amount)) * 100 ;
  return a.toString();
}
