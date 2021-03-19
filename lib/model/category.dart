import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';

  void uploadCategory(Map<String, dynamic> data) {
    var id = Uuid();
    String categoryId = id.v1();
    data["id"] = categoryId;
    _firestore.collection(ref).document(categoryId).setData(data);
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        print(snaps.documents.length);
        return snaps.documents;
      });

  Future<int> categorycount() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents.length;
      });

}


