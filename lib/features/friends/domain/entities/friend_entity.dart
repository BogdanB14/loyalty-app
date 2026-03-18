class FriendEntity {
  final String id;
  final String otherCustomerId;
  final String otherUsername;
  final String otherDisplayName;
  final String status; // PENDING | ACCEPTED | DECLINED | CANCELLED
  final bool requestedByMe;
  final DateTime? respondedAt;

  const FriendEntity({
    required this.id,
    required this.otherCustomerId,
    required this.otherUsername,
    required this.otherDisplayName,
    required this.status,
    required this.requestedByMe,
    this.respondedAt,
  });
}
