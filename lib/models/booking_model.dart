import 'package:flutter/material.dart';
import 'package:futsal_unique/models/salle_model.dart';

class Booking with ChangeNotifier{
  static Salle? salle;
  static String? horaire;
  static String? date;

  Booking();

}