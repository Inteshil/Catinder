import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catinder/domain/entities/cat.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const CatCard({
    Key? key,
    required this.cat,
    required this.onLike,
    required this.onDislike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: cat.imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.breed,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(cat.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onDislike,
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: onLike,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}