import 'package:flutter/material.dart';
import 'package:location_app/add_new_place_page.dart';
import 'package:location_app/place_page.dart';
import 'package:location_app/places.dart';
import 'package:location_app/places_source.dart';
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
        body: FutureBuilder(future: PlaceSource().getAllPlaces(),
          builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (snapshot.connectionState==ConnectionState.done){
            return Column(
              children: [

                for( Place place in snapshot.data!)
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
            );}
          return SizedBox();


          },
        ),);
  }
}
