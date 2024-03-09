import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_app/places.dart';
import 'package:provider/provider.dart';

class AddNewPlace extends StatefulWidget {
  const AddNewPlace({super.key});

  @override
  State<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController placeController = TextEditingController();
  File? chosenImageFile;

  void save() {
    if (_formKey.currentState!.validate() && chosenImageFile != null) {
      final Place place = Place(placeController.text, chosenImageFile!);
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
                  child: Center(child: Text('No location chosen')),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: () {},
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
