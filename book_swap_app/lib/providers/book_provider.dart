import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Book> _books = [];
  List<Book> get books => _books;
  bool isLoading = false;

  Future<void> loadAllBooks() async {
    isLoading = true;
    notifyListeners();
    final snapshot = await _db.collection('books').get();
    _books = snapshot.docs.map((d) => Book.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserBooks(String userId) async {
    isLoading = true;
    notifyListeners();
    final snapshot = await _db.collection('books').where('ownerId', isEqualTo: userId).get();
    _books = snapshot.docs.map((d) => Book.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBook(String id) async {
    await _db.collection('books').doc(id).delete();
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
