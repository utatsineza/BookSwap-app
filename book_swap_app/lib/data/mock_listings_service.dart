import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/book.dart';

class MockListingsService {
  final _uuid = const Uuid();
  final List<Book> _books = [];
  final StreamController<List<Book>> _controller = StreamController.broadcast();

  MockListingsService() {
    _books.addAll([
      Book(id: _uuid.v4(), title: 'Algorithms 101', author: 'Cormen', condition: 'Good', ownerId: 'user_1'),
      Book(id: _uuid.v4(), title: 'Intro to ML', author: 'Smith', condition: 'Like New', ownerId: 'user_2'),
      Book(id: _uuid.v4(), title: 'Databases', author: 'Garcia', condition: 'Used', ownerId: 'user_3'),
    ]);
    _emit();
  }

  Stream<List<Book>> streamAllBooks() => _controller.stream;

  Future<void> createBook({required String title, required String author, required String condition, required String ownerId, String? coverImage}) async {
    final book = Book(id: _uuid.v4(), title: title, author: author, condition: condition, ownerId: ownerId, coverUrl: coverImage);
    _books.add(book);
    _emit();
  }

  Future<void> updateBook(Book updated) async {
    final idx = _books.indexWhere((b) => b.id == updated.id);
    if (idx >= 0) {
      _books[idx] = updated;
      _emit();
    }
  }

  Future<void> deleteBook(String id) async {
    _books.removeWhere((b) => b.id == id);
    _emit();
  }

  Future<void> createSwap(String bookId, String requesterId) async {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx >= 0) {
      final b = _books[idx];
      _books[idx] = b.copyWith(swapState: SwapState.pending, swapWithUserId: requesterId);
      _emit();
    }
  }

  Future<void> respondSwap(String bookId, bool accept) async {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx >= 0) {
      final b = _books[idx];
      final newState = accept ? SwapState.accepted : SwapState.rejected;
      _books[idx] = b.copyWith(swapState: newState);
      _emit();
    }
  }

  void _emit() => _controller.add(List.unmodifiable(_books));

  void dispose() {
    _controller.close();
  }
}
