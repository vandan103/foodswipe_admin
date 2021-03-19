import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodadmin/model/category.dart';
class ShowCategory extends StatefulWidget {
  @override
  _ShowCategoryState createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {

  CategoryService _categoryService = CategoryService();

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("category list"),),
      body:FutureBuilder<List<DocumentSnapshot>>(

          future: _categoryService.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              final List<DocumentSnapshot> documents = snapshot.data;
              return ListView(
                  children: documents.map(
                          (doc) => Card(child: ListTile(
                      title: Text(doc['name']),
                    ),
                  )
                  ).toList());
            } else {
              return new CircularProgressIndicator();
            }
          }
          ),
    );

  }

}
