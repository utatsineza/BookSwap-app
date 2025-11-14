import 'package:equatable/equatable.dart';
import '../../domain/models/swap_model.dart';

abstract class SwapsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SwapsInitial extends SwapsState {}
class SwapsLoading extends SwapsState {}
class SwapsLoaded extends SwapsState {
  final List<Swap> swaps;
  SwapsLoaded(this.swaps);
  @override List<Object?> get props => [swaps];
}
class SwapsError extends SwapsState {
  final String message;
  SwapsError(this.message);
  @override List<Object?> get props => [message];
}
