// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:futsal_unique/common_widgets/NavigationBar.dart';
// import 'package:futsal_unique/models/booking_model.dart';
// import 'package:futsal_unique/models/cart_model.dart';
// import 'package:futsal_unique/models/product_model.dart';
// import 'package:futsal_unique/providers/cart_provider.dart';
// import 'package:futsal_unique/utilities/constants.dart';
// import 'package:futsal_unique/utilities/themes.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Stripe.publishableKey = 'pk_test_51KGiusCLfjhlLMobJxByzY3V37Qgujh8mYeoEvbpkO1edyr7OpTkbSKNEvrJNFQqnzsfqa6EDgCVoM3MGf0vXLZN00Tu4DCtCU';
//   await Firebase.initializeApp();
//   runApp(
//     MyApp(),
//   );
// }
//
// //class MyApp extends StatelessWidget {
// //  // This widget is the root of your application.
// //  @override
// //  Widget build(BuildContext context) {
// //    return MaterialApp(
// //      title: 'Flutter Demo',
// //      theme: ThemeData(
// //        // This is the theme of your application.
// //        //
// //        // Try running your application with "flutter run". You'll see the
// //        // application has a blue toolbar. Then, without quitting the app, try
// //        // changing the primarySwatch below to Colors.green and then invoke
// //        // "hot reload" (press "r" in the console where you ran "flutter run",
// //        // or simply save your changes to "hot reload" in a Flutter IDE).
// //        // Notice that the counter didn't reset back to zero; the application
// //        // is not restarted.
// //        primarySwatch: Colors.blue,
// //      ),
// //      home:
// //
// ////      SplashScreen(
// ////        seconds: 14,
// ////        navigateAfterSeconds:  AfterSplash(),
// ////        title: Text(
// ////          'Welcome In SplashScreen',
// ////          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
// ////        ),
// ////        image: new Image.network(
// ////            'https://flutter.io/images/catalog-widget-placeholder.png',
// ////            ),
// ////        backgroundColor: Colors.white,
// ////        loaderColor: Colors.red,
// ////      ),
// //    );
// //  }
// //
// //}
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => CartProvider(),
//         ),
//       ],
//       child: FutureBuilder(
//         future: Init.instance.initialize(),
//         builder: (context, AsyncSnapshot snapshot) {
//           // Show splash screen while waiting for app resources to load:
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const GetMaterialApp(debugShowCheckedModeBanner: false, home: Splash());
//           } else {
//             // Loading is done, return the app:
//             return GetMaterialApp(
//               title: 'Flutter Demo',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 primarySwatch: Colors.blue,
//               ),
//               home: const MyBottomNavigatioBar(),
//               //todo: MyHomePage(title: 'Flutter Demo Home Page'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class Splash extends StatelessWidget {
//   const Splash({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     bool lightMode = MediaQuery.of(context).platformBrightness == Brightness.light;
//     return Scaffold(
//       backgroundColor: lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
//       body: Container(
//         color: kWhiteColorWithOpacity,
//         child: Center(
//           child: lightMode ? SplachScreenLightMode() : SplachScreenDarkMode(),
//         ),
//       ),
//     );
//   }
// }
//
// class SplachScreenDarkMode extends StatelessWidget {
//   const SplachScreenDarkMode({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(imagelogo);
//   }
// }
//
// class SplachScreenLightMode extends StatelessWidget {
//   const SplachScreenLightMode({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Spacer(),
//         Image.asset(
//           placeHolderIconLogo,
//           height: 220,
//           width: 220,
//         ),
//         Spacer(),
//         Text(
//           'Made By Taneflit',
//           style: GoogleFonts.lato(),
//         ),
//         Image.asset(
//           imagelogo,
//           height: 120,
//           width: 120,
//         ),
//       ],
//     );
//   }
// }
//
// class Init {
//   Init._();
//   static final instance = Init._();
//
//   Future initialize() async {
//     // This is where you can initialize the resources needed by your app while
//     // the splash screen is displayed.  Remove the following example because
//     // delaying the user experience is a bad design practice!
//     await Future.delayed(const Duration(seconds: 1));
//   }
// }

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
///import 'package:futsal_unique/screens/home_screen/home_screen.dart';
import 'package:futsal_unique/screens/login_signup_screen/login_screen.dart';
import 'package:futsal_unique/screens/login_signup_screen/signup_screen.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/screens/splash_screen/splash_screen.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? false;

    //Set Navigation bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: darkModeOn ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            darkModeOn ? Brightness.light : Brightness.dark,
      ),
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserData>(create: (context) => UserData()),
          ChangeNotifierProvider<ThemeNotifier>(create: (context) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme)),
          ChangeNotifierProvider<CartProvider>(create: (context) => CartProvider(),),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isTimerDone = false;
  CameraController? controller;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
    controller = CameraController(cameras![0], ResolutionPreset.max);
    super.initState();
  }

  Widget _getScreenId() {
    return StreamBuilder<User?>(
      //todo: <FirebaseUser>
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: Text('Loading...'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting || !_isTimerDone) {
          print("you are inside SplashScreen()");
          return SplashScreen();
        }
        if (snapshot.hasData && _isTimerDone) {
          //todo: Provider.of<UserData>(context, listen: false).currentUserId = snapshot.data.uid;
          Provider.of<UserData>(context, listen: false).currentUserId = snapshot.data!.uid!;
          print("you are inside HomeScreen() And UID : ${snapshot.data!.uid!}");
          return HomeScreen(
            currentUserId: snapshot.data!.uid,
            cameras: cameras!,
          );
        } else {
          print("you are inside LoginScreen()");
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'InstaDart',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: _getScreenId(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        FeedScreen.id: (context) => FeedScreen(),
      },
    );
  }
}
