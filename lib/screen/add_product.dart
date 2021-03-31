import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodadmin/model/category.dart';
import 'package:foodadmin/model/product.dart';
import 'package:foodadmin/model/restaurant.dart';
import 'package:image_picker/image_picker.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  RestaurantService _restaurantService = RestaurantService();
  ProductService productService = ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController featuredController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController ratesController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController ridController = TextEditingController();


  List<DocumentSnapshot> restaurants = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> restaurantsDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<bool>> featuredDropDown = <DropdownMenuItem<bool>>[];
  String _currentCategory;
  String _currentRestaurant;


  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  File _image1;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getRestaurants();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data['name']),
                value: categories[i].data['name']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getRestaurantsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < restaurants.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(restaurants[i].data['name']),
                value: restaurants[i].data['name']));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(Icons.close),
            color: black,
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "add product",
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
                child: Text(
                  'enter a product name with 10 characters at maximum',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red, fontSize: 12),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(hintText: 'Product name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 10) {
                      return 'Product name cant have more than 10 letters';
                    }
                  },
                ),
              ),

//              select category
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Category: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Restaurants:',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: restaurantsDropDown,
                    onChanged: changeSelectedRestaurant,
                    value: _currentRestaurant
                  ),
                 ],
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: featuredController,
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
                  controller: desController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'description',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must have to enter the product description';
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
                  controller: ridController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'restaurantid',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must have to enter your restaurant id';
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
                child: Text('add product'),
                onPressed: () {
                  validateAndUpload();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print("length is"  + '($data.length)' );
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data['name'];
    });
  }

  _getRestaurants() async {
    List<DocumentSnapshot> data = await _restaurantService.getRestaurants();
    print("length was" + '($data.length)');
    setState(() {
      restaurants = data;
      restaurantsDropDown = getRestaurantsDropDown();
      _currentRestaurant = restaurants[0].data['name'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedRestaurant(String selectedRestaurant) {
    setState(() => _currentRestaurant = selectedRestaurant);
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




  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {
        if (ridController!= null) {
          String imageUrl1;

          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture1 = "${productNameController.text}.jpg";
          StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image1);

          StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snapshot) => snapshot);


          task1.onComplete.then((snapshot) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();

            String imageList = imageUrl1;

            productService.uploadProduct({
              "name":productNameController.text,
              "price":double.parse(priceController.text),
              "rates":double.parse(ratesController.text),
              "rating":double.parse(ratingController.text),
              "image":imageList,
              "description":desController.text,
              "restaurant":_currentRestaurant,
              "category":_currentCategory,
              "restaurantId":ridController.text,
              "featured":bool.hasEnvironment(featuredController.text),
            });
            _formKey.currentState.reset();
            setState(() => isLoading = false);

            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = false);
        }
      }
      else {
        setState(() => isLoading = false);

      }
    }
  }



}
