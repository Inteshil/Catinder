import '../entities/cat.dart';
import '../repositories/cat_repo.dart';

class GetRandomCatUseCase {
  final CatRepository repository;

  GetRandomCatUseCase(this.repository);

  Future<Cat> call() async {
    return await repository.getRandomCat();
  }
}
