import 'dart:async';
import 'package:bloc/bloc.dart';
import 'listings_event.dart';
import 'listings_state.dart';
import '../../models/book.dart';
import '../../data/listings_service.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final ListingsService service;
  StreamSubscription<List<Book>>? _sub;

  ListingsBloc({required this.service}) : super(ListingsInitial()) {
    on<LoadListings>(_onLoad);
    on<CreateListing>(_onCreate);
    on<_ListingsUpdated>(_onUpdated);
  }

  Future<void> _onLoad(LoadListings event, Emitter<ListingsState> emit) async {
    emit(ListingsLoading());
    await _sub?.cancel();
    _sub = service.streamAllBooks().listen(
      (books) => add(_ListingsUpdated(books)),
      onError: (err) => emit(ListingsError(err.toString())),
    );
  }

  void _onUpdated(_ListingsUpdated event, Emitter<ListingsState> emit) {
    emit(ListingsLoaded(event.books));
  }

  Future<void> _onCreate(CreateListing event, Emitter<ListingsState> emit) async {
    try {
      // generate a dummy ID using timestamp
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      await service.createBook(
        id: newId,
        title: event.title,
        author: event.author,
        condition: event.condition,
        coverImage: event.coverImage,
        ownerId: event.ownerId,
      );
    } catch (err) {
      emit(ListingsError(err.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

// internal event for updates
class _ListingsUpdated extends ListingsEvent {
  final List<Book> books;
  _ListingsUpdated(this.books);

  @override
  List<Object?> get props => [books];
}
