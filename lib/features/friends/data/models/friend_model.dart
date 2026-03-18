import '../../domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  const FriendModel({
    required super.id,
    required super.otherCustomerId,
    required super.otherUsername,
    required super.otherDisplayName,
    required super.status,
    required super.requestedByMe,
    super.respondedAt,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
        id: json['id'] as String,
        otherCustomerId: json['otherCustomerId'] as String,
        otherUsername: json['otherUsername'] as String? ?? '',
        otherDisplayName: json['otherDisplayName'] as String? ?? '',
        status: json['status'] as String,
        requestedByMe: json['requestedByMe'] as bool? ?? false,
        respondedAt: json['respondedAt'] != null
            ? DateTime.parse(json['respondedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'otherCustomerId': otherCustomerId,
        'otherUsername': otherUsername,
        'otherDisplayName': otherDisplayName,
        'status': status,
        'requestedByMe': requestedByMe,
        'respondedAt': respondedAt?.toIso8601String(),
      };
}
