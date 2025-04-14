part of 'liked_cats_bloc.dart';

abstract class LikedCatsEvent {}

class LoadLikedCats extends LikedCatsEvent {}

class DeleteLikedCat extends LikedCatsEvent {
  final Cat cat;

  DeleteLikedCat(this.cat);
}

class FilterCats extends LikedCatsEvent {
  final String breed;

  FilterCats(this.breed);
}