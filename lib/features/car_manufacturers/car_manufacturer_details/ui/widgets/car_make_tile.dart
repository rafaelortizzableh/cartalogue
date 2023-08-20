import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core.dart';
import '../../car_manufacturer_details.dart';

class CarMakeTile extends StatefulWidget {
  const CarMakeTile({
    super.key,
    required this.carMake,
    required this.index,
  });
  final CarMakeModel carMake;
  final int index;

  static const cardAspectRatio = 0.75;

  @override
  State<CarMakeTile> createState() => _CarMakeTileState();
}

class _CarMakeTileState extends State<CarMakeTile> {
  late final MaterialColor _color = _assignColorFromIndexAndId(
    widget.index,
    widget.carMake.id,
  );

  late final _colorScheme = ColorScheme.fromSwatch(
    primarySwatch: _color,
  );

  static const _minRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CarMakeTile.cardAspectRatio,
      child: Card(
        color: _colorScheme.primary,
        child: InkWell(
          onTap: _onTileOpened,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacing12,
              horizontal: AppConstants.spacing12,
            ),
            child: _CarMakeTileContent(
              colorScheme: _colorScheme,
              minRadius: _minRadius,
              carMake: widget.carMake,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTileOpened() async {
    final verticalPadding = MediaQuery.paddingOf(context).vertical;
    final viewPortHeight = MediaQuery.of(context).size.height;
    final boxConstraints = BoxConstraints.tightFor(
      height: viewPortHeight - verticalPadding - AppConstants.spacing16,
    );
    final contentWidth = MediaQuery.of(context).size.width / 2;
    unawaited(
      showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.spacing16),
          ),
        ),
        constraints: boxConstraints,
        context: context,
        builder: (context) {
          return CarMakeDetailBottomSheet(
            colorScheme: _colorScheme,
            contentWidth: contentWidth,
            minRadius: _minRadius,
            carMake: widget.carMake,
          );
        },
      ),
    );
  }

  MaterialColor _assignColorFromIndexAndId(int index, int id) {
    const primaryColors = Colors.primaries;

    final indexSeed = index + 1;

    final colorIndex = (indexSeed * id) % primaryColors.length;

    return primaryColors[colorIndex];
  }
}

class CarMakeDetailBottomSheet extends StatelessWidget {
  const CarMakeDetailBottomSheet({
    super.key,
    required this.colorScheme,
    required this.contentWidth,
    required this.minRadius,
    required this.carMake,
  });

  final ColorScheme colorScheme;
  final double contentWidth;
  final double minRadius;
  final CarMakeModel carMake;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.spacing16),
        ),
        color: colorScheme.primary,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: SizedBox(
                width: contentWidth,
                child: AspectRatio(
                  aspectRatio: CarMakeTile.cardAspectRatio,
                  child: _CarMakeTileContent(
                    colorScheme: colorScheme,
                    minRadius: minRadius,
                    carMake: carMake,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 3),
            // TODO(rafaelortizzableh): Add like button
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _CarMakeTileContent extends StatelessWidget {
  const _CarMakeTileContent({
    required this.colorScheme,
    required this.minRadius,
    required this.carMake,
  });

  final ColorScheme colorScheme;
  final double minRadius;
  final CarMakeModel carMake;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CircleAvatar(
            backgroundColor: colorScheme.onPrimary,
            minRadius: minRadius,
            child: Text(
              carMake.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: colorScheme.primary,
                    fontSize: minRadius * 0.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Text(
          carMake.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
