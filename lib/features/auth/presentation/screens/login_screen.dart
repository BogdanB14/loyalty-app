import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';
import '../../../../core/theme/app_colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.loyalty, size: 80, color: AppColors.primary),
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
              const SizedBox(height: 56),
              SocialLoginButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: () => _loginWithGoogle(context, ref),
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                label: 'Continue with Apple',
                icon: Icons.apple,
                onPressed: () => _loginWithApple(context, ref),
              ),
              const SizedBox(height: 32),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) return;
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) return;
      // TODO: send idToken to backend and set user
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google login failed: $e')),
        );
      }
    }
  }

  Future<void> _loginWithApple(BuildContext context, WidgetRef ref) async {
    // TODO: Apple sign in
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple login coming soon')),
    );
  }
}
