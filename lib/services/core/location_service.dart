import 'package:flutter/services.dart';
//todo: import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart'as l;
import 'package:geocoding/geocoding.dart';

class LocationService {
  //todo: Address
  static Future<dynamic> getUserLocation() async {
    l.LocationData? currentLocation;
    String error;
    l.Location location = l.Location();
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      currentLocation = null;
    }
    ///final coordinates = Coordinates(currentLocation!.latitude, currentLocation!.longitude);
    ///var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
    ///var first = addresses.first;
    return placemarks;///first;
  }
}
