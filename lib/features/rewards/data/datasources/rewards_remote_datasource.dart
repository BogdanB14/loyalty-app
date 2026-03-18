import 'dart:math';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/reward_model.dart';
import '../models/redemption_model.dart';

abstract class RewardsRemoteDataSource {
  Future<List<RewardModel>> getRewardsForVenue(String venueId);
  Future<RedemptionModel> createRedemption(String venueId, String rewardId);
  Future<RedemptionModel?> pollRedemptionStatus(String redemptionId);
}

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final Dio dio;
  final Map<String, RedemptionModel> _redemptionCache = {};

  RewardsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RewardModel>> getRewardsForVenue(String venueId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.customerVenues}/$venueId${ApiConstants.venueRewardsSuffix}',
        queryParameters: {'page': 0, 'size': 50},
      );
      final data = response.data as Map<String, dynamic>;
      final rawRewards = data['rewards'];
      List<dynamic> list = const [];
      if (rawRewards is List) {
        list = rawRewards;
      } else if (rawRewards is Map && rawRewards['content'] is List) {
        list = rawRewards['content'] as List;
      }
      return list
          .map((e) => RewardModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<RedemptionModel> createRedemption(
      String venueId, String rewardId) async {
    try {
      final response = await dio.post(
        '${ApiConstants.redemptionBase}/$venueId${ApiConstants.redemptionSuffix}',
        data: {
          'rewardId': rewardId,
          'idempotencyKey': _generateUuid(),
          'customerNote': null,
        },
      );
      final redemption =
          RedemptionModel.fromJson(response.data as Map<String, dynamic>);
      _redemptionCache[redemption.id] = redemption;
      return redemption;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<RedemptionModel?> pollRedemptionStatus(String redemptionId) async {
    return _redemptionCache[redemptionId];
  }

  Never _handleDioError(DioException e) {
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

  String _generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
