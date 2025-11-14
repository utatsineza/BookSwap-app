import 'package:cloud_firestore/cloud_firestore.dart';


// Swap between two users for a book
class Swap {
  final String id;
  final String bookId;
  final String senderId;    // who initiates swap
  final String recipientId; // owner of the book
  final String status;      // Pending, Accepted, Rejected
  final DateTime createdAt;

  Swap({
    required this.id,
    required this.bookId,
    required this.senderId,
    required this.recipientId,
    required this.status,
    required this.createdAt,
  });

  factory Swap.fromMap(Map<String, dynamic> map) {
    return Swap(
      id: map['id'],
      bookId: map['bookId'],
      senderId: map['senderId'],
      recipientId: map['recipientId'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'senderId': senderId,
      'recipientId': recipientId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
