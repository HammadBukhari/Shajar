import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class MapProvider with ChangeNotifier {
  Position position;
  Future<void> getLocation() async{
      position = 
      await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      
  }
}
