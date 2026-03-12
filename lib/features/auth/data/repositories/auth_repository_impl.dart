import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/storage/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> loginWithGoogle(String idToken) =>
      remoteDataSource.loginWithGoogle(idToken);

  @override
  Future<UserEntity> loginWithApple(String identityToken) =>
      remoteDataSource.loginWithApple(identityToken);

  @override
  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await SecureStorage.getToken();
    if (token == null) return null;
    return null;
  }
}
