import 'package:flutter/material.dart';
import 'create_listing_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<Map<String, String>> myBooks = [
    {"title": "My Book 1", "author": "Me", "condition": "New"},
    {"title": "My Book 2", "author": "Me", "condition": "Used"},
  ];

  void _addBook(Map<String, String> book) {
    setState(() {
      myBooks.add(book);
    });
  }

  void _openCreateListing() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateListingScreen(onCreate: _addBook),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openCreateListing,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: myBooks.length,
        itemBuilder: (context, index) {
          final book = myBooks[index];
          return ListTile(
            leading: const Icon(Icons.library_books),
            title: Text(book['title']!),
            subtitle: Text("${book['author']} • ${book['condition']}"),
          );
        },
      ),
    );
  }
}
