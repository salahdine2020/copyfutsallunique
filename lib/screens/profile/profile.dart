import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          return Center(
            child: TextButton(
              child: Text("Log out"),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          );
        }
        return Center(child: Text("You are logged out"));
      },
    );
  }
}
