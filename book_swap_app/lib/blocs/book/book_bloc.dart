// book_bloc.dart
import 'package:book_swap_app/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_swap_app/repositories/book_repository.dart';


// States
abstract class BookState {}
class BookLoading extends BookState {}
class BookLoaded extends BookState {
  final List<Book> books;
  BookLoaded(this.books);
}
class BookError extends BookState {
  final String message;
  BookError(this.message);
}

// Events
abstract class BookEvent {}
class LoadAllBooks extends BookEvent {}
class LoadUserBooks extends BookEvent {
  final String userId;
  LoadUserBooks(this.userId);
}

// Bloc
class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;
  BookBloc(this.repository) : super(BookLoading()) {
    on<LoadAllBooks>((event, emit) async {
      emit(BookLoading());
      try {
        final books = await repository.fetchAllBooks();
        emit(BookLoaded(books.cast<Book>()));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    });

    on<LoadUserBooks>((event, emit) async {
      emit(BookLoading());
      try {
        final books = await repository.fetchUserBooks(event.userId);
        emit(BookLoaded(books.cast<Book>()));
      } catch (e) {
        emit(BookError(e.toString()));
      }
    });
  }
}
