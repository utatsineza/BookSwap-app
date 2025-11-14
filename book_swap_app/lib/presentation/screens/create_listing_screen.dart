import 'package:flutter/material.dart';

class CreateListingScreen extends StatefulWidget {
  final Function(Map<String, String>) onCreate;

  const CreateListingScreen({super.key, required this.onCreate});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newBook = {
        "title": _titleController.text,
        "author": _authorController.text,
        "condition": _conditionController.text,
      };
      widget.onCreate(newBook);
      Navigator.pop(context); // close screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Listing")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: "Author"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter an author" : null,
              ),
              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(labelText: "Condition"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter condition" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Add Book"))
            ],
          ),
        ),
      ),
    );
  }
}
