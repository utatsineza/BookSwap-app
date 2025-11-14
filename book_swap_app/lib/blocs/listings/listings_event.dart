// lib/presentation/blocs/listings/listings_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../models/book.dart' ;

abstract class ListingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadListings extends ListingsEvent {}

class LoadListingsEvent extends ListingsEvent {}


class CreateListing extends ListingsEvent {
  final String title;
  final String author;
  final String condition;
  final File? coverImage;

  CreateListing({required this.title, required this.author, required this.condition, this.coverImage});

  @override
  List<Object?> get props => [title, author, condition, coverImage];
}
