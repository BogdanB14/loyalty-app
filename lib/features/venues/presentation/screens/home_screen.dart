import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/venue_card.dart';

const _mockVenues = [
  {
    'name': 'Kafana Zlatni Bor',
    'promotion': 'Double points this weekend!',
    'distance': '0.3 km',
    'category': 'restaurant',
  },
  {
    'name': 'Caffe Bar Lav',
    'promotion': 'Happy hour 15:00–18:00',
    'distance': '0.7 km',
    'category': 'bar',
  },
  {
    'name': 'Restoran Šaran',
    'promotion': 'Free dessert with 500 pts',
    'distance': '1.1 km',
    'category': 'restaurant',
  },
  {
    'name': 'McBurger Beograd',
    'promotion': '',
    'distance': '1.4 km',
    'category': 'fastfood',
  },
  {
    'name': 'Kafeterija Roma',
    'promotion': 'Loyalty bonus x2 Fridays',
    'distance': '1.8 km',
    'category': 'cafe',
  },
  {
    'name': 'Pivnica Kod Dragana',
    'promotion': '',
    'distance': '2.2 km',
    'category': 'bar',
  },
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.loyalty, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('LoyApp'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nearby Venues',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('Scan a receipt to earn loyalty points',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final v = _mockVenues[i];
                  return VenueCard(
                    name: v['name']!,
                    promotion: v['promotion']!,
                    distance: v['distance']!,
                    category: v['category']!,
                    onTap: () => context.push('/venue/$i'),
                  );
                },
                childCount: _mockVenues.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }
}
