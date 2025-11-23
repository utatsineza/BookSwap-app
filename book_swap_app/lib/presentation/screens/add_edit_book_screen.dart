import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/book.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book; // null for create, populated for edit

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late TextEditingController _titleCtrl;
  late TextEditingController _authorCtrl;
  String _condition = 'Good';
  File? _imageFile;
  bool _loading = false;

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Used'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.book?.title ?? '');
    _authorCtrl = TextEditingController(text: widget.book?.author ?? '');
    _condition = widget.book?.condition ?? 'Good';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    
    if (pickedFile != null && mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if image is required for new books
    if (widget.book == null && _imageFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a cover image')),
        );
      }
      return;
    }

    if (mounted) {
      setState(() => _loading = true);
    }

    final bookProvider = context.read<BookProvider>();
    final auth = context.read<AuthProvider>();
    String? error;

    if (widget.book == null) {
      // CREATE
      error = await bookProvider.createBook(
        userId: auth.userId!,
        title: _titleCtrl.text.trim(),
        author: _authorCtrl.text.trim(),
        condition: _condition,
        imageFile: _imageFile,
      );
    } else {
      // UPDATE
      error = await bookProvider.updateBook(
        bookId: widget.book!.id,
        title: _titleCtrl.text.trim(),
        author: _authorCtrl.text.trim(),
        condition: _condition,
        newImageFile: _imageFile,
        existingImageUrl: widget.book!.coverUrl,
      );
    }

    if (mounted) {
      setState(() => _loading = false);

      if (error == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.book == null ? 'Book added!' : 'Book updated!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a3e),
        foregroundColor: Colors.white,
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFf4c542)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a3e).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1a1a3e), width: 2),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                            : widget.book?.coverUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.book!.coverUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 50,
                                        color: const Color(0xFF1a1a3e).withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to select cover image',
                                        style: TextStyle(
                                          color: const Color(0xFF1a1a3e).withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title Field
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Book Title',
                        labelStyle: const TextStyle(color: Color(0xFF1a1a3e)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFf4c542), width: 2),
                        ),
                      ),
                      validator: (val) => val?.trim().isEmpty ?? true ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Author Field
                    TextFormField(
                      controller: _authorCtrl,
                      decoration: InputDecoration(
                        labelText: 'Author',
                        labelStyle: const TextStyle(color: Color(0xFF1a1a3e)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFf4c542), width: 2),
                        ),
                      ),
                      validator: (val) => val?.trim().isEmpty ?? true ? 'Author is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Condition Dropdown
                    DropdownButtonFormField<String>(
                      value: _condition,
                      decoration: InputDecoration(
                        labelText: 'Condition',
                        labelStyle: const TextStyle(color: Color(0xFF1a1a3e)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFf4c542), width: 2),
                        ),
                      ),
                      items: _conditions.map((condition) {
                        return DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (mounted) {
                          setState(() => _condition = val!);
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFf4c542),
                          foregroundColor: const Color(0xFF1a1a3e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.book == null ? 'Add Book' : 'Update Book',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}