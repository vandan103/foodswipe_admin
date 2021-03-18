import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class RestaurantService{
  Firestore _firestore = Firestore.instance;
  String ref = 'restaurants';

  void uploadRestaurant(Map<String, dynamic> data){
    var id = Uuid();
    String restaurantId = id.v1();
    data["id"] = restaurantId;
    _firestore.collection(ref).document(restaurantId).setData(data);
  }

  Future<List<DocumentSnapshot>> getRestaurants() => _firestore.collection(ref).getDocuments().then((snaps){
    print(snaps.documents.length);
    return snaps.documents;
  });

// Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
//     _firestore.collection(ref).where('brand', isEqualTo: suggestion).getDocuments().then((snap){
//       return snap.documents;
//     });


}