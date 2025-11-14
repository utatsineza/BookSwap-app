// lib/models/book.dart

class Book {
  final String id;
  final String title;
  final String author;
  final String condition;
  final String? coverUrl; // optional
  final String ownerId; // must be initialized

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    this.coverUrl,
    required this.ownerId,
  });

  // Factory constructor to create a Book from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      condition: json['condition'] as String,
      coverUrl: json['coverUrl'] as String?,
      ownerId: json['ownerId'] as String,
    );
  }

  // Convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'condition': condition,
      'coverUrl': coverUrl,
      'ownerId': ownerId,
    };
  }
}
