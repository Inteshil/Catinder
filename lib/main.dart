import 'package:catinder/core/di/service_locator.dart';
import 'package:catinder/presentation/cubits/favorite_cats_cubit.dart';
import 'package:catinder/presentation/cubits/home_cubit.dart';
import 'package:catinder/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupLocator();
  runApp(const CatinderApp());
}

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<FavoriteCatsCubit>(
            create: (_) => getIt<FavoriteCatsCubit>()),
      ],
      child: MaterialApp(
        title: 'Catinder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
