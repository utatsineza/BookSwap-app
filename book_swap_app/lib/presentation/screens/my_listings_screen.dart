import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_event.dart';
import '../../blocs/listings/listings_state.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  // Replace this with actual authenticated user ID from AuthBloc/Firebase
  final String _currentUserId = "user_123";

  @override
  void initState() {
    super.initState();
    // Load all listings
    context.read<ListingsBloc>().add(LoadListings());
  }

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
            // Filter books by current user
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

