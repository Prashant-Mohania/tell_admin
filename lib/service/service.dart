import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addCategory(String category) {
    return _firestore.collection("category").add({
      "category": category,
    });
  }

  static Future<void> addUrlFeed(String url, String category) {
    return _firestore.collection("feeds").add({
      "url": url,
      "category": category,
    });
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> fetchCategorys() {
    return _firestore.collection("category").get();
  }
}
