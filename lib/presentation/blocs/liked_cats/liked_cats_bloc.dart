import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';

// Events
abstract class LikedCatsEvent {}

class LoadLikedCats extends LikedCatsEvent {}

class RemoveLikedCat extends LikedCatsEvent {
  final Cat cat;
  RemoveLikedCat(this.cat);
}

// States
abstract class LikedCatsState {}

class LikedCatsInitial extends LikedCatsState {}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<Cat> cats;
  LikedCatsLoaded(this.cats);
}

class LikedCatsError extends LikedCatsState {
  final String message;
  LikedCatsError(this.message);
}

// Bloc
class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  final CatRepository _catRepository;

  LikedCatsBloc(this._catRepository) : super(LikedCatsInitial()) {
    on<LoadLikedCats>(_onLoadLikedCats);
    on<RemoveLikedCat>(_onRemoveLikedCat);
  }

  Future<void> _onLoadLikedCats(LoadLikedCats event, Emitter<LikedCatsState> emit) async {
    try {
      emit(LikedCatsLoading());
      final cats = _catRepository.getLikedCats();
      emit(LikedCatsLoaded(cats));
    } catch (e) {
      emit(LikedCatsError(e.toString()));
    }
  }

  Future<void> _onRemoveLikedCat(RemoveLikedCat event, Emitter<LikedCatsState> emit) async {
    try {
      _catRepository.removeLikedCat(event.cat);
      final cats = _catRepository.getLikedCats();
      emit(LikedCatsLoaded(cats));
    } catch (e) {
      emit(LikedCatsError(e.toString()));
    }
  }
}