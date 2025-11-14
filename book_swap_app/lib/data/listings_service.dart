import 'dart:async';
import '../models/book.dart';

class ListingsService {
  final List<Book> _books = [
    Book(
      id: '1',
      title: '1984',
      author: 'George Orwell',
      condition: 'Good',
      coverImage: '',
      ownerId: 'user_123',
    ),
    Book(
      id: '2',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      condition: 'Fair',
      coverImage: '',
      ownerId: 'user_456',
    ),
    Book(
      id: '3',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      condition: 'Excellent',
      coverImage: '',
      ownerId: 'user_123',
    ),
  ];

  final _controller = StreamController<List<Book>>.broadcast();

  ListingsService() {
    _controller.add(_books);
  }

  Stream<List<Book>> streamAllBooks() => _controller.stream;

  Future<void> createBook({
    required String id,
    required String title,
    required String author,
    required String condition,
    required String coverImage,
    required String ownerId,
  }) async {
    final newBook = Book(
      id: id,
      title: title,
      author: author,
      condition: condition,
      coverImage: coverImage,
      ownerId: ownerId,
    );
    _books.add(newBook);
    _controller.add(_books);
  }
}
