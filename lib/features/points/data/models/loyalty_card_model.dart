import '../../domain/entities/loyalty_card_entity.dart';

class LoyaltyCardModel extends LoyaltyCardEntity {
  const LoyaltyCardModel({
    required super.venueId,
    required super.venueName,
    required super.balance,
  });

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> json) =>
      LoyaltyCardModel(
        venueId: json['venueId'] as String,
        venueName: json['venueName'] as String,
        balance: json['balance'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'venueId': venueId,
        'venueName': venueName,
        'balance': balance,
      };
}
