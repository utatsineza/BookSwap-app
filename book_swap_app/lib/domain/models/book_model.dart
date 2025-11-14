import 'package:cloud_firestore/cloud_firestore.dart';


// lib/domain/models/book_model.dart
class Book {
  final String id;
  final String title;
  final String author;
  final String condition; // New, Like New, Good, Used
  final String? coverUrl;
  final String ownerId; // uid of creator
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    this.coverUrl,
    required this.ownerId,
    required this.createdAt,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      condition: map['condition'],
      coverUrl: map['coverUrl'],
      ownerId: map['ownerId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'condition': condition,
      'coverUrl': coverUrl,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }
}
