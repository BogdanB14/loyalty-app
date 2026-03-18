import '../../domain/entities/redemption_entity.dart';

class RedemptionModel extends RedemptionEntity {
  const RedemptionModel({
    required super.id,
    required super.status,
    required super.pointsCostSnapshot,
    super.expiresAt,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) => RedemptionModel(
        id: json['id'] as String,
        status: json['status'] as String,
        pointsCostSnapshot: json['pointsCostSnapshot'] as int,
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'pointsCostSnapshot': pointsCostSnapshot,
        'expiresAt': expiresAt?.toIso8601String(),
      };
}
