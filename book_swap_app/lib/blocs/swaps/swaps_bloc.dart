import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:book_swap_app/domain/models/swap_model.dart';
import 'swaps_event.dart';
import 'swaps_state.dart';
import '../../data/swaps_service.dart';
import '../../models/swap.dart' hide Swap; // Make sure you import your Swap model

class SwapsBloc extends Bloc<SwapsEvent, SwapsState> {
  final SwapsService service;
  StreamSubscription? _sub;

  SwapsBloc({required this.service}) : super(SwapsInitial()) {
    on<LoadSwaps>(_onLoad);
    on<CreateSwapOffer>(_onCreate);
    on<UpdateSwapStatus>(_onUpdate);

    // Fixed: Convert List<dynamic> to List<Swap>
    on<SwapsUpdated>((event, emit) {
      final swaps = (event.swaps as List).map((e) => e as Swap).toList();
      emit(SwapsLoaded(swaps.cast<Swap>()));
    });
  }

  void _onLoad(LoadSwaps event, Emitter<SwapsState> emit) {
    emit(SwapsLoading());
    _sub?.cancel();
    _sub = service.streamMySwaps().listen(
      (swaps) => add(SwapsUpdated(swaps)),
      onError: (err) => emit(SwapsError(err.toString())),
    );
  }

  Future<void> _onCreate(CreateSwapOffer event, Emitter<SwapsState> emit) async {
    try {
      await service.createSwap(bookId: event.bookId, recipientId: event.recipientId);
    } catch (err) {
      emit(SwapsError(err.toString()));
    }
  }

  Future<void> _onUpdate(UpdateSwapStatus event, Emitter<SwapsState> emit) async {
    try {
      await service.updateSwapStatus(event.swapId, event.status);
    } catch (err) {
      emit(SwapsError(err.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
