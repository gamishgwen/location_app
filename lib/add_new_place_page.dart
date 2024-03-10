import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:location/location.dart';
import 'package:location_app/places.dart';
import 'package:provider/provider.dart';

import 'location_source.dart';

class AddNewPlace extends StatefulWidget {
  const AddNewPlace({super.key});

  @override
  State<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController placeController = TextEditingController();
  File? chosenImageFile;
  //LocationData? _locationData;
  Position? location;
  String? address;

  void save() {
    if (_formKey.currentState!.validate() &&
        chosenImageFile != null &&
        location != null &&
        address != null) {
      final Place place = Place(
          placeController.text,
          chosenImageFile!,
          LocationData(
              address: address!,
              latitude: location!.latitude,
              longitude: location!.longitude));

      print(place);

      context.read<AllPlaces>().addPlace(place);
    }
  }

  void imageset() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        chosenImageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text('Add new place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: placeController,
                  decoration: InputDecoration(label: Text('Enter place')),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: imageset,
                  child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: chosenImageFile != null
                              ? DecorationImage(
                                  image: FileImage(chosenImageFile!),
                                  fit: BoxFit.fill)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white30)),
                      child: Center(
                        child: chosenImageFile == null
                            ? ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.camera),
                                label: Text('Take Picture'))
                            : null,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: location == null
                      ? Center(child: Text('No location chosen'))
                      : Image.network(
                          "https://maps.googleapis.com/maps/api/staticmap?center=${location!.latitude},${location!.longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:green%7Clabel:A%7C${location!.latitude},${location!.longitude}&key=${LocationSource.apiKey}"),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: () async {
                              bool serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                return;
                              }
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                                if (permission == LocationPermission.denied) {
                                  return;
                                }
                              }

                              if (permission ==
                                  LocationPermission.deniedForever) {
                                return;
                              }

                              final Position updatedLocation =
                                  await Geolocator.getCurrentPosition();

                              setState(() {
                                location = updatedLocation;
                              });

                              address = await LocationSource()
                                  .getAddressFromLatLong(
                                      location!.latitude, location!.longitude);
                            },
                            icon: Icon(Icons.location_on_outlined),
                            label: Text('Get current location'))
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.map),
                            label: Text('select on Map'))
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      save();
                    },
                    child: Text('+Add Place'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//() async {
//                               Location location = Location();
//                               bool _serviceEnabled =
//                                   await location.serviceEnabled();
//                               if (!_serviceEnabled) {
//                                 _serviceEnabled =
//                                     await location.requestService();
//                                 if (!_serviceEnabled) {
//                                   return;
//                                 }
//                               }
//                               PermissionStatus _permissionStatus =
//                                   await location.hasPermission();
//                               if (_permissionStatus ==
//                                   PermissionStatus.denied) {
//                                 _permissionStatus =
//                                     await location.requestPermission();
//                                 if (_permissionStatus !=
//                                     PermissionStatus.granted) {
//                                   return;
//                                 }
//                               }
//
//                               _locationData = await location.getLocation();
//                               print(_locationData);
//                             },
