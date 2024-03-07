import 'package:flutter/cupertino.dart';

class Place {
  final String placeName;
  Place(this.placeName);
}

class AllPlaces with ChangeNotifier{
  final List<Place> places=[];
  void addPlace(Place place){
   places.add(place);
   notifyListeners();

  }

}