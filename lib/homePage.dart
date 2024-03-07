import 'package:flutter/material.dart';
import 'package:location_app/add_new_place_page.dart';
import 'package:location_app/place_page.dart';
import 'package:location_app/places.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AddNewPlace();
                    },
                  ));
                },
                icon: Icon(Icons.add)),
          ],
          centerTitle: false,
          title: Text('Your Places'),
        ),
        body: ListenableBuilder(
          listenable:context.read<AllPlaces>(),
          builder:(context, child) => Column(
            children: [
             // for(int i=0; i<context.read<AllPlaces>().places.length;i++)
                for( Place place in context.read<AllPlaces>().places)
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return PlacePage(place: place,);
                      },
                    ));
                  },
                  child: Text(place.placeName)),

            ],
          ),
        ));
  }
}
