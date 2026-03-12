import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithAppleUseCase {
  final AuthRepository repository;
  const LoginWithAppleUseCase(this.repository);

  Future<UserEntity> call(String identityToken) =>
      repository.loginWithApple(identityToken);
}
