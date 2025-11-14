import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listings_provider.dart';
import '../../models/book.dart';

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
