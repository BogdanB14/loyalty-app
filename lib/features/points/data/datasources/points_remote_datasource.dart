import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/loyalty_card_model.dart';

abstract class PointsRemoteDataSource {
  Future<List<LoyaltyCardModel>> getPointsPerVenue();
}

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  final Dio dio;
  PointsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LoyaltyCardModel>> getPointsPerVenue() async {
    final response = await dio.get(ApiConstants.pointsPerVenue);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => LoyaltyCardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
