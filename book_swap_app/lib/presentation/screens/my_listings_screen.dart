// lib/presentation/screens/my_listings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_state.dart';
import '../../blocs/listings/listings_event.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load all listings (or filter by current user if your Bloc supports it)
    context.read<ListingsBloc>().add(LoadListingsEvent());
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
            // Filter books by current user if you have ownerId field
            final userBooks = state.books
                .where((book) => book.ownerId == "currentUserId") // replace with real user ID
                .toList();

            if (userBooks.isEmpty) {
              return const Center(child: Text('You have no listings.'));
            }

            return ListView.builder(
              itemCount: userBooks.length,
              itemBuilder: (context, index) {
                final book = userBooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.author} • ${book.condition}'),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
