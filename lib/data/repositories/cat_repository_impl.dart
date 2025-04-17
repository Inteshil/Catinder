import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repo.dart';
import '../services/cat_api_service.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;

  CatRepositoryImpl(this.apiService);

  @override
  Future<Cat> getRandomCat() {
    return apiService.fetchRandomCat();
  }
}
