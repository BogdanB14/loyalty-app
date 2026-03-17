import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

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
    final token = await SecureStorage.getToken();
    if (token == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get(ApiConstants.customerMe);
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
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
