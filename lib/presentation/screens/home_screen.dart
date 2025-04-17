import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cat.dart';
import '../cubits/favorite_cats_cubit.dart';
import '../cubits/home_cubit.dart';
import '../widgets/action_button.dart';
import 'detail_screen.dart';
import 'favorite_cats_screen.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadCat();
  }

  void _handleLike() {
    final state = context.read<HomeCubit>().state;
    if (state is HomeLoaded) {
      final newCat = state.currentCat!.copyWithLike();
      context.read<FavoriteCatsCubit>().addCat(newCat);
      context.read<HomeCubit>().likeCat();
    }
  }

  void _handleDislike() {
    context.read<HomeCubit>().dislikeCat();
  }

  void _handleSwipe(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
    });
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 100) {
      if (_dragOffset > 0) {
        // Свайп вправо - лайк
        _handleLike();
      } else {
        // Свайп влево - дизлайк
        _handleDislike();
      }
    }
    setState(() {
      _dragOffset = 0;
    });
  }

  void _navigateToDetail(Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(cat: cat)),
    );
  }

  void _navigateToFavoriteCats() {
    final favoriteCats = context.read<FavoriteCatsCubit>().state.filteredCats;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteCatsScreen(favoriteCats: favoriteCats),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final likedCount =
        context.watch<FavoriteCatsCubit>().state.filteredCats.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CaTinder'),
        automaticallyImplyLeading: false,
        leading: TextButton.icon(
          onPressed: _navigateToFavoriteCats,
          icon: const Icon(Icons.favorite, color: Colors.red),
          label: Text(
            'Favorites ($likedCount)',
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        leadingWidth: 150,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const LoadingScreen();
          } else if (state is HomeError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  title: const Text(
                    'Network Error',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.read<HomeCubit>().loadCat();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            });
            return _buildErrorState(state.message);
          } else if (state is HomeLoaded) {
            final cat = state.currentCat;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onHorizontalDragUpdate: _handleSwipe,
                    onHorizontalDragEnd: _handleSwipeEnd,
                    onTap: () => _navigateToDetail(cat),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            cat!.imageUrl,
                            fit: BoxFit.cover,
                            height: 400,
                            loadingBuilder: (context, child, progress) {
                              return progress == null
                                  ? child
                                  : const SizedBox(
                                      height: 400,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 400,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    //   ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cat.breed,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ActionButton(
              icon: Icons.close,
              backgroundColor: Colors.red,
              onPressed: _handleDislike,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Likes: $likedCount',
                key: ValueKey('likes_$likedCount'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            ActionButton(
              icon: Icons.favorite,
              backgroundColor: Colors.green,
              onPressed: _handleLike,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $message',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<HomeCubit>().loadCat(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 120,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Try Again', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
