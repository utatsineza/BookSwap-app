import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadBookCover(File file, String bookId) async {
    final ref = _storage.ref('book_covers/$bookId.jpg');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<void> deleteBookCover(String bookId) async {
    final ref = _storage.ref('book_covers/$bookId.jpg');
    await ref.delete();
  }
}
