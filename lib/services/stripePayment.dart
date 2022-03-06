
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/screens/reservation/services/store_booking.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:http/http.dart' as http;

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(document, price, context) async {
    try {

      paymentIntentData =
      await createPaymentIntent(price, 'EUR');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.dark,
              primaryButtonColor: colorButton,
              merchantCountryCode: 'US',
              merchantDisplayName: 'FUTSAL')).then((value){
      });

      ///now finally display payment sheeet
      displayPaymentSheet(document, context);
    } catch (e, s) {
      print('exception:$e $s');
    }
  }

  displayPaymentSheet(document, context) async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());

        final date = Booking.date;
        final heure = Booking.horaire;

        //save booking data in database
        StoreBookingData(document, context, date!, heure!);
        paymentIntentData = null;
        Booking.salle = null;
        Booking.date = null;
        Booking.horaire = null;

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

  createPaymentIntent(price, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(price),
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
    final a = (int.parse(amount)) * 100 ;
    return a.toString();
  }
