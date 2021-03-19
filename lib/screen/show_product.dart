import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodadmin/model/product.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  ProductService _productService = ProductService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("product list"),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: _productService.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data;
              return ListView(
                  children: documents.map((doc) => Card(
                            child: ListTile(
                              title: Text(doc['name']),
                            ),
                          )).toList());
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
