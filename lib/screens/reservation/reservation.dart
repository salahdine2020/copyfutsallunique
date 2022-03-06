import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/models/salle_model.dart';
import 'package:futsal_unique/screens/reservation/recap_reservation.dart';
import 'package:futsal_unique/screens/reservation/services/store_booking.dart';
import 'package:futsal_unique/screens/reservation/widgets/calendar.dart';
import 'package:futsal_unique/services/stripePayment.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class Reservation extends StatefulWidget {
  final QueryDocumentSnapshot document;
  const Reservation({Key? key, required this.document}) : super(key: key);

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  String? _date;


  void _update(String? date) {
    setState(() => _date = date);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorButton,
      floatingActionButton: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 100,
        child: IgnorePointer(
            ignoring: (Booking.date == null || Booking.horaire == null)
            ? true
            : false,
          child: OutlinedButton(
            onPressed: () async{
              await makePayment(widget.document, widget.document['price'], context);
            },
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              textStyle: KLatoTextStyleText,
              side: BorderSide(width:2.0, color: colorButton),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Paiement".toUpperCase(), style: KLatoTextStylePaiementButton),
                Text(widget.document['price'].toString() + " €/Heure", style: KGraduatePaiementButtonPriceStyle,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Nouvelle Réservation", style: KGraduateTextStyleTitle,),
        centerTitle: true,
        backgroundColor: colorButton,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Container(
              height: 150,
              child: topOfScreen(widget.document['name'], widget.document['price'], widget.document['playersNb'])),
          Container(
            padding: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ListView(
              padding: EdgeInsets.only(top: 30.0),
              children: [
                Text("Date Du Match", style: KGraduateTextStyleTitle,),
                SizedBox(height: 25.0),
                Calendar(update: _update),
                SizedBox(height: 80.0),
                Text("Créneau Du Match", style: KGraduateTextStyleTitle,),
                SizedBox(height: 25.0),
                Container(
                  height: 60,
                  child: FutureBuilder(
                    future: getDispoTimes(Booking.date),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else {
                        var lisTimeSlot = snapshot.data as List<bool>;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 20);
                          },
                          itemCount: TIME_SLOT.length,
                          itemBuilder: (BuildContext context, int index){
                            return Creneau(context, TIME_SLOT.elementAt(index), widget.document, index, lisTimeSlot);
                          },
                        );
                      }
                    },
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Creneau(ctx, String horaire, document, int index, List<bool> lisTimeSlot){
    return InkWell(
      onTap: (lisTimeSlot[index] == false)
          ? null
        : () {
        setState(() {
        Booking.salle = Salle(docID: document['docID'], images: document['images'],
            name: document['name'], playersNB: document['playersNb'],
            price: document['price'], type: document['type'], parentId: document['parentId']);
        Booking.horaire = horaire;
        print('tapped widget ${Booking.date} -- ${Booking.salle?.name} -- ${Booking.horaire}');
        });
      },
      child: Container(
        //margin: EdgeInsets.only(left: 20),
        width: MediaQuery.of(ctx).size.width/4,
        decoration: BoxDecoration(
          color: (lisTimeSlot[index] == false && Booking.date != null) ? Colors.grey[400] :
          (horaire == Booking.horaire)? colorButton : Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      horaire,
                      style: (horaire != Booking.horaire || lisTimeSlot[index] == false)? textStyleWithIcons : textStyleWithIcons.copyWith(color: Colors.white),
                    ),
                    (Booking.date == null)
                        ? Text('')
                        : Text((lisTimeSlot[index] == false)
                        ? 'Réservée'
                      : 'Disponible', style: (horaire != Booking.horaire || lisTimeSlot[index] == false)? textStyleWithIcons : textStyleWithIcons.copyWith(color: Colors.white),)
                  ],
                ),
            ),
      ),
    );
  }

  Widget topOfScreen(String salle_name, String price, String nb_players){
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/logoappicon.png'), fit: BoxFit.contain)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(salle_name, style: KGraduateTextStyleTitle,),
              //Divider(),
              Text("Nombre de joueurs " + nb_players.toString() + " vs " + nb_players.toString(), style: KLatoTextStyleText,)
            ],
          ),
          Row(
            children: [
              Icon(LineIcons.euroSign),
              Text(price.toString() + "/Heure", style: KGraduateTextStyleTitle,),
            ],
          )
        ],
      ),
    );
    // );
  }
}

