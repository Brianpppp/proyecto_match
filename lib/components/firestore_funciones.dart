import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<List<Map<String, dynamic>>> getCollection(String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collectionName).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching $collectionName: $e');
      return [];
    }
  }
}
