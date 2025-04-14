import 'package:dartz/dartz.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';
import 'package:catinder/data/datasources/cat_api_service.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService _apiService;
  final List<Cat> _likedCats = [];

  CatRepositoryImpl(this._apiService);

  @override
  Future<Cat> getRandomCat([String? breed]) async {
    final cat = await _apiService.fetchRandomCat(breed);
    if (cat == null) {
      throw Exception('Failed to fetch random cat');
    }
    return cat;
  }

  @override
  List<Cat> getLikedCats() => List.from(_likedCats);

  @override
  void likeCat(Cat cat) {
    if (!_likedCats.contains(cat)) {
      _likedCats.add(cat);
    }
  }

  @override
  void removeLikedCat(Cat cat) {
    _likedCats.remove(cat);
  }

  @override
  List<Cat> filterLikedCatsByBreed(String breed) {
    return _likedCats.where((cat) => cat.breed == breed).toList();
  }

  @override
  List<Cat> filterCats(List<Cat> cats, String breed) {
    if (breed.isEmpty) return cats;
    return cats.where((cat) => cat.breed == breed).toList();
  }
}