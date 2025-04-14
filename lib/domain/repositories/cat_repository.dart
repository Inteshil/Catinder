import 'package:catinder/domain/entities/cat.dart';

abstract class CatRepository {
  Future<Cat> getRandomCat([String? breed]);
  List<Cat> getLikedCats();
  void likeCat(Cat cat);
  void removeLikedCat(Cat cat);
  List<Cat> filterLikedCatsByBreed(String breed);
}