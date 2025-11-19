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

  factory Book.fromMap(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'] as String? ?? '',
      author: data['author'] as String? ?? '',
      condition: data['condition'] as String? ?? '',
      ownerId: data['ownerId'] as String? ?? '',
      coverUrl: data['coverUrl'] as String?,
      swapState: SwapState.values[(data['swapState'] ?? 0) as int],
      swapWithUserId: data['swapWithUserId'] as String?,
    );
  }
}
