import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodadmin/model/restaurant.dart';

class ShowRestaurants extends StatefulWidget {
  @override
  _ShowRestaurantsState createState() => _ShowRestaurantsState();
}

class _ShowRestaurantsState extends State<ShowRestaurants> {
  RestaurantService _restaurantService = RestaurantService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("restaurant list"),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: _restaurantService.getRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data;
              return ListView(
                children: documents
                    .map((doc) => Card(
                          child: ListTile(
                            title: Text(doc['name']),
                          ),
                        ))
                    .toList(),
              );
            } else {
              return new CircularProgressIndicator();
            }
          }),
    );
  }
}
