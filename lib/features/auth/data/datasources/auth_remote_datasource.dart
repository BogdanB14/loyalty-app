import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithGoogle(String idToken);
  Future<UserModel> loginWithEmailPassword(String identifier, String password);
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> loginWithGoogle(String idToken) async {
    // Step 1: authenticate and get token
    final authResponse = await dio.post(
      ApiConstants.googleLogin,
      data: {'idToken': idToken},
    );
    final accessToken = authResponse.data['accessToken'] as String;
    await SecureStorage.saveToken(accessToken);

    // Step 2: fetch customer profile with the new token
    final profileResponse = await dio.get(ApiConstants.customerMe);
    return UserModel.fromJson(profileResponse.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> loginWithEmailPassword(String identifier, String password) async {
    // Step 1: authenticate
    final authResponse = await dio.post(
      ApiConstants.customerLogin,
      data: {'identifier': identifier, 'password': password},
    );
    final accessToken = authResponse.data['accessToken'] as String;
    await SecureStorage.saveToken(accessToken);

    // Step 2: fetch customer profile
    final profileResponse = await dio.get(ApiConstants.customerMe);
    return UserModel.fromJson(profileResponse.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dio.get(ApiConstants.customerMe);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
