import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  CatModel({
    required String id,
    required String imageUrl,
    required String breed,
    required String description,
    DateTime? likedAt,
  }) : super(
          id: id,
          imageUrl: imageUrl,
          breed: breed,
          description: description,
          likedAt: likedAt,
        );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breedData = (json['breeds'] != null && json['breeds'].isNotEmpty)
        ? json['breeds'][0]
        : {};

    return CatModel(
      id: json['id'],
      imageUrl: json['url'],
      breed: breedData['name'] ?? 'Unknown',
      description: breedData['description'] ?? 'No description available',
    );
  }
}
