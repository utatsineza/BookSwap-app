import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SwapStatus { pending, accepted, rejected }

class SwapOffer {
  final String id;
  final String bookId;
  final String bookTitle;
  final String senderId;
  final String senderName;
  final String receiverId;
  final SwapStatus status;
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory SwapOffer.fromMap(Map<String, dynamic> data, String id) {
    return SwapOffer(
      id: id,
      bookId: data['bookId'] ?? '',
      bookTitle: data['bookTitle'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: SwapStatus.values.firstWhere(
        (e) => e.toString() == 'SwapStatus.${data['status']}',
        orElse: () => SwapStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class SwapProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<SwapOffer> _myOffers = [];
  List<SwapOffer> _receivedOffers = [];
  bool isLoading = false;

  List<SwapOffer> get myOffers => _myOffers;
  List<SwapOffer> get receivedOffers => _receivedOffers;

  Future<void> createSwapOffer({
    required String bookId,
    required String bookTitle,
    required String senderId,
    required String senderName,
    required String receiverId,
  }) async {
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
    await _db.collection('swaps').add({
      'bookId': bookId,
      'bookTitle': bookTitle,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('books').doc(bookId).update({'status': 'pending'});
  }

  Future<void> loadMyOffers(String userId) async {
    isLoading = true;
    notifyListeners();
    final snapshot = await _db.collection('swaps').where('senderId', isEqualTo: userId).get();
    _myOffers = snapshot.docs.map((d) => SwapOffer.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadReceivedOffers(String userId) async {
    isLoading = true;
    notifyListeners();
    final snapshot = await _db.collection('swaps').where('receiverId', isEqualTo: userId).get();
    _receivedOffers = snapshot.docs.map((d) => SwapOffer.fromMap(d.data(), d.id)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateSwapStatus(String swapId, SwapStatus status) async {
    await _db.collection('swaps').doc(swapId).update({
      'status': status.toString().split('.').last,
    });
    final swap = _receivedOffers.firstWhere((s) => s.id == swapId);
    await _db.collection('books').doc(swap.bookId).update({
      'status': status.toString().split('.').last,
    });
  }

  void listenToMyOffers(String userId) {
    if (kIsWeb) return;
    _db.collection('swaps').where('senderId', isEqualTo: userId).snapshots().listen((snapshot) {
      _myOffers = snapshot.docs.map((d) => SwapOffer.fromMap(d.data(), d.id)).toList();
      notifyListeners();
    });
  }

  void listenToReceivedOffers(String userId) {
    if (kIsWeb) return;
    _db.collection('swaps').where('receiverId', isEqualTo: userId).snapshots().listen((snapshot) {
      _receivedOffers = snapshot.docs.map((d) => SwapOffer.fromMap(d.data(), d.id)).toList();
      notifyListeners();
    });
  }
}
