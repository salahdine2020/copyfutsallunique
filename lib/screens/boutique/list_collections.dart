import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/NavigationBar.dart';
import 'package:futsal_unique/common_widgets/custom_app_bar.dart';
import 'package:futsal_unique/common_widgets/shopping_bag.dart';
import 'package:futsal_unique/models/category_model.dart';
import 'package:futsal_unique/screens/accueil/accuiel.dart';
import 'package:futsal_unique/screens/boutique/list_products.dart';
///import 'package:futsal_unique/screens/feed_screen_test/feed_screen.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ListCollection extends StatelessWidget {
  const ListCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      // leading: GestureDetector(
      //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyBottomNavigatioBar())),//todo: Get.to(() => MyBottomNavigatioBar()),
      //     child: Icon(LineIcons.times, size: 30, color: Colors.black),
      // ),
        actions: [
          ShopBag()
        ],
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotCategory) {
          if (snapshotCategory.hasError) {
            return Text('Something went wrong');
          }
          if (snapshotCategory.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: TopScreen(context)),
              SizedBox(height: 50,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshotCategory.data!.docs.map((DocumentSnapshot userDoc) {
                    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
                    print('data issss ====== ${data['imageCat']}');
                    Category category = Category(
                      categoryID: data['categoryID'],
                      nameCat: data['nameCat'],
                      imageCat: data['imageCat'],
                    );
                    return ListCards(category, context);
                  }).toList(),
                  /*ListCards("Chaussures de foot", "assets/images/chaussures de foot.jpg"),
                  ListCards("Maillots de foot", "assets/images/maillot_foot.png"),*/

              ),
            ],
          );
        },
      ),
    );
  }

  Widget ListCards(Category category, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListProducts(category: category))),//todo: Get.to(() => ListProducts(category: category)),
      child: Card(
        margin:  const EdgeInsets.all(16.0),
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.grey[200],
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(category.nameCat.toString().toUpperCase(), style: KLatoTextStyleText,)),
              Expanded(child: Image.network(category.imageCat.toString(), width: 150, height: 150,))
            ],
          ),
        ),
      ),
    );
  }

  Widget TopScreen(context) {
    return RichText(
      text: TextSpan(
        text: 'Nos\n'.toUpperCase(),
        style: GoogleFonts.graduate(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: kWhiteColorBlackOpacity,
        ),
        //textStyle.copyWith(color: Theme.of(context).primaryColorDark),
        children: <TextSpan>[
          TextSpan(
            text: 'Collections'.toUpperCase(),
            style: GoogleFonts.graduate(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: kWhiteColorBlackOpacity,
            ),
          ),
        ],
      ),
    );
  }
}
