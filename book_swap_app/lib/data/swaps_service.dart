import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/models/swap_model.dart';
import 'package:uuid/uuid.dart';

class SwapsService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // Stream all swaps where current user is sender or recipient
  Stream<List<Swap>> streamMySwaps() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _fs.collection('swaps')
        .where('senderId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Swap.fromMap(doc.data())).toList());
  }

  // Send swap offer
  Future<void> createSwap({required String bookId, required String recipientId}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = _fs.collection('swaps').doc();
    final swap = Swap(
      id: doc.id,
      bookId: bookId,
      senderId: uid,
      recipientId: recipientId,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    await doc.set(swap.toMap());
  }

  // Update swap status
  Future<void> updateSwapStatus(String swapId, String status) async {
    await _fs.collection('swaps').doc(swapId).update({'status': status});
  }
}
