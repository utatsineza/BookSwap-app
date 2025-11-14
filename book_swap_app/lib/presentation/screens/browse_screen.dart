import 'package:book_swap_app/blocs/book/book_bloc.dart';
import 'package:book_swap_app/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import '../../providers/listings_provider.dart';
import '../../models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = context.watch<ListingsProvider>().books;
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Listings')),
      body: ListView.builder(
        itemCount: listings.length,
        itemBuilder: (ctx, i) {
          final b = listings[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(b.title),
              subtitle: Text('${b.author} • ${b.condition}'),
              trailing: b.swapState == SwapState.none
                  ? TextButton(
                      onPressed: () => context.read<ListingsProvider>().swapBook(b.id),
                      child: const Text('Swap'),
                    )
                  : Text(b.swapState.name.toUpperCase()),
            ),
          );
        },
      ),
    );
  }
}

class BrowsePage extends StatelessWidget {
  final BookRepository repository;

  BrowsePage({required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(repository)..add(LoadAllBooks()),
      child: Scaffold(
        appBar: AppBar(title: Text('Browse Books')),
        body: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookLoaded) {
              if (state.books.isEmpty) return Center(child: Text('No books found'));
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
