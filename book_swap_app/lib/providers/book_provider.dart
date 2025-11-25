import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Book> _books = [];
  List<Book> get books => _books;
  bool isLoading = false;

  Future<void> loadAllBooks() async {
    isLoading = true;
    notifyListeners();
    final snapshot = await _db.collection('books').get();
    _books = snapshot.docs.map((d) => Book.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserBooks(String userId) async {
    isLoading = true;
    notifyListeners();
    final snapshot =
        await _db.collection('books').where('ownerId', isEqualTo: userId).get();
    _books = snapshot.docs.map((d) => Book.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  // CREATE - Add new book with Supabase Storage
  Future<String?> createBook({
    required String userId,
    required String title,
    required String author,
    required String condition,
    File? imageFile,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String? coverUrl;
      if (imageFile != null) {
        coverUrl = await _uploadImageToSupabase(imageFile, userId);
      }

      await _db.collection('books').add({
        'title': title,
        'author': author,
        'condition': condition,
        'ownerId': userId,
        'coverUrl': coverUrl,
        'swapState': SwapState.none.index,
        'swapWithUserId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await loadUserBooks(userId);

      isLoading = false;
      notifyListeners();
      return null; // Success
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // UPDATE - Edit existing book with Supabase Storage
  Future<String?> updateBook({
    required String bookId,
    required String title,
    required String author,
    required String condition,
    File? newImageFile,
    String? existingImageUrl,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      String? coverUrl = existingImageUrl;

      if (newImageFile != null) {
        // Delete old image if exists
        if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
          await _deleteImageFromSupabase(existingImageUrl);
        }
        // Upload new image
        coverUrl = await _uploadImageToSupabase(newImageFile, bookId);
      }

      await _db.collection('books').doc(bookId).update({
        'title': title,
        'author': author,
        'condition': condition,
        'coverUrl': coverUrl,
      });

      // Update local list
      final index = _books.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _books[index] = _books[index].copyWith(
          title: title,
          author: author,
          condition: condition,
          coverUrl: coverUrl,
        );
      }

      isLoading = false;
      notifyListeners();
      return null; // Success
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // DELETE - Remove book with Supabase Storage
  Future<void> deleteBook(String id) async {
    try {
      final book = _books.firstWhere((b) => b.id == id);

      // Delete image if exists
      if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
        await _deleteImageFromSupabase(book.coverUrl!);
      }

      await _db.collection('books').doc(id).delete();
      _books.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Helper: Upload image to Supabase Storage
  Future<String> _uploadImageToSupabase(
      File imageFile, String identifier) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      print('🔍 Supabase user: ${currentUser?.id}');
      print('🔍 User email: ${currentUser?.email}');
      print('🔍 Session exists: ${_supabase.auth.currentSession != null}');

      final fileName =
          '${identifier}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'book_covers/$fileName';

      print('Uploading to Supabase: $filePath');

      // Upload file
      await _supabase.storage.from('book_covers').upload(filePath, imageFile);

      // Get public URL
      final publicUrl =
          _supabase.storage.from('book_covers').getPublicUrl(filePath);

      print('Upload successful: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('Supabase upload error: $e');
      rethrow;
    }
  }

  // Helper: Delete image from Supabase Storage
  Future<void> _deleteImageFromSupabase(String imageUrl) async {
    try {
      // Extract file path from URL
      // URL format: https://xxxxx.supabase.co/storage/v1/object/public/book_covers/path/to/file.jpg
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find the index of 'book_covers' and get everything after it
      final bucketIndex = pathSegments.indexOf('book_covers');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

        print('Deleting from Supabase: book_covers/$filePath');

        await _supabase.storage
            .from('book_covers')
            .remove(['book_covers/$filePath']);
      }
    } catch (e) {
      print('Supabase delete error: $e');
      // Don't throw - deletion failure shouldn't block book deletion
    }
  }
}
