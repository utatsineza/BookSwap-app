import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listings_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});
  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  String _condition = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _authorCtrl, decoration: const InputDecoration(labelText: 'Author')),
            DropdownButton<String>(
              value: _condition,
              items: const ['New', 'Like New', 'Good', 'Used'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _condition = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.read<ListingsProvider>().addBook(_titleCtrl.text, _authorCtrl.text, _condition);
                  Navigator.of(context).pop();
                },
                child: const Text('Add Book'))
          ],
        ),
      ),
    );
  }
}
