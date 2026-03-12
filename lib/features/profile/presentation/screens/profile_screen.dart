import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final initial =
        (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'U';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Color.fromRGBO(255, 107, 53, 0.2),
                  child: Text(
                    initial,
                    style: const TextStyle(
                        fontSize: 36,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user?.name ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(user?.email ?? '',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star_rounded,
                      color: AppColors.secondary),
                  title: const Text('Total Points'),
                  trailing: Text(
                    '${user?.totalPoints ?? 0}',
                    style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.card_giftcard_outlined,
                      color: AppColors.primary),
                  title: const Text('Claimed Rewards'),
                  trailing: const Text('3',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined,
                      color: AppColors.primary),
                  title: const Text('Receipts Scanned'),
                  trailing: const Text('12',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.people_outline, color: AppColors.primary),
                  title: const Text('Friends'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/friends'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined,
                      color: AppColors.secondary),
                  title: const Text('Rewards'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/rewards'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined,
                      color: AppColors.primary),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
