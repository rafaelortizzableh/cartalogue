import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/core.dart';
import '../../../../../features.dart';

class LikeCarMakeIconButton extends ConsumerStatefulWidget {
  const LikeCarMakeIconButton({
    super.key,
    required this.colorScheme,
    required this.carMake,
  });

  final ColorScheme colorScheme;
  final CarMakeModel carMake;

  @override
  ConsumerState<LikeCarMakeIconButton> createState() =>
      _LikeCarMakeIconButtonState();
}

class _LikeCarMakeIconButtonState extends ConsumerState<LikeCarMakeIconButton> {
  bool _isAnimatingLikeButton = false;

  @override
  Widget build(BuildContext context) {
    final likedCarMakeIds = ref.watch(likedCarMakesControllerProvider);
    final isLiked = likedCarMakeIds.contains(widget.carMake);

    return AnimatedScale(
      duration: kThemeAnimationDuration,
      scale: _likeButtonScale,
      child: IconButton(
        tooltip: _toolTipText(isLiked),
        onPressed: () => _onCarMakeLiked(ref),
        color: Colors.white,
        iconSize: AppConstants.spacing48,
        icon: AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          child: Icon(
            key: ValueKey(
              '${widget.carMake.id}_$isLiked',
            ),
            isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          ),
        ),
      ),
    );
  }

  double get _likeButtonScale => _isAnimatingLikeButton ? 1.25 : 1.0;

  void _onCarMakeLiked(WidgetRef ref) {
    setState(() => _isAnimatingLikeButton = true);
    ref.read(likedCarMakesControllerProvider.notifier).onCarMakeLiked(
          widget.carMake,
        );
    unawaited(Future<void>.delayed(
      kThemeAnimationDuration,
      () => setState(() => _isAnimatingLikeButton = false),
    ));
  }

  String _toolTipText(bool isLiked) {
    return isLiked
        ? 'Unlike ${widget.carMake.name}'
        : 'Like ${widget.carMake.name}';
  }
}
