import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_event.dart';
import '../../blocs/listings/listings_state.dart';
import '../../models/book.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the LoadListingsEvent after the widget is initialized
    context.read<ListingsBloc>().add(LoadListings());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Books')),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          if (state is ListingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListingsLoaded) {
            final books = state.books;
            if (books.isEmpty) {
              return const Center(child: Text('No books available.'));
            }
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                );
              },
            );
          } else if (state is ListingsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
