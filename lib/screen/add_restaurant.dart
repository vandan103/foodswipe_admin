import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodadmin/model/restaurant.dart';
import 'package:image_picker/image_picker.dart';

class AddRestaurant extends StatefulWidget {
  @override
  _AddRestaurantState createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  RestaurantService _restaurantservice = RestaurantService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController ratesController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController popularController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<DocumentSnapshot> restaurants = <DocumentSnapshot>[];
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  File _image1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
        Icons.close,
        color: black, ),
         title: Text(
         "add restaurant",
         style: TextStyle(color: black),
    ),
    ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
              children: <Widget>[
          Row(
          children: <Widget>[
          Expanded(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OutlineButton(
              borderSide: BorderSide(
                  color: grey.withOpacity(0.5), width: 2.5),
              onPressed: () {
                _selectImage(
                    ImagePicker.pickImage(
                        source: ImageSource.gallery),
                    1);
              },
              child: _displayChild1()),
        ),
      ),
      ],
    ),

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text('enter a restaurant name with 10 characters at maximum',textAlign: TextAlign.center,style: TextStyle(color: red, fontSize: 12),
        ),
        ),

        Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
            controller: restaurantNameController,
        decoration: InputDecoration(hintText: 'Restaurant name'),
          validator: (value) {
        if (value.isEmpty) {
          return 'You must enter the restaurant name';
         } else if (value.length > 10) {
          return 'Restaurant name cant have more than 10 letters';
        }
        },
          ),
         ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: popularController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'featured',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must have to enter true or false';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: ratesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'rates',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must have to enter rates';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: ratingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'rating',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must have to enter ratings';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Price',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must enter the price of product';
                      }
                    },
                  ),
                ),
                FlatButton(
                  color: red,
                  textColor: white,
                  child: Text('ADD Restaurant'),
                  onPressed: (){
                    validateAndUpload();
                  },
                ),
       ]
     ),
    )
      ),
    );
  }


  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {

        String imageUrl1;

        final FirebaseStorage storage = FirebaseStorage.instance;

        final String picture1 = "${restaurantNameController.text}.jpg";
        StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image1);

        StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snapshot) => snapshot);


        task1.onComplete.then((snapshot) async {
          imageUrl1 = await snapshot1.ref.getDownloadURL();

          String imageList = imageUrl1;

          _restaurantservice.uploadRestaurant({
            "name":restaurantNameController.text,
            "avgPrice":double.parse(priceController.text),
            "rates":double.parse(ratesController.text),
            "rating":double.parse(ratingController.text),
            "image":imageList,
            "popular":bool.hasEnvironment(popularController.text),
          });
          _formKey.currentState.reset();
          setState(() => isLoading = false);

          Navigator.pop(context);
        });

      }
      else {
        setState(() => isLoading = false);

      }
    }
  }


  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
    }
  }
  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }




}