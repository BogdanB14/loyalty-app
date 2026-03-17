import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/api_client.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Icon(PhosphorIconsRegular.seal,
                  size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                'LoyApp',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Earn loyalty points at your favourite venues',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              SocialLoginButton(
                label: 'Continue with Google',
                icon: PhosphorIconsRegular.googleLogo,
                onPressed: () => _loginWithGoogle(context, ref),
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                label: 'Continue with Apple',
                icon: PhosphorIconsRegular.appleLogo,
                onPressed: () => _loginWithApple(context),
              ),
              const SizedBox(height: 24),
              // Divider with "or"
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 24),
              // Email field
              TextField(
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sign in button
              ElevatedButton(
                onPressed: () => _loginWithEmailPassword(
                  context,
                  ref,
                  _identifierController.text.trim(),
                  _passwordController.text,
                ),
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  // Demo: skip login
                  ref.read(authProvider.notifier).setUser(
                        const UserEntity(
                          id: '1',
                          name: 'Demo User',
                          email: 'demo@example.com',
                          totalPoints: 320,
                        ),
                      );
                },
                child: const Text('Continue as demo'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(authProvider.notifier).setLoading(true);
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) {
        ref.read(authProvider.notifier).setLoading(false);
        return;
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        ref.read(authProvider.notifier).setLoading(false);
        return;
      }
      final ds = AuthRemoteDataSourceImpl(ref.read(dioProvider));
      final user = await ds.loginWithGoogle(idToken);
      ref.read(authProvider.notifier).setUser(UserEntity(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
          ));
    } catch (e) {
      ref.read(authProvider.notifier).setLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  Future<void> _loginWithEmailPassword(
    BuildContext context,
    WidgetRef ref,
    String identifier,
    String password,
  ) async {
    if (identifier.isEmpty || password.isEmpty) return;
    ref.read(authProvider.notifier).setLoading(true);
    try {
      final ds = AuthRemoteDataSourceImpl(ref.read(dioProvider));
      final user = await ds.loginWithEmailPassword(identifier, password);
      ref.read(authProvider.notifier).setUser(UserEntity(
            id: user.id,
            name: user.name,
            email: user.email,
            photoUrl: user.photoUrl,
          ));
    } catch (e) {
      ref.read(authProvider.notifier).setLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loginWithApple(BuildContext context) async {
    // TODO: Apple sign in
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple login coming soon')),
    );
  }
}
