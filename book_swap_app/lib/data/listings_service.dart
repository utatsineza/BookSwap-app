import 'dart:async';
import '../models/book.dart';

class ListingsService {
  // Internal "database" of books
  final List<Book> _books = [];

  // Stream controller to broadcast changes
  final StreamController<List<Book>> _booksController =
      StreamController<List<Book>>.broadcast();

  ListingsService() {
    // Optional: pre-populate with some dummy books
    _books.addAll([
      Book(
        id: '1',
        title: 'Flutter for Beginners',
        author: 'John Doe',
        condition: 'New',
        coverImage:
            'https://flutter.dev/images/catalog-widget-placeholder.png',
        ownerId: 'owner1',
      ),
      Book(
        id: '2',
        title: 'Dart in Action',
        author: 'Jane Smith',
        condition: 'Used',
        coverImage:
            'https://flutter.dev/images/catalog-widget-placeholder.png',
        ownerId: 'owner2',
      ),
    ]);

    // Emit initial data
    _booksController.add(List.unmodifiable(_books));
  }

  // Stream all books
  Stream<List<Book>> streamAllBooks() {
    return _booksController.stream;
  }

  // Create a new book listing
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

    // Notify listeners
    _booksController.add(List.unmodifiable(_books));
  }

  // Dispose the stream controller
  void dispose() {
    _booksController.close();
  }
}
