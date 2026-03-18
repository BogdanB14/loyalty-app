import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/receipt_models.dart';

abstract class ReceiptRemoteDataSource {
  Future<ReceiptClaimResult> claimReceipt(ParsedReceiptData data);
}

class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  final Dio dio;
  ReceiptRemoteDataSourceImpl(this.dio);

  @override
  Future<ReceiptClaimResult> claimReceipt(ParsedReceiptData data) async {
    try {
      final body = <String, dynamic>{
        'qrRaw': data.qrRaw,
        if (data.venueId != null) 'venueId': data.venueId,
        if (data.pib != null) 'pib': data.pib,
        if (data.issuedAt != null) 'issuedAt': data.issuedAt,
        if (data.amount != null) 'amount': data.amount,
        if (data.currency != null) 'currency': data.currency,
        if (data.externalReceiptId != null)
          'externalReceiptId': data.externalReceiptId,
      };
      final response = await dio.post(ApiConstants.receiptClaim, data: body);
      return ReceiptClaimResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const DuplicateReceiptException();
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.response?.data?['message'] as String? ??
            e.message ??
            'Server error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
