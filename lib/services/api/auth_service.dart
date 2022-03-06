import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';
import 'package:futsal_unique/services/sharedprefs/loginid_shared.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:futsal_unique/models/models.dart';

class AuthService {
  static final FirebaseAuth? _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users01');

  static Future<String> signUpUser(
    BuildContext context,
    String name,
    String email,
    String password, {
    bool? isBanned,
    String? bio,
    String? profileImageUrl,
    bool? isVerified,
    String? website,
    String? role,
  }) async {
    print("signUpUser Function()");
    try {
      //todo: search how to do as AuthResult type
      var authResult = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //todo: search how to add as FirebaseUser
      var signedInUser = authResult.user;
      if (signedInUser != null) {
        String? token = await _messaging.getToken();
        print("user uid is : ${signedInUser.uid}");

        /// a la place de users
        /// _firestore.collection(usersRef).doc(signedInUser.uid).set({
        _firestore.collection("users01").doc(signedInUser.uid).set({
          'name': name ?? '',
          'email': email,
          'profileImageUrl': '',
          'token': token,
          'isVerified': false,
          'role': 'user',
          'timeCreated': Timestamp.now(),
          'bio': bio ?? 'bio',
          'isBanned': isBanned ?? true,
          'id': signedInUser.uid,
          'isVerified': isVerified ?? false,
          'website': website ?? 'https://www.google.dz/?hl=ar',
          'role': role ?? 'user',
        });
        await SaveValuesEtapes().savevalueid1(signedInUser.uid);
      }
      Provider.of<UserData>(context, listen: false).currentUserId = signedInUser!.uid;
      Navigator.pop(context);
      return signedInUser.uid;
    } on PlatformException catch (err) {
      ///Get.snackbar('Problème survenu', err.message.toString(), backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      throw (err);
    }
  }

  static Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      var authResult = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var signedInUser = authResult.user;
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      var authResult = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      var signedInUser = authResult.user;
      await SaveValuesEtapes().savevalueid1(signedInUser!.uid);
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<void> removeToken() async {
    final currentUser = await _auth!.currentUser;
    await usersRef
        .doc(currentUser!.uid)
        .set({'token': ''}, SetOptions(merge: true));
  }

  static Future<void> updateToken() async {
    final currentUser = await _auth!.currentUser;
    final token = await _messaging.getToken();
    final userDoc = await usersRef.doc(currentUser!.uid).get();
    if (userDoc.exists) {
      UserModelClass user = UserModelClass.fromDoc(userDoc);
      if (token != user.token) {
        usersRef
            .doc(currentUser.uid)
            .set({'token': token}, SetOptions(merge: true));
      }
    }
  }

  static Future<void> updateTokenWithUser(var user) async {
    //todo: type of user is : User
    final token = await _messaging.getToken();
    if (token != user.token) {
      await usersRef.doc(user.id).update({'token': token});
    }
  }

  static Future<void> logout() async {
    await removeToken();
    Future.wait([
      _auth!.signOut(),
    ]);
  }
}
