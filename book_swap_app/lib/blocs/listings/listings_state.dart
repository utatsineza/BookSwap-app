// lib/presentation/blocs/listings/listings_state.dart
import 'package:equatable/equatable.dart';
import '../../models/book.dart' ;

abstract class ListingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListingsInitial extends ListingsState {}
class ListingsLoading extends ListingsState {}
class ListingsLoaded extends ListingsState {
  final List<Book> books;
  ListingsLoaded(this.books);
  @override List<Object?> get props => [books];
}
class ListingsError extends ListingsState {
  final String message;
  ListingsError(this.message);
  @override List<Object?> get props => [message];
}
