class Swap {
  final String id;
  final String bookId;
  final String ownerId;
  final String recipientId;
  final String status;

  Swap({
    required this.id,
    required this.bookId,
    required this.ownerId,
    required this.recipientId,
    required this.status,
  });

  factory Swap.fromJson(Map<String, dynamic> json) => Swap(
        id: json['id'],
        bookId: json['bookId'],
        ownerId: json['ownerId'],
        recipientId: json['recipientId'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'ownerId': ownerId,
        'recipientId': recipientId,
        'status': status,
      };
}
