class Master {
  const Master({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.bio,
    this.averageRating = 0.0,
    this.totalRatings = 0,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final double averageRating;
  final int totalRatings;

  factory Master.fromJson(Map<String, dynamic> json) => Master(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        bio: json['bio'] as String?,
        averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
        totalRatings: (json['total_ratings'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatarUrl,
        'bio': bio,
        'average_rating': averageRating,
        'total_ratings': totalRatings,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Master && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Master($name, ★$averageRating)';
}
