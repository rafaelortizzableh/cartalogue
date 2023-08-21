import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ExtendedAppBarBackground extends StatefulWidget {
  const ExtendedAppBarBackground({super.key});

  @override
  State<ExtendedAppBarBackground> createState() =>
      _ExtendedAppBarBackgroundState();
}

class _ExtendedAppBarBackgroundState extends State<ExtendedAppBarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final List<Widget> roadLines;
  late List<Widget> cars;

  static const _carHeight = 40.0;

  static const _carImagesLength = 6;

  static final _roadGradientColors = [
    Colors.grey.shade900,
    Colors.black,
    Colors.grey.shade900,
  ];

  @override
  void initState() {
    super.initState();
    _initAnimationAndAddListener();
    _generateRoadLines();
    _generateCars();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roadLinesAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.1, 0.0),
    ).animate(_controller);
    final carsAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(3.0, 0.0),
    ).animate(_controller);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _roadGradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SlideTransition(
                    position: roadLinesAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: roadLines,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SlideTransition(
            position: carsAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppSpacing.verticalSpacing12,
                ...cars.map((e) => Flexible(child: e)).toList(),
                AppSpacing.verticalSpacing16,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initAnimationAndAddListener() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _controller.addListener(_regenerateCarsAndRestartAnimation);
  }

  void _regenerateCarsAndRestartAnimation() {
    if (_controller.status != AnimationStatus.completed) return;
    // When the animation reaches the end,
    // the cars are generated in a new position.

    setState(() => _generateCars());
    _controller.reset();
    _controller.forward();
  }

  void _generateRoadLines() {
    roadLines = List.generate(
      100,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: AppConstants.spacing32,
          height: AppConstants.spacing4,
          color: Colors.yellow,
        ),
      ),
    );
  }

  void _generateCars() {
    final carsInOrder = List.generate(
      _carImagesLength,
      (index) => Padding(
        padding: _generateRandomHorizontalPadding(),
        child: SizedBox(
          height: _carHeight,
          child: Image.asset(
            _getCarAsset(index),
            height: _carHeight,
          ),
        ),
      ),
    );
    // Shuffle the cars so that they appear in random order.
    carsInOrder.shuffle();
    cars = [...carsInOrder];
  }

  EdgeInsets _generateRandomHorizontalPadding() {
    final random = Random();
    final randomPadding = random.nextInt(300);
    final sidePadding = randomPadding.toDouble();
    final isLeftRandomSide = random.nextBool();
    if (isLeftRandomSide) {
      return EdgeInsets.only(
        left: isLeftRandomSide ? sidePadding : 0.0,
        right: isLeftRandomSide ? 0.0 : sidePadding,
        bottom: 0.0,
        top: 0.0,
      );
    }

    return EdgeInsets.only(right: sidePadding);
  }

  static String _getCarAsset(int index) => 'assets/images/car-$index.webp';
}
