import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/venue_model.dart';

abstract class VenueRemoteDataSource {
  Future<List<VenueModel>> getVenues({int page = 0, int size = 20});
  Future<List<VenueModel>> searchVenues(String query);
  Future<Map<String, dynamic>> getVenueWithRewards(String venueId, {int page = 0, int size = 20});
}

class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  final Dio dio;
  VenueRemoteDataSourceImpl(this.dio);

  @override
  Future<List<VenueModel>> getVenues({int page = 0, int size = 20}) async {
    final response = await dio.get(
      ApiConstants.customerVenues,
      queryParameters: {'page': page, 'size': size, 'sort': 'name'},
    );
    final content = response.data['content'] as List<dynamic>;
    return content
        .map((e) => VenueModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<VenueModel>> searchVenues(String query) async {
    final response = await dio.get(
      ApiConstants.customerVenueSearch,
      queryParameters: {'q': query},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => VenueModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getVenueWithRewards(String venueId, {int page = 0, int size = 20}) async {
    final response = await dio.get(
      '${ApiConstants.customerVenues}/$venueId${ApiConstants.venueRewardsSuffix}',
      queryParameters: {'page': page, 'size': size},
    );
    return response.data as Map<String, dynamic>;
  }
}
