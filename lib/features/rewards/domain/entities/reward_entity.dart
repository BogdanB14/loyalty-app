class RewardEntity {
  final String id;
  final String venueId;
  final String? venueName;
  final String title;
  final String description;
  final int pointsCost;
  final int? quantity;
  final bool isActive;
  final String? imageUrl;
  final DateTime? expiresAt;

  const RewardEntity({
    required this.id,
    required this.venueId,
    this.venueName,
    required this.title,
    required this.description,
    required this.pointsCost,
    this.quantity,
    required this.isActive,
    this.imageUrl,
    this.expiresAt,
  });
}
