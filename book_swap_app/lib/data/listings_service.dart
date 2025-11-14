import 'dart:async';
import '../models/book.dart';

class ListingsService {
  final List<Book> _books = [];
  final _controller = StreamController<List<Book>>.broadcast();

  Stream<List<Book>> streamAllBooks() => _controller.stream;

  Future<void> createBook({
    required String title,
    required String author,
    required String condition,
    required String coverImage,
    required String ownerId,
  }) async {
    final book = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      author: author,
      condition: condition,
      coverImage: coverImage,
      ownerId: ownerId,
    );
    _books.add(book);
    _controller.add(List<Book>.from(_books));
  }

  void dispose() {
    _controller.close();
  }
}
