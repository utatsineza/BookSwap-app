import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_state.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Books')),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (context, state) {
          if (state is ListingsInitial || state is ListingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ListingsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is ListingsLoaded) {
            if (state.books.isEmpty) {
              return const Center(child: Text('No books available.'));
            }

            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
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
