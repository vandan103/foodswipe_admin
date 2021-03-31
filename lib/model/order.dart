import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodadmin/model/ordermodel.dart';

class OrderServices
{
  Firestore _firestore=Firestore.instance;
  String ref="orders";

  Future<int> getorders() =>
    _firestore.collection(ref).getDocuments().then((value){
      return value.documents.length; }
      );

  Future<List<OrderModel>> getUserOrders() async =>
      _firestore
          .collection(ref)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });


}