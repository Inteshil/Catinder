import 'package:catinder/domain/entities/cat.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_cats_state.dart';

class FavoriteCatsCubit extends Cubit<FavoriteCatsState> {
  FavoriteCatsCubit() : super(const FavoriteCatsInitial(filteredCats: []));

  final List<Cat> _allCats = [];
  List<Cat> _filteredCats = [];
  String? _selectedBreed;

  List<Cat> get allFavoriteCats => _allCats;

  List<Cat> get filteredCats => _filteredCats;

  void addCat(Cat cat) {
    _allCats.add(cat);
    _filterCats();
    emit(FavoriteCatsUpdated(filteredCats: _filteredCats));
  }

  void deleteCat(String catId) {
    _allCats.removeWhere((cat) => cat.id == catId);
    _filterCats();
    emit(FavoriteCatsUpdated(filteredCats: _filteredCats));
  }

  void filterCats(String? breed) {
    _selectedBreed = breed;
    _filterCats();
    emit(FavoriteCatsUpdated(filteredCats: _filteredCats));
  }

  void searchCats(String query) {
    _filterCats(query);
    emit(FavoriteCatsUpdated(filteredCats: _filteredCats));
  }

  void _filterCats([String query = '']) {
    _filteredCats = _allCats.where((cat) {
      final breedMatch = _selectedBreed == null || cat.breed == _selectedBreed;
      final searchMatch = cat.breed.toLowerCase().contains(
            query.toLowerCase(),
          );
      return breedMatch && searchMatch;
    }).toList();
  }
}
