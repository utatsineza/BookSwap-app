import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/book.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authId = context.watch<AuthProvider>().userId;
    final myBooks = context.watch<ListingsProvider>().books.where((b) => b.ownerId == authId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: ListView.builder(
        itemCount: myBooks.length,
        itemBuilder: (ctx, i) {
          final b = myBooks[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(b.title),
              subtitle: Text('${b.author} • ${b.condition}'),
              trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => context.read<ListingsProvider>().deleteBook(b.id)),
            ),
          );
        },
      ),
    );
  }
}
