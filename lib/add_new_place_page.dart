import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_app/map_page.dart';
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
  LocationData? _locationData;

  void myLocation(double latitude, double longitude) async {
    String address =
        await LocationSource().getAddressFromLatLong(latitude, longitude);
    setState(() {
      _locationData = LocationData(
          latitude: latitude, longitude: longitude, address: address);
    });
  }

  void save() {
    if (_formKey.currentState!.validate() &&
        chosenImageFile != null &&
        _locationData != null) {
      final Place place = Place(
          placeController.text,
          chosenImageFile!,
          LocationData(
              address: _locationData!.address,
              latitude: _locationData!.latitude,
              longitude: _locationData!.longitude));

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
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Add new place'),
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
                  decoration: const InputDecoration(label: Text('Enter place')),
                ),
                const SizedBox(
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
                                icon: const Icon(Icons.camera),
                                label: const Text('Take Picture'))
                            : null,
                      )),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: _locationData == null
                      ? const Center(child: Text('No location chosen'))
                      : Image.network(
                          "https://maps.googleapis.com/maps/api/staticmap?center=${_locationData!.latitude},${_locationData!.longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:green%7Clabel:A%7C${_locationData!.latitude},${_locationData!.longitude}&key=${LocationSource.apiKey}"),
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
                              String address = await LocationSource()
                                  .getAddressFromLatLong(
                                      updatedLocation.latitude,
                                      updatedLocation.longitude);
                              setState(() {
                                _locationData = LocationData(
                                    latitude: updatedLocation.latitude,
                                    longitude: updatedLocation.longitude,
                                    address: address);
                              });
                            },
                            icon: const Icon(Icons.location_on_outlined),
                            label: const Text('Get current location'))
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return MapPage(
                                      latitude:
                                          _locationData?.latitude ?? 40.7142484,
                                      longitude: _locationData?.longitude ??
                                          -73.9614103,
                                      myLocation: myLocation);
                                },
                              ));
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('select on Map'))
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: save,
                    child: const Text('+Add Place'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}