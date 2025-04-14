abstract class HomeState {
  final bool isLoading;
  final Cat? currentCat;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.currentCat,
    this.errorMessage,
  });
}

class HomeInitial extends HomeState {
  const HomeInitial() : super(isLoading: true);
}

class HomeLoading extends HomeState {
  const HomeLoading() : super(isLoading: true);
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required Cat cat}) : super(currentCat: cat);
}

class HomeError extends HomeState {
  const HomeError({required String message}) : super(errorMessage: message);
} 