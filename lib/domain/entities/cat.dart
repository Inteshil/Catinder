class Cat {
  final String id;
  final String imageUrl;
  final String breed;
  final String description;
  final DateTime likedAt;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breed,
    required this.description,
    DateTime? likedAt,
  }) : likedAt = likedAt ?? DateTime.now();

  String get formattedDate {
    return '${likedAt.day.toString().padLeft(2, '0')}'
        '-${likedAt.month.toString().padLeft(2, '0')}'
        '-${likedAt.year.toString().substring(2)} '
        '${likedAt.hour.toString().padLeft(2, '0')}'
        '.${likedAt.minute.toString().padLeft(2, '0')}';
  }

  Cat copyWithLike() {
    return Cat(
      id: id,
      imageUrl: imageUrl,
      breed: breed,
      description: description,
      likedAt: DateTime.now(),
    );
  }
}
