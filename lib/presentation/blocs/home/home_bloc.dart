import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';
import 'package:catinder/presentation/blocs/home/home_event.dart';
import 'package:catinder/presentation/blocs/home/home_state.dart';

// Events
abstract class HomeEvent {}

class LoadRandomCat extends HomeEvent {}

class LoadNextCat extends HomeEvent {}

class LikeCat extends HomeEvent {
  final Cat cat;
  LikeCat(this.cat);
}

class DislikeCat extends HomeEvent {
  final Cat cat;
  DislikeCat(this.cat);
}

// States
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Cat cat;
  HomeLoaded({required this.cat});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CatRepository _catRepository;

  HomeBloc(this._catRepository) : super(HomeInitial()) {
    on<LoadRandomCat>(_onLoadRandomCat);
    on<LoadNextCat>(_onLoadNextCat);
    on<LikeCat>(_onLikeCat);
    on<DislikeCat>(_onDislikeCat);
  }

  Future<void> _onLoadRandomCat(LoadRandomCat event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final cat = await _catRepository.getRandomCat();
      emit(HomeLoaded(cat: cat));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadNextCat(LoadNextCat event, Emitter<HomeState> emit) async {
    try {
      final cat = await _catRepository.getRandomCat();
      emit(HomeLoaded(cat: cat));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLikeCat(LikeCat event, Emitter<HomeState> emit) async {
    try {
      await _catRepository.likeCat(event.cat);
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onDislikeCat(DislikeCat event, Emitter<HomeState> emit) async {
    try {
      await _catRepository.removeLikedCat(event.cat);
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}