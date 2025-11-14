import 'package:equatable/equatable.dart';

abstract class ListingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadListings extends ListingsEvent {}

class CreateListing extends ListingsEvent {
  final String title;
  final String author;
  final String condition;
  final String coverImage;
  final String ownerId;

  CreateListing({
    required this.title,
    required this.author,
    required this.condition,
    required this.coverImage,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [title, author, condition, coverImage, ownerId];
}
