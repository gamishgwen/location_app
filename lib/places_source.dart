import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location_app/places.dart';

class PlaceSource{
  Future<List<Place>> getAllPlaces() async{
    final url = Uri.https(
        'shopping-abd06-default-rtdb.asia-southeast1.firebasedatabase.app', 'place-list.json');
    final http.Response response = await http.get(url);
    Map<String, dynamic> map = jsonDecode((response.body));
    List<Place> places= map.entries.map((placeValue) => Place.fromJson(placeValue.value)).toList();
    return places;
  }

  Future<void> postAllPlaces(Place places) async{
    final url = Uri.https(
        'shopping-abd06-default-rtdb.asia-southeast1.firebasedatabase.app', 'place-list.json');
    final http.Response response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(places.toJson()));
  }
}
