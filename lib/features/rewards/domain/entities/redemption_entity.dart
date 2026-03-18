class RedemptionEntity {
  final String id;
  final String status;
  final int pointsCostSnapshot;
  final DateTime? expiresAt;

  const RedemptionEntity({
    required this.id,
    required this.status,
    required this.pointsCostSnapshot,
    this.expiresAt,
  });
}
