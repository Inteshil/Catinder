part of 'liked_cats_bloc.dart';

abstract class LikedCatsState {}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<Cat> allCats;
  final List<Cat> filteredCats;
  final String selectedBreed;

  LikedCatsLoaded(this.allCats, this.filteredCats, {this.selectedBreed = ''});

  LikedCatsLoaded copyWith({
    List<Cat>? filteredCats,
    String? selectedBreed,
  }) {
    return LikedCatsLoaded(
      allCats,
      filteredCats ?? this.filteredCats,
      selectedBreed: selectedBreed ?? this.selectedBreed,
    );
  }
}