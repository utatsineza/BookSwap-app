import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_swap_app/domain/models/book_model.dart';

class BookRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Book>> fetchAllBooks() async {
    final snapshot = await firestore.collection('books').get();
    return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Book>> fetchUserBooks(String userId) async {
    final snapshot = await firestore.collection('books').where('ownerId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
  }
}
