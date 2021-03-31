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
                            trailing: IconButton(
                                icon: Icon(Icons.delete_outline),
                                color: Colors.black,
                                onPressed: () {
                                  deletecategory(doc['id']);
                                }),
                    ),
                  )
                  ).toList(),
                  
              );
            } else {
              return new CircularProgressIndicator();
            }
          }
          ),
    );

  }
  CollectionReference users = Firestore.instance.collection('categories');
  Future<void> deletecategory(String id) {
    return users
        .document(id)
        .delete()
        .then((value) => print("category Deleted"))
        .catchError((error) => print("Failed to delete category: $error"));
  }

}
