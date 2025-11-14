import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllBooks() {
    return _fs.collection('books')
      .orderBy('createdAt', descending: true)
      .snapshots();
  }

  Future<void> createBook(Map<String, dynamic> data) async {
    final doc = _fs.collection('books').doc();
    data['id'] = doc.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    await doc.set(data);
  }

  Future<void> updateBook(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _fs.collection('books').doc(id).update(data);
  }

  Future<void> deleteBook(String id) async {
    await _fs.collection('books').doc(id).delete();
  }
}
