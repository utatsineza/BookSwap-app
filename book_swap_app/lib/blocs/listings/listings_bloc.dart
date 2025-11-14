// lib/presentation/blocs/listings/listings_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'listings_event.dart';
import 'listings_state.dart';
import '../../data/listings_service.dart';
import '../../models/book.dart' ; // Make sure your Book model exists

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final ListingsService service;
  StreamSubscription? _sub;

  ListingsBloc({required this.service}) : super(ListingsInitial()) {
    // Handle LoadListingsEvent
    on<LoadListingsEvent>(_onLoad);

    // Handle CreateListing event
    on<CreateListing>(_onCreate);

    // Handle internal updates from the stream
    on<_ListingsUpdated>((event, emit) {
      emit(ListingsLoaded(event.books.cast<Book>()));
    });
  }

  // Load all books from service
  void _onLoad(LoadListingsEvent event, Emitter<ListingsState> emit) {
    emit(ListingsLoading());
    _sub?.cancel();
    _sub = service.streamAllBooks().listen(
      (books) => add(_ListingsUpdated(books.cast<Book>())), // internal event
      onError: (err) => emit(ListingsError(err.toString())),
    );
  }

  // Create a new listing
  Future<void> _onCreate(CreateListing event, Emitter<ListingsState> emit) async {
    try {
      await service.createBook(
        title: event.title,
        author: event.author,
        condition: event.condition,
        coverImage: event.coverImage,
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

// Internal event to update state from the stream
class _ListingsUpdated extends ListingsEvent {
  final List<Book> books;
  _ListingsUpdated(this.books);

  @override
  List<Object?> get props => [books];
}
