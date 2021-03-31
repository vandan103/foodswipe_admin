import 'package:cloud_firestore/cloud_firestore.dart';

class Users{

  Firestore _firestore=Firestore.instance;
  String ref="users";

  Future<int> usercount() =>
    _firestore.collection(ref).getDocuments().then( (value)  {
      return value.documents.length;
    }
    );


}