import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_app/places.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.place});

  final Place place;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final CameraPosition placePosition= CameraPosition(target: LatLng(widget.place.location.latitude, widget.place.location.longitude),zoom: 14.4746,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(leading:IconButton(onPressed: (){
      Navigator.of(context).pop();
    }, icon: Icon(Icons.arrow_back)),title: Text(widget.place.placeName),),body: GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: placePosition,
      onMapCreated: (GoogleMapController controller) {
        // _controller.complete(controller);
      },
      onTap: (latLang) {

      },
    ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
}
