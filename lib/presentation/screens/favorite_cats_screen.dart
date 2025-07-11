import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/presentation/cubits/favorite_cats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'detail_screen.dart';

class FavoriteCatsScreen extends StatelessWidget {
  final List<Cat> favoriteCats;
  const FavoriteCatsScreen({Key? key, required this.favoriteCats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedCubit = context.read<FavoriteCatsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showBreedFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => likedCubit.searchCats(query),
              decoration: InputDecoration(
                hintText: 'Search by breed...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FavoriteCatsCubit, FavoriteCatsState>(
              builder: (context, state) {
                if (state.filteredCats.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.filteredCats.length,
                  itemBuilder: (context, index) {
                    final cat = state.filteredCats[index];
                    return _buildCatItem(context, cat);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatItem(BuildContext context, Cat cat) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(cat: cat)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  cat.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.breed,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Liked: ${cat.formattedDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    context.read<FavoriteCatsCubit>().deleteCat(cat.id),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBreedFilterDialog(BuildContext context) {
    final cubit = context.read<FavoriteCatsCubit>();
    final breeds =
        cubit.allFavoriteCats.map((cat) => cat.breed).toSet().toList()
          ..sort()
          ..insert(0, 'All');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Breed'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(breeds[index]),
                onTap: () {
                  cubit.filterCats(
                    breeds[index] == 'All' ? null : breeds[index],
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No liked cats', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Like cats on the main screen',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
