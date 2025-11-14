import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/listings/listings_bloc.dart';
import '../../blocs/listings/listings_event.dart';
import '../../blocs/listings/listings_state.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({Key? key}) : super(key: key);
  @override State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _titleCtl = TextEditingController();
  final _authorCtl = TextEditingController();
  String _condition = 'New';
  File? _image;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<ListingsBloc, ListingsState>(
          listener: (context, state) {
            if (state is ListingsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ListingsLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing created!')));
              Navigator.of(context).pop();
            }
          },
          child: ListView(
            children: [
              TextField(controller: _titleCtl, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: _authorCtl, decoration: const InputDecoration(labelText: 'Author')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _condition,
                items: ['New', 'Like New', 'Good', 'Used'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _condition = v ?? 'New'),
                decoration: const InputDecoration(labelText: 'Condition'),
              ),
              const SizedBox(height: 12),
              _image != null ? Image.file(_image!, height: 150) : const SizedBox(),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick cover image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<ListingsBloc>().add(CreateListing(
                    title: _titleCtl.text.trim(),
                    author: _authorCtl.text.trim(),
                    condition: _condition,
                    coverImage: _image,
                  ));
                },
                child: const Text('Create Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
