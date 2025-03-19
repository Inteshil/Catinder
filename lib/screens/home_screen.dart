import 'package:flutter/material.dart';

import '../models/cat.dart';
import '../services/cat_api_service.dart';
import '../widgets/action_button.dart';
import '../widgets/cat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CatApiService _catApiService = CatApiService();
  int currentBreedIndex = 0;
  int likeCount = 0;
  double _dragOffset = 0;
  Cat? currentCat;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNextCat();
  }

  Future<void> _loadNextCat() async {
    if (currentBreedIndex >= CatApiService.breedIds.length) {
      setState(() {
        currentCat = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final breedId = CatApiService.breedIds.values.elementAt(currentBreedIndex);
    final cat = await _catApiService.getRandomCatByBreed(breedId);

    setState(() {
      currentCat = cat;
      isLoading = false;
    });
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
        _nextCat(isLike: true);
      } else {
        // Свайп влево - дизлайк
        _nextCat();
      }
    }
    setState(() {
      _dragOffset = 0;
    });
  }

  void _nextCat({bool isLike = false}) {
    if (isLike) {
      setState(() {
        likeCount++;
      });
    }
    setState(() {
      currentBreedIndex++;
    });
    _loadNextCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лайков: $likeCount'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentCat != null
              ? Column(
                  children: [
                    Expanded(
                      child: CatCard(
                        cat: currentCat!,
                        dragOffset: _dragOffset,
                        onHorizontalDragUpdate: _handleSwipe,
                        onHorizontalDragEnd: _handleSwipeEnd,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                            onPressed: () => _nextCat(),
                            backgroundColor: Colors.red,
                            icon: Icons.close,
                            heroTag: 'dislike',
                          ),
                          ActionButton(
                            onPressed: () => _nextCat(isLike: true),
                            backgroundColor: Colors.green,
                            icon: Icons.favorite,
                            heroTag: 'like',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    'Больше котиков нет 😢',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
    );
  }
}
