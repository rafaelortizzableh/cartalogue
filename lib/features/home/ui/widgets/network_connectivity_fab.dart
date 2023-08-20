import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class NetworkConnectivyFab extends ConsumerWidget {
  const NetworkConnectivyFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNetworkConnected = ref.watch(isNetworkConnectedProvider);

    return _NoConnectionIcon(
      isNetworkConnected: isNetworkConnected,
    );
  }
}

class _NoConnectionIcon extends StatefulWidget {
  const _NoConnectionIcon({
    // ignore: unused_element
    super.key,
    required this.isNetworkConnected,
  });

  final bool isNetworkConnected;

  @override
  State<_NoConnectionIcon> createState() => _NoConnectionIconState();
}

class _NoConnectionIconState extends State<_NoConnectionIcon>
    with TickerProviderStateMixin {
  late bool _shouldRender = !widget.isNetworkConnected;

  late final _transformationAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  // Slide the icon in from the bottom of the screen
  // when the network connection is lost and slide it
  // out when the connection is restored.
  late final _slideAnimationController = AnimationController(
    vsync: this,
    duration: kThemeAnimationDuration,
  );

  @override
  void didUpdateWidget(covariant _NoConnectionIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    _hideIconAfterSlideAnimationCompletes();
  }

  void _hideIconAfterSlideAnimationCompletes() {
    if (widget.isNetworkConnected) {
      _slideAnimationController.reverse().then((value) {
        setState(() => _shouldRender = false);
      });
      return;
    }

    setState(() => _shouldRender = true);
    unawaited(_slideAnimationController.forward());
  }

  @override
  void dispose() {
    _transformationAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldRender) {
      return AppSpacing.emptySpace;
    }

    final position = _slideAnimationController.drive(
      Tween<Offset>(
        begin: const Offset(0, 2),
        end: const Offset(0, 0),
      ).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    final animatedBorderRadius = _transformationAnimationController.drive(
      Tween<BorderRadius>(
        begin: AppConstants.borderRadius8,
        end: AppConstants.borderRadius16,
      ).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    final animatedPadding = _transformationAnimationController.drive(
      Tween<EdgeInsets>(
        begin: AppConstants.padding8,
        end: AppConstants.padding4,
      ).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    return SlideTransition(
      position: position,
      child: AnimatedBuilder(
          animation: animatedPadding,
          child: const Icon(
            CupertinoIcons.wifi_slash,
            color: Colors.white,
          ),
          builder: (context, child) {
            return AnimatedBuilder(
              animation: animatedBorderRadius,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: CustomTheme.errorRed.withOpacity(0.9),
                    borderRadius: animatedBorderRadius.value,
                  ),
                  padding: animatedPadding.value,
                  child: child,
                );
              },
              child: child,
            );
          }),
    );
  }
}
