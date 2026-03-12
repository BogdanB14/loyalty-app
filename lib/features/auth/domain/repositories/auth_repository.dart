import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithGoogle(String idToken);
  Future<UserEntity> loginWithApple(String identityToken);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
