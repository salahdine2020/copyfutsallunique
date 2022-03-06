import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsal_unique/models/chat_params.dart';
import 'package:futsal_unique/screens/chat/chat_screen.dart';
import 'package:futsal_unique/screens/contact_screen/chat_screen.dart';
import 'package:futsal_unique/screens/contact_screen/contact_screen.dart';
import 'package:futsal_unique/screens/login/login.dart';
import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';

class LoginOrChat extends StatelessWidget {
  const LoginOrChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            print("les donne stocke est : ${userSnapshot.data} et les donne existe : ${userSnapshot.hasData}");
            User? data = userSnapshot.data as User?;
            print("*****************************");
            print(data!.uid);
            //RouteSettings? settings;
            //var arguments = settings!.arguments;
            if (userSnapshot.hasData) {
              ///return ChatScreen();
              ///return Login();
              //todo: go into contact page
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: '',
                initialRoute: '/',
                onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings, uid: data!.uid),
              );
              // return ChatScreen(chatParams: arguments as ChatParams);
              // return ContactPage();
              // return ProfileScreen(
              //   userId: data!.uid,
              //   currentUserId: data!.uid,
              //   onProfileEdited: ()=> print("onProfileEdited"),
              //   isCameFromBottomNavigation: true,
              //   goToCameraScreen: ()=> print("goToCameraScreen"),
              // );
            }
            return Login();
          },
        ),
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings, {String? uid}) {
    print('settings.name is : ${settings.name} and arguments is : ${settings.arguments}');
    switch (settings.name) {
    // TODO: call item sound function
      case '/':
        var arguments = settings.arguments;
        ChatParams chatParams = ChatParams(uid!, 'sav_id');
        if (chatParams != null) { //todo: arguments
          print('user ID is : $uid');
          return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(chatParams: chatParams), //todo: arguments as ChatParams
              //ChatScreen(chatParams: arguments as ChatParams),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                animation = CurvedAnimation(curve: Curves.ease, parent: animation);
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
          );
        }
        else {
          return pageNotFound();
        }
        break;
      default:return pageNotFound();
    }
  }

  static MaterialPageRoute pageNotFound() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text("Error"), centerTitle: true),
        body: Center(
          child: Text("Page not found"),
        ),
      ),
    );
  }
}
