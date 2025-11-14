// book_model.dart
class Book {
  final String id;
  final String title;
  final String author;
  final String condition;
  final String coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.coverUrl,
  });

  factory Book.fromMap(Map<String, dynamic> data, String docId) {
    return Book(
      id: docId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      condition: data['condition'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
    );
  }
}
