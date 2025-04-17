import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/usecases/get_random_card_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRandomCatUseCase _getRandomCatUseCase;

  HomeCubit({required GetRandomCatUseCase getRandomCatUseCase})
      : _getRandomCatUseCase = getRandomCatUseCase,
        super(HomeInitial());

  void loadCat() async {
    emit(HomeLoading());
    try {
      final cat = await _getRandomCatUseCase();
      emit(HomeLoaded(currentCat: cat));
    } catch (e) {
      emit(
        const HomeError(
          message: 'No internet connection.',
        ),
      );
    }
  }

  void likeCat() {
    if (state is HomeLoaded) {
      loadCat();
    }
  }

  void dislikeCat() {
    loadCat();
  }
}
