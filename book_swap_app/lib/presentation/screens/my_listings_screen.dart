import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_state.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  final String _currentUserId = "user_123"; // replace with real user from AuthBloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          if (state is ListingsLoading || state is ListingsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListingsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ListingsLoaded) {
            final myBooks = state.books
                .where((book) => book.ownerId == _currentUserId)
                .toList();

            if (myBooks.isEmpty) {
              return const Center(child: Text('You have no listings.'));
            }

            return ListView.builder(
              itemCount: myBooks.length,
              itemBuilder: (context, index) {
                final book = myBooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author} • ${book.condition}'),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
