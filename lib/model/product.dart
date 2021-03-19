import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';

  void uploadProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String productId = id.v1();
    data["id"] = productId;
    _firestore.collection(ref).document(productId).setData(data);
  }

  Future<List<DocumentSnapshot>> getProducts() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        print(snaps.documents.length);
        return snaps.documents;
      });
  Future<int> productcount() => _firestore.collection(ref).getDocuments().then((snaps){
    return snaps.documents.length;
  });

}