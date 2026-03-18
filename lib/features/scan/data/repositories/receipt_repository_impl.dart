import '../datasources/receipt_remote_datasource.dart';
import '../models/receipt_models.dart';

class ReceiptRepositoryImpl {
  final ReceiptRemoteDataSource remoteDataSource;
  ReceiptRepositoryImpl(this.remoteDataSource);

  Future<ReceiptClaimResult> claimReceipt(ParsedReceiptData data) =>
      remoteDataSource.claimReceipt(data);
}
