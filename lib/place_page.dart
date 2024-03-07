import 'package:flutter/material.dart';
import 'package:location_app/places.dart';

class PlacePage extends StatelessWidget {
  const PlacePage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded),
      ),centerTitle: false,
      title: Text(place.placeName),
    ),body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 300,horizontal: 180),
      child: Text(place.placeName),
    )
    );
  }
}
