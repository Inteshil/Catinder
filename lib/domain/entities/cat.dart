class Cat {
  final String id;
  final String imageUrl;
  final String breed;
  final String description;
  final String detailedDescription;
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breed,
    required this.description,
    required this.detailedDescription,
    this.likedAt,
  });

  Cat copyWith({
    String? id,
    String? imageUrl,
    String? breed,
    String? description,
    String? detailedDescription,
    DateTime? likedAt,
  }) {
    return Cat(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      breed: breed ?? this.breed,
      description: description ?? this.description,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imageUrl == other.imageUrl &&
          breed == other.breed;

  @override
  int get hashCode => id.hashCode ^ imageUrl.hashCode ^ breed.hashCode;
}