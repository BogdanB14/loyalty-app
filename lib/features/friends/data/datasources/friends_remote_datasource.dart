import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/friend_model.dart';

abstract class FriendsRemoteDataSource {
  Future<List<FriendModel>> getAcceptedFriends();
  Future<List<FriendModel>> getIncomingRequests();
  Future<List<FriendModel>> getOutgoingRequests();
  Future<FriendModel> sendFriendRequest(String targetCustomerId);
  Future<FriendModel> acceptRequest(String friendshipId);
  Future<FriendModel> declineRequest(String friendshipId);
  Future<FriendModel> cancelRequest(String friendshipId);
  Future<List<FriendModel>> searchCustomers(String query);
}

class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final Dio dio;
  FriendsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FriendModel>> getAcceptedFriends() async {
    try {
      final response = await dio.get(ApiConstants.friendsAccepted);
      return _parseList(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<FriendModel>> getIncomingRequests() async {
    try {
      final response =
          await dio.get(ApiConstants.friendsRequestsIncoming);
      return _parseList(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<FriendModel>> getOutgoingRequests() async {
    try {
      final response =
          await dio.get(ApiConstants.friendsRequestsOutgoing);
      return _parseList(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<FriendModel> sendFriendRequest(String targetCustomerId) async {
    try {
      final response = await dio.post(
        ApiConstants.friendsRequests,
        data: {'targetCustomerId': targetCustomerId},
      );
      return FriendModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<FriendModel> acceptRequest(String friendshipId) async {
    try {
      final response = await dio.post(
        '${ApiConstants.friendsRequests}/$friendshipId/accept',
      );
      return FriendModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<FriendModel> declineRequest(String friendshipId) async {
    try {
      final response = await dio.post(
        '${ApiConstants.friendsRequests}/$friendshipId/decline',
      );
      return FriendModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<FriendModel> cancelRequest(String friendshipId) async {
    try {
      final response = await dio.post(
        '${ApiConstants.friendsRequests}/$friendshipId/cancel',
      );
      return FriendModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<FriendModel>> searchCustomers(String query) async {
    try {
      final response = await dio.get(
        ApiConstants.friendsSearch,
        queryParameters: {'q': query, 'page': 0, 'size': 20},
      );
      return _parseList(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  List<FriendModel> _parseList(dynamic data) {
    List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map && data['content'] is List) {
      list = data['content'] as List;
    } else {
      list = const [];
    }
    return list
        .map((e) => FriendModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
}
