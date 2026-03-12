import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithGoogle(String idToken);
  Future<UserModel> loginWithApple(String identityToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> loginWithGoogle(String idToken) async {
    final response = await dio.post(
      ApiConstants.googleLogin,
      data: {'idToken': idToken},
    );
    final token = response.data['token'] as String;
    await SecureStorage.saveToken(token);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  @override
  Future<UserModel> loginWithApple(String identityToken) async {
    final response = await dio.post(
      '/auth/apple',
      data: {'identityToken': identityToken},
    );
    final token = response.data['token'] as String;
    await SecureStorage.saveToken(token);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }
}
