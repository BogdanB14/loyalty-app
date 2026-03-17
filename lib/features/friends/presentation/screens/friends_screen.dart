import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';

const _mockFriends = [
  {'name': 'Ana Petrović', 'points': 850, 'shared': 50},
  {'name': 'Marko Nikolić', 'points': 1200, 'shared': 100},
  {'name': 'Jelena Jovanović', 'points': 430, 'shared': 25},
];

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.userPlus),
            onPressed: () => _showAddFriend(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Friends List',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final f in _mockFriends)
            _FriendTile(
              name: f['name'] as String,
              totalPoints: f['points'] as int,
              sharedPoints: f['shared'] as int,
            ),
          const SizedBox(height: 24),
          Text('Shared Points History',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _SharedHistoryTile(
            context: context,
            venue: 'Kafana Zlatni Bor',
            total: 200,
            people: 4,
            each: 50,
            date: 'Mar 10, 2026',
          ),
          _SharedHistoryTile(
            context: context,
            venue: 'Caffe Bar Lav',
            total: 100,
            people: 2,
            each: 50,
            date: 'Mar 8, 2026',
          ),
        ],
      ),
    );
  }

  void _showAddFriend(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add Friend'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Enter email or username'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Send Request')),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final String name;
  final int totalPoints;
  final int sharedPoints;

  const _FriendTile(
      {required this.name,
      required this.totalPoints,
      required this.sharedPoints});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 107, 53, 0.2),
          child: Text(
            name[0],
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text('$totalPoints pts total'),
        trailing: TextButton(
          onPressed: () {},
          child: const Text('Share'),
        ),
      ),
    );
  }
}

class _SharedHistoryTile extends StatelessWidget {
  final BuildContext context;
  final String venue;
  final int total;
  final int people;
  final int each;
  final String date;

  const _SharedHistoryTile({
    required this.context,
    required this.venue,
    required this.total,
    required this.people,
    required this.each,
    required this.date,
  });

  @override
  Widget build(BuildContext c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(PhosphorIconsRegular.usersThree,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(venue,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('$total pts shared between $people people ($each each)',
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
