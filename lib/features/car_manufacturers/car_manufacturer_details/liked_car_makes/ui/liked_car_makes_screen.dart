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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Car Makes'),
      ),
      body: isLikedCarMakesEmpty
          ? const NoLikedCarMakes()
          : CarMakesList(
              carMakes: likedCarMakes.toList(),
            ),
    );
  }
}

class NoLikedCarMakes extends StatelessWidget {
  const NoLikedCarMakes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
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
    );
  }
}
