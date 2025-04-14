import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/presentation/pages/detail_screen.dart';

class CatListItem extends StatelessWidget {
  final Cat cat;
  final VoidCallback onTap;

  const CatListItem({
    Key? key,
    required this.cat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: cat.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      title: Text(cat.breed),
      subtitle: Text(cat.description),
      onTap: onTap,
    );
  }
}