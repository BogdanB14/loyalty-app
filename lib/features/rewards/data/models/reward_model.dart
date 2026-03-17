import '../../domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.id,
    required super.venueId,
    super.venueName,
    required super.title,
    required super.description,
    required super.pointsCost,
    super.quantity,
    required super.isActive,
    super.imageUrl,
    super.expiresAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
        id: json['id'] as String,
        venueId: json['venueId'] as String,
        venueName: json['venueName'] as String?,
        title: json['title'] as String,
        description: json['description'] as String,
        pointsCost: json['pointsCost'] as int,
        quantity: json['quantity'] as int?,
        isActive: json['isActive'] as bool? ?? true,
        imageUrl: json['imageUrl'] as String?,
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'venueName': venueName,
        'title': title,
        'description': description,
        'pointsCost': pointsCost,
        'quantity': quantity,
        'isActive': isActive,
        'imageUrl': imageUrl,
        'expiresAt': expiresAt?.toIso8601String(),
      };
}
