import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/NavigationBar.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class RecapReservation extends StatelessWidget {
  final QueryDocumentSnapshot document;
  final date, heure;
  const RecapReservation({Key? key, required this.document, required this.date, required this.heure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton(
          onPressed: () => Get.to(() => MyBottomNavigatioBar()),
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            textStyle: KLatoTextStyleText,
            side: BorderSide(width:2.0, color: colorButton),
            backgroundColor: colorButton,
            fixedSize: Size(50, 50)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(LineIcons.undo, color: Colors.white,size: 30),
            ],
          ),
        ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top:35.0, left: 16.0, right: 16.0),
              child: Icon(LineIcons.checkCircle, size: 70, color: colorButton,)),
          SizedBox(height: 20.0),
          Text("Réservation Terminée !", style: KGraduateTextStyleTitle, textAlign: TextAlign.center,),
          SizedBox(height: 20.0),
          Card(
            margin:  const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            shadowColor: Colors.grey[200],
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nom de la salle", style: KLatoTextStyleText,),
                      Text(document['name'], style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type de la salle", style: KLatoTextStyleText,),
                      Text(document['type'], style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date du match", style: KLatoTextStyleText,),
                      Text(date.toString(), style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Créneau du match", style: KLatoTextStyleText,),
                      Text(heure.toString(), style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Etat", style: KLatoTextStyleText,),
                      Text("Réservé", style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
                Divider(thickness: 2.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prix", style: KLatoTextStyleText,),
                      Text(document['price'] + "€/heure", style: KGraduateTextStyleTitle,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
