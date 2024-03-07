import 'package:flutter/material.dart';
import 'package:location_app/places.dart';
import 'package:location_app/places_source.dart';
import 'package:provider/provider.dart';

class AddNewPlace extends StatefulWidget {
  const AddNewPlace({super.key});

  @override
  State<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String _enteredPlace='';

void save(){
  if(_formKey.currentState!.validate()){
    _formKey.currentState!.save();

    PlaceSource source = PlaceSource();
    final Place place=Place(_enteredPlace);
   source.postAllPlaces(place);
  }
}
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
        title: Text('Add new place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text('Enter place')),
                onSaved: (newValue) {
                  _enteredPlace=newValue!;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: () {
                save();
              }, child: Text('+Add Place'))
            ],
          ),
        ),
      ),
    );
  }
}
