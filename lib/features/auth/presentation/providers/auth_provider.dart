import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? loginError;

  const AuthState({this.user, this.isLoading = false, this.loginError});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? loginError}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      loginError: loginError,
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

  /// Runs entirely in the notifier — safe even after LoginScreen is disposed.
  Future<void> loginWithEmailPassword(
      String identifier, String password) async {
    state = const AuthState(isLoading: true);
    try {
      final ds = AuthRemoteDataSourceImpl(_ref.read(dioProvider));
      final user = await ds.loginWithEmailPassword(identifier, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(loginError: e.toString());
    }
  }

  /// Runs entirely in the notifier — safe even after LoginScreen is disposed.
  Future<void> loginWithGoogle(String idToken) async {
    state = const AuthState(isLoading: true);
    try {
      final ds = AuthRemoteDataSourceImpl(_ref.read(dioProvider));
      final user = await ds.loginWithGoogle(idToken);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(loginError: e.toString());
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
