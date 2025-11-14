// lib/presentation/screens/browse_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_state.dart';
import '../../blocs/listings/listings_event.dart';
import 'create_listing_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger load listings after widget is inserted into the tree
    context.read<ListingsBloc>().add(LoadListingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Listings')),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          if (state is ListingsLoading || state is ListingsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListingsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ListingsLoaded) {
            final books = state.books;
            if (books.isEmpty) {
              return const Center(child: Text('No books listed yet.'));
            }
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: book.coverUrl != null
                        ? Image.network(book.coverUrl!, width: 50, fit: BoxFit.cover)
                        : const Icon(Icons.book, size: 50),
                    title: Text(book.title),
                    subtitle: Text('${book.author} • ${book.condition}'),
                    trailing: ElevatedButton(
                      child: const Text('Swap'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Swap functionality coming soon!')),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateListingScreen()),
          );
        },
      ),
    );
  }
}
