class ParsedReceiptData {
  final String qrRaw;
  final String? venueId;
  final String? pib;
  final String? issuedAt;
  final double? amount;
  final String? currency;
  final String? externalReceiptId;

  const ParsedReceiptData({
    required this.qrRaw,
    this.venueId,
    this.pib,
    this.issuedAt,
    this.amount,
    this.currency,
    this.externalReceiptId,
  });
}

class ReceiptClaimResult {
  final String receiptId;
  final String claimId;
  final String status;
  final int pointsEarned;

  const ReceiptClaimResult({
    required this.receiptId,
    required this.claimId,
    required this.status,
    required this.pointsEarned,
  });

  factory ReceiptClaimResult.fromJson(Map<String, dynamic> json) =>
      ReceiptClaimResult(
        receiptId: json['receiptId'] as String,
        claimId: json['claimId'] as String,
        status: json['status'] as String,
        pointsEarned: json['pointsEarned'] as int,
      );
}
