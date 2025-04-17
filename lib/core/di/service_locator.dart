import 'package:catinder/data/repositories/cat_repository_impl.dart';
import 'package:catinder/data/services/cat_api_service.dart';
import 'package:catinder/domain/repositories/cat_repo.dart';
import 'package:catinder/domain/usecases/get_random_card_usecase.dart';
import 'package:catinder/presentation/cubits/favorite_cats_cubit.dart';
import 'package:catinder/presentation/cubits/home_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<CatApiService>(() => CatApiService());
  getIt.registerLazySingleton<CatRepository>(() => CatRepositoryImpl(getIt()));
  getIt.registerLazySingleton<GetRandomCatUseCase>(
    () => GetRandomCatUseCase(getIt()),
  );

  getIt.registerFactory<FavoriteCatsCubit>(() => FavoriteCatsCubit());

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getRandomCatUseCase: getIt()),
  );
}
