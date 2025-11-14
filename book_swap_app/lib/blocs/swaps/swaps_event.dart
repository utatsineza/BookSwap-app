import 'package:equatable/equatable.dart';

abstract class SwapsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSwaps extends SwapsEvent {}

class CreateSwapOffer extends SwapsEvent {
  final String bookId;
  final String recipientId;
  CreateSwapOffer({required this.bookId, required this.recipientId});
  @override List<Object?> get props => [bookId, recipientId];
}

class UpdateSwapStatus extends SwapsEvent {
  final String swapId;
  final String status;
  UpdateSwapStatus({required this.swapId, required this.status});
  @override List<Object?> get props => [swapId, status];
}

// Internal event for stream updates
class SwapsUpdated extends SwapsEvent {
  final List swaps;
  SwapsUpdated(this.swaps);
  @override List<Object?> get props => [swaps];
}

