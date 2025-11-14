import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'storage_service.dart';
import '../domain/models/book_model.dart';
import 'package:uuid/uuid.dart';

class ListingsService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();

  Stream<List<Book>> streamAllBooks() {
    return _fs.collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
          snap.docs.map((doc) => Book.fromMap(doc.data())).toList()
        );
  }

  Future<void> createBook({
    required String title,
    required String author,
    required String condition,
    File? coverImage,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = _fs.collection('books').doc();
    String? coverUrl;
    if (coverImage != null) {
      coverUrl = await _storage.uploadBookCover(coverImage, doc.id);
    }
    final book = Book(
      id: doc.id,
      title: title,
      author: author,
      condition: condition,
      coverUrl: coverUrl,
      ownerId: uid,
      createdAt: DateTime.now(),
    );
    await doc.set(book.toMap());
  }

  Future<void> updateBook(Book book) async {
    await _fs.collection('books').doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await _fs.collection('books').doc(id).delete();
    await _storage.deleteBookCover(id);
  }
}
