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
          listenable: context.read<AllPlaces>(),
          builder: (context, child) => ListView.builder(
            itemCount: context.read<AllPlaces>().places.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                  backgroundImage:
                      FileImage(context.read<AllPlaces>().places[index].file)),
              title: Text(context.read<AllPlaces>().places[index].placeName),
              subtitle: Text(
                  context.read<AllPlaces>().places[index].location.address),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return PlacePage(
                        place: context.read<AllPlaces>().places[index]);
                  },
                ));
              },
            ),
          ),
        ));
  }
}
