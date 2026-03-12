class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int totalPoints;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.totalPoints = 0,
  });
}
