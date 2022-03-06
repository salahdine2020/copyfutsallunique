import 'package:flutter/material.dart';
import 'package:futsal_unique/screens/accueil/accuiel.dart';
import 'package:futsal_unique/screens/boutique/list_collections.dart';
///import 'package:futsal_unique/screens/feed_screen_test/feed_screen.dart';
import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';
//todo: import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';
import 'package:futsal_unique/screens/login/login_middle_page.dart';
import 'package:futsal_unique/screens/profile/profile.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/services/sharedprefs/loginid_shared.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBottomNavigatioBar extends StatefulWidget {
  final String? currentUserId;
  final String? userId;
  final int? index;
  const MyBottomNavigatioBar({Key? key, this.currentUserId, this.userId, this.index}) : super(key: key);

  @override
  _MyBottomNavigatioBarState createState() => _MyBottomNavigatioBarState();
}

class _MyBottomNavigatioBarState extends State<MyBottomNavigatioBar> {
  late int currentIndex;
  String? iduser;

  getIduser() async {
    var id = await GetValuesEtapes().getvalueid1();
    iduser = id;
  }

  @override
  void initState() {
    // TODO: implement initState
    currentIndex = widget.index ?? 4;
    getIduser();
    super.initState();
  }

  void changeWidget(index) {
    print('current index is $index');
    setState(() => currentIndex = index);
  }


  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    var screens = [
      AccuileApp(),
      FeedScreen(),
      ListCollection(),
      Center(
        child: Text('Messenger'),
      ),
      ///Profile(),
      ProfileScreen(
        currentUserId: iduser,//todo: widget.currentUserId,
        userId: iduser,//todo: widget.userId,
        onProfileEdited: ()=> print("onProfileEdited"),
        isCameFromBottomNavigation: true,
        goToCameraScreen: ()=> print("goToCameraScreen"),
      ),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFf1f5fb),
        selectedItemColor: colorButton,
        unselectedItemColor: Colors.black87,
        currentIndex: currentIndex,
        iconSize: 28,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: false,
        onTap: (index) async {
          if (index == 3) {
            print("but Im here");
            var userOrNull = FirebaseAuth.instance.currentUser;
            print("the user is" + userOrNull.toString());
            if (userOrNull == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginMiddlePage(),
                ),
              ).then((value) {
                if (value != null && value == "connected") {
                  print("the value is " + value);
                  changeWidget(index);
                } else {
                  print("else the value is " + value.toString());
                }
              });
            } else {
              changeWidget(index);
            }
          } else {
            print("I accessed here");
            changeWidget(index);
          }
          print("Im here 11111");
        },
        items: [
          BottomNavigationBarItem(icon: Icon(LineIcons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(LineIcons.newspaper), label: "Actualités"),
          BottomNavigationBarItem(icon: Icon(LineIcons.shoppingBag), label: "Boutique"),
          BottomNavigationBarItem(icon: Icon(LineIcons.facebookMessenger), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(LineIcons.user), label: "Profil"),
        ],
      ),
      //FutsalNavigationBar(currentIndex: currentIndex, screens: screens),
      body: screens.elementAt(currentIndex),
    );
  }
}
