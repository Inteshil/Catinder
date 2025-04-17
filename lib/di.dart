import 'package:get_it/get_it.dart';
import 'package:catinder/data/datasources/cat_api_service.dart';
import 'package:catinder/data/repositories/cat_repository_impl.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';
import 'package:catinder/presentation/blocs/home/home_bloc.dart';
import 'package:catinder/presentation/blocs/liked_cats/liked_cats_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  print('Initializing DI container...');

  // Services
  print('Registering CatApiService...');
  getIt.registerLazySingleton<CatApiService>(() {
    print('Creating CatApiService');
    return CatApiService();
  });

  // Repositories
  print('Registering CatRepository...');
  getIt.registerLazySingleton<CatRepository>(() {
    print('Creating CatRepositoryImpl');
    return CatRepositoryImpl(getIt());
  });
  
  // BLoCs
  getIt.registerFactory(() => HomeBloc(getIt<CatRepository>()));
  getIt.registerFactory(() => LikedCatsBloc(getIt<CatRepository>()));

  print('DI container initialized');
}