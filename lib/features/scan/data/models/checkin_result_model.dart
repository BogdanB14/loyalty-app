class CheckinResultModel {
  final String venueId;
  final String venueName;
  final int pointsAwarded;
  final int newPointsTotal;
  final String tier;
  final String? message;

  const CheckinResultModel({
    required this.venueId,
    required this.venueName,
    required this.pointsAwarded,
    required this.newPointsTotal,
    required this.tier,
    this.message,
  });

  factory CheckinResultModel.fromJson(Map<String, dynamic> json) =>
      CheckinResultModel(
        venueId: json['venueId'] as String,
        venueName: json['venueName'] as String,
        pointsAwarded: json['pointsAwarded'] as int,
        newPointsTotal: json['newPointsTotal'] as int,
        tier: json['tier'] as String,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'venueId': venueId,
        'venueName': venueName,
        'pointsAwarded': pointsAwarded,
        'newPointsTotal': newPointsTotal,
        'tier': tier,
        'message': message,
      };
}
