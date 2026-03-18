import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';

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
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = _ref.read(authRepositoryProvider);
      final user = await repository.getCurrentUser();
      if (user == null) {
        state = const AuthState();
        return;
      }
      state = state.copyWith(user: user, isLoading: false);
    } catch (_) {
      await SecureStorage.deleteToken();
      state = const AuthState();
    }
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setUser(UserEntity user) {
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);
