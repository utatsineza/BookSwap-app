import 'package:flutter/material.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  final List<Map<String, String>> dummyBooks = const [
    {"title": "Book One", "author": "Author A"},
    {"title": "Book Two", "author": "Author B"},
    {"title": "Book Three", "author": "Author C"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Books')),
      body: ListView.builder(
        itemCount: dummyBooks.length,
        itemBuilder: (context, index) {
          final book = dummyBooks[index];
          return ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}
