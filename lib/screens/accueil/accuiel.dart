import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/OutlinedButtonWidget.dart';
import 'package:futsal_unique/common_widgets/icon_style.dart';
import 'package:futsal_unique/common_widgets/instaDart_richText.dart';
import 'package:futsal_unique/models/booking_model.dart';
import 'package:futsal_unique/models/salle_model.dart';
import 'package:futsal_unique/screens/login/login.dart';
import 'package:futsal_unique/screens/login/login_or_chat.dart';
import 'package:futsal_unique/screens/reservation/reservation.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccuileApp extends StatelessWidget {
  AccuileApp({Key? key}) : super(key: key);
  //todo: final Function changeWidget;
  final salles = FirebaseFirestore.instance.collection("salles");
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListView(children: [
      Container(
        padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bienvenue sur notre", style: GoogleFonts.lato(textStyle: subTitleStyle)),
              ],
            ),
            SizedBox(
              height: 13.0,
            ),
            Divider(
              thickness: 3.0,
              color: colorButton,
              endIndent: 300.0,
            ),
            Row(
              children: [
                InstaDartRichText(kBillabongFamilyTextStyle.copyWith(fontSize: 50.0)),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/icons8-stadium-48.png",
                          width: iconWidth,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "2 Salles intérieures",
                          style: GoogleFonts.lato(textStyle: textStyleWithIcons),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/icons8-pavilion-48.png",
                          width: iconWidth,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "3 Salles extérieures",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(textStyle: textStyleWithIcons),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconStyle(Icons.location_on_outlined),
                    SizedBox(width: 10.0),
                    Text(
                      "15000, Rue 10 ville x",
                      style: GoogleFonts.lato(textStyle: textStyleWithIcons),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('sous_salles').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  return SalleCard(document, width);
                }).toList(),
              );
            }
          })
    ]);
  }

  Widget SalleCard(QueryDocumentSnapshot document, double width) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          clipBehavior: Clip.antiAlias,
          shadowColor: Colors.grey[200],
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            //alignment: Alignment.center,
            children: [
              Ink.image(
                image: NetworkImage(document['images'][0] ?? 'https://cdn0.iconfinder.com/data/icons/allicons-part-6/57/stadium-512.png'),
                height: 240,
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    print('Item Tapped');
                  },
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: width,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      //borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(document['name'], style: KGraduateTextStyleTitle),
                            Text(
                              document['type'],
                              style: KLatoTextStyleText,
                            )
                          ],
                        ),
                        //SizedBox(width: 70.0),
                        Text(document['playersNb'] + " vs " + document['playersNb'], style: KLatoTextStyleText),
                        //SizedBox(width: 70.0),
                        Row(
                          children: [Image.asset("assets/icons/icons8-price-50.png", width: 25), Text(document['price'] + "€", style: KGraduateTextStyleTitle)],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButtonWidget(text: 'Réserver', screen: Reservation(document: document)),
              // OutlinedButtonWidget(text: 'Contacter', screen: Login())
              OutlinedButtonWidget(text: 'Contacter', screen: LoginOrChat()), //todo: fct: changeWidget
            ],
          ),
        ),
      ],
    );
  }
}
