import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

class LikedCarMakesScreen extends ConsumerWidget {
  const LikedCarMakesScreen({super.key});

  static const routeName = '/likedCarMakes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedCarMakes = ref.watch(likedCarMakesControllerProvider);
    final isLikedCarMakesEmpty = likedCarMakes.isEmpty;
    final preferredColor = ref.watch(preferredColorControllerProvider);
    final foregroundColor =
        preferredColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.heart_fill,
                  color: foregroundColor,
                ),
                AppSpacing.horizontalSpacing4,
                const Text(
                  'Liked Car Makes',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            floating: true,
            centerTitle: true,
          ),
          const SliverPadding(padding: AppConstants.verticalPadding4),
          if (isLikedCarMakesEmpty) ...[
            const NoLikedCarMakes()
          ] else ...[
            CarMakesList(
              carMakes: likedCarMakes.toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class NoLikedCarMakes extends StatelessWidget {
  const NoLikedCarMakes({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.heart_slash_circle_fill,
              size: 100,
              color: Colors.red,
            ),
            AppSpacing.verticalSpacing12,
            Text('No liked car makes found'),
          ],
        ),
      ),
    );
  }
}
