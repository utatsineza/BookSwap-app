import 'package:book_swap_app/blocs/book/book_bloc.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import '../../providers/listings_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

class MyListingPage extends StatelessWidget {
  final BookRepository repository;
  final String userId;

  MyListingPage({required this.repository, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(repository)..add(LoadUserBooks(userId)),
      child: Scaffold(
        appBar: AppBar(title: Text('My Listings')),
        body: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookLoaded) {
              if (state.books.isEmpty) return Center(child: Text('You have no listings'));
              return ListView.builder(
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  var coverUrl = book.coverUrl;
                  return ListTile(
                    leading: Image.network(coverUrl!, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  );
                },
              );
            } else if (state is BookError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
