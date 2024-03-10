import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:location_app/map_page.dart';
import 'package:location_app/places.dart';

import 'location_source.dart';

class PlacePage extends StatelessWidget {
  const PlacePage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: false,
          title: Text(place.placeName),
        ),
        body: Stack(
          children: [
            Image.file(place.file,height: double.infinity,fit: BoxFit.fitHeight),
            Positioned(
              bottom: 16,
              right: 0,
              left: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return MapPage(longitude: place.location.longitude,latitude: place.location.latitude);
                    },));
                  },
                    child: CircleAvatar(radius: 80,
                      backgroundImage: NetworkImage(
                          "https://maps.googleapis.com/maps/api/staticmap?center=${place.location.latitude},${place.location.longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:green%7Clabel:A%7C${place.location.latitude},${place.location.longitude}&key=${LocationSource.apiKey}"),
                    ),
                  ),SizedBox(height: 8,),Text(place.location.address,style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ],
        ));
  }
}
