import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    super.totalPoints,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['displayName'] as String? ?? json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photoUrl: json['photoUrl'] as String?,
        totalPoints: json['totalPoints'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': name,
        'email': email,
        'photoUrl': photoUrl,
        'totalPoints': totalPoints,
      };
}
