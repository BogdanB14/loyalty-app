import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/network/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> loginWithGoogle(String idToken) =>
      remoteDataSource.loginWithGoogle(idToken);

  @override
  Future<UserEntity> loginWithApple(String identityToken) =>
      // TODO: update UI — loginWithApple removed from AuthRemoteDataSource
      throw UnimplementedError('loginWithApple not yet implemented');

  @override
  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await SecureStorage.getToken();
    if (token == null) return null;
    return remoteDataSource.getCurrentUser();
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});
