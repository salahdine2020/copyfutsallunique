import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/screens/reservation/recap_reservation.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future<void> StoreBookingData(document, context, String date, String heure) async {
  try{
    final CollectionReference collBooking = FirebaseFirestore.instance.collection("booking");
    final newDocId = collBooking.doc().id;

    Map<String, dynamic> bookingInfo = {
      'bookingID': newDocId,
      'userId': '',
      'salle': document['docID'],
      'heure': Booking.horaire,
      'date': Booking.date,
      'done': false
    };

    collBooking.where('userId', isEqualTo: bookingInfo['userId']).where('salle', isEqualTo: bookingInfo['salle'])
        .where('heure', isEqualTo: bookingInfo['heure']).where('date', isEqualTo: bookingInfo['date'])
        .get().then((value) {
          if(value.docs.isNotEmpty){
            //existe déjà
            print('already exists');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vous avez déjà réservé cette salle')));
          } else {
            collBooking.doc(bookingInfo['bookingID']).set(bookingInfo).then((value) => print('Booking stored successfuly'));

            Get.to(() => RecapReservation(document: document, date: date, heure: heure));
          }
    });


  } catch(e) {
    print(e);
  }

}

getDispoTimes(String? date) async {
  final bookingRef = FirebaseFirestore.instance.collection('booking').where('date', isEqualTo: date);
  final snapshotBooking = await bookingRef.get();
  List<String?> heures = [];
  List<bool> booleen = [];

  snapshotBooking.docs.forEach((doc) {
    heures.add(doc.data()['heure']);
  });

  DateTime now = DateTime.now();
  String formattedTime = DateFormat.Hm().format(now);
  String nowFormatted = DateFormat('dd-MM-yyyy').format(now);

  TIME_SLOT.forEach((ts) {
    final heure = heures.firstWhere((h) => (h == ts), orElse: () => null);
    final hour = int.parse(ts.split(':')[0].substring(0, 2));
    final t = int.parse(formattedTime.split(':')[0].substring(0, 2));

    (heure != null || (hour < t && nowFormatted == date))? booleen.add(false) : booleen.add(true) ;
  });
  return booleen;
}