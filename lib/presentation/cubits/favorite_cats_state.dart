part of 'favorite_cats_cubit.dart';

abstract class FavoriteCatsState extends Equatable {
  final List<Cat> filteredCats;

  const FavoriteCatsState({required this.filteredCats});

  @override
  List<Object> get props => [filteredCats];
}

class FavoriteCatsInitial extends FavoriteCatsState {
  const FavoriteCatsInitial({required super.filteredCats});
}

class FavoriteCatsUpdated extends FavoriteCatsState {
  const FavoriteCatsUpdated({required super.filteredCats});
}
