import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/storage/secure_storage.dart';

class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      state = state.copyWith(
        user: const UserEntity(
          id: '1',
          name: 'Marko Jovanović',
          email: 'marko@example.com',
          totalPoints: 1250,
        ),
      );
    }
  }

  void setUser(UserEntity user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
