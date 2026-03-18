import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/receipt_remote_datasource.dart';
import '../../data/repositories/receipt_repository_impl.dart';
import '../../data/models/receipt_models.dart';

enum ReceiptClaimStatus { idle, submitting, success, error, duplicate }

class ReceiptState {
  final ReceiptClaimStatus status;
  final int? pointsEarned;
  final String? errorMessage;

  const ReceiptState({
    this.status = ReceiptClaimStatus.idle,
    this.pointsEarned,
    this.errorMessage,
  });
}

class ReceiptNotifier extends StateNotifier<ReceiptState> {
  final Ref _ref;
  ReceiptNotifier(this._ref) : super(const ReceiptState());

  ReceiptRepositoryImpl _repo() => ReceiptRepositoryImpl(
        ReceiptRemoteDataSourceImpl(_ref.read(dioProvider)),
      );

  void reset() => state = const ReceiptState();

  Future<void> claimReceipt(ParsedReceiptData data) async {
    state = const ReceiptState(status: ReceiptClaimStatus.submitting);
    try {
      final result = await _repo().claimReceipt(data);
      state = ReceiptState(
        status: ReceiptClaimStatus.success,
        pointsEarned: result.pointsEarned,
      );
    } on DuplicateReceiptException {
      state = const ReceiptState(status: ReceiptClaimStatus.duplicate);
    } catch (e) {
      state = ReceiptState(
        status: ReceiptClaimStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final receiptProvider =
    StateNotifierProvider<ReceiptNotifier, ReceiptState>(
  (ref) => ReceiptNotifier(ref),
);
