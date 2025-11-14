import 'package:book_swap_app/data/mock_listings_service.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import 'auth_provider.dart';

class ListingsProvider extends ChangeNotifier {
  final bool useFirebase;
  final AuthProvider auth;
  late MockListingsService _service;
  List<Book> _books = [];

  List<Book> get books => _books;

  ListingsProvider({required this.useFirebase, required this.auth}) {
    _service = MockListingsService();
    _service.streamAllBooks().listen((event) {
      _books = event;
      notifyListeners();
    });
  }

  Future<void> addBook(String title, String author, String condition) async {
    await _service.createBook(title: title, author: author, condition: condition, ownerId: auth.userId ?? 'unknown');
  }

  Future<void> updateBook(Book book) async {
    await _service.updateBook(book);
  }

  Future<void> deleteBook(String id) async {
    await _service.deleteBook(id);
  }

  Future<void> swapBook(String id) async {
    await _service.createSwap(id, auth.userId ?? 'unknown');
  }

  Future<void> respondSwap(String id, bool accept) async {
    await _service.respondSwap(id, accept);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
