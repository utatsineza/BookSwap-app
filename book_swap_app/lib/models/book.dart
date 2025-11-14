enum SwapState { none, pending, accepted, rejected }

class Book {
  final String id;
  final String title;
  final String author;
  final String condition;
  final String ownerId;
  final String? coverUrl;
  final SwapState swapState;
  final String? swapWithUserId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.ownerId,
    this.coverUrl,
    this.swapState = SwapState.none,
    this.swapWithUserId,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? condition,
    String? ownerId,
    String? coverUrl,
    SwapState? swapState,
    String? swapWithUserId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      condition: condition ?? this.condition,
      ownerId: ownerId ?? this.ownerId,
      coverUrl: coverUrl ?? this.coverUrl,
      swapState: swapState ?? this.swapState,
      swapWithUserId: swapWithUserId ?? this.swapWithUserId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'condition': condition,
        'ownerId': ownerId,
        'coverUrl': coverUrl,
        'swapState': swapState.index,
        'swapWithUserId': swapWithUserId,
      };

  factory Book.fromMap(Map<String, dynamic> m) {
    return Book(
      id: m['id'] as String,
      title: m['title'] as String,
      author: m['author'] as String,
      condition: m['condition'] as String,
      ownerId: m['ownerId'] as String,
      coverUrl: m['coverUrl'] as String?,
      swapState: SwapState.values[(m['swapState'] ?? 0) as int],
      swapWithUserId: m['swapWithUserId'] as String?,
    );
  }
}
