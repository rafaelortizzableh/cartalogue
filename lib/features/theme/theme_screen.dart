import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../features.dart';
import 'theme.dart';

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  static const routeName = '/theme';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeControllerProvider);
    final preferredColor = ref.watch(preferredColorControllerProvider);
    final theme = Theme.of(context);
    final foregroundColor =
        preferredColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.palette,
                  color: foregroundColor,
                ),
                AppSpacing.horizontalSpacing4,
                const Expanded(
                  child: Text(
                    'Theme',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: AppConstants.padding8,
            sliver: SliverToBoxAdapter(
              child: Text(
                'Theme Mode',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: AppConstants.padding16,
            sliver: SliverGrid.builder(
              gridDelegate: _themeSliverGridDelegate,
              itemCount: ThemeMode.values.length,
              itemBuilder: (coontext, index) {
                final themeMode = ThemeMode.values[index];

                return ThemeModeCard(
                  preferredColor: preferredColor,
                  themeMode: themeMode,
                  isCurrentThemeMode: themeMode == currentThemeMode,
                  onThemeModeSelected: (themeMode) async => await ref
                      .read(themeModeControllerProvider.notifier)
                      .updateThemeMode(themeMode),
                );
              },
            ),
          ),
          SliverPadding(
            padding: AppConstants.padding8,
            sliver: SliverToBoxAdapter(
              child: Text(
                'Preferred Color',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: AppConstants.padding16,
            sliver: SliverGrid.builder(
              gridDelegate: _themeSliverGridDelegate,
              itemCount: Colors.primaries.length,
              itemBuilder: (coontext, index) {
                final color = Colors.primaries[index];

                return ColorCard(
                  color: color,
                  isPreferredColor: color == preferredColor,
                  onPreferredColorSelected: (color) async => await ref
                      .read(preferredColorControllerProvider.notifier)
                      .updatePreferredColor(color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const _themeSliverGridDelegate =
      SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    mainAxisSpacing: 0,
    childAspectRatio: 1,
    crossAxisSpacing: 0,
  );
}

class ThemeModeCard extends StatelessWidget {
  const ThemeModeCard({
    super.key,
    required this.themeMode,
    required this.isCurrentThemeMode,
    required this.onThemeModeSelected,
    required this.preferredColor,
  });
  final ThemeMode themeMode;
  final bool isCurrentThemeMode;
  final Function(ThemeMode) onThemeModeSelected;
  final MaterialColor preferredColor;

  static const _themeTileMaxSize = 150.0;
  static const _themeTileAspectRatio = 1.0;

  Color _assignTileHighlightColor({
    required Brightness brightness,
    required bool isCurrentTheme,
  }) {
    if (!isCurrentTheme) return Colors.transparent;

    switch (brightness) {
      case Brightness.light:
        return Colors.black.withOpacity(0.25);
      case Brightness.dark:
        return Colors.white.withOpacity(0.25);
    }
  }

  Color get _assignCardColor {
    switch (themeMode) {
      case ThemeMode.system:
        return Colors.white;
      case ThemeMode.light:
        return Colors.white;
      case ThemeMode.dark:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileHighlightColor = _assignTileHighlightColor(
      brightness: theme.brightness,
      isCurrentTheme: isCurrentThemeMode,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: _themeTileMaxSize,
        maxHeight: _themeTileMaxSize,
      ),
      child: AspectRatio(
        aspectRatio: _themeTileAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppConstants.borderRadius12,
            border: Border.all(
              color: tileHighlightColor,
              width: AppConstants.spacing2,
            ),
          ),
          child: InkWell(
            onTap: () => onThemeModeSelected(themeMode),
            borderRadius: AppConstants.borderRadius12,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _assignCardColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: AppConstants.circularRadius12,
                                topRight: AppConstants.circularRadius12,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _assignCardColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: AppConstants.circularRadius12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: preferredColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: preferredColor.withOpacity(
                                    0.75,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: AppConstants.circularRadius12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (themeMode == ThemeMode.system) ...[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: AppConstants.circularRadius12,
                                topLeft: AppConstants.circularRadius12,
                              ),
                              color: preferredColor.withOpacity(0.75),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.smartphone,
                                color: Colors.white,
                                size: AppConstants.spacing48,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: AppConstants.padding8,
                    child: Text(
                      themeMode.toDisplayString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.color,
    required this.isPreferredColor,
    required this.onPreferredColorSelected,
  });

  final MaterialColor color;
  final bool isPreferredColor;
  final Function(MaterialColor) onPreferredColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppConstants.borderRadius12,
        border: Border.all(
          color: isPreferredColor
              ? theme.colorScheme.onBackground
              : Colors.transparent,
          width: AppConstants.spacing2,
        ),
      ),
      child: InkWell(
        onTap: () => onPreferredColorSelected(color),
        borderRadius: AppConstants.borderRadius12,
        child: Card(
          color: color,
          child: Center(
            child: Text(
              color.toDisplayString(),
              style: _getTextStyle(theme.textTheme),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    return textTheme.bodyLarge?.copyWith(
      color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
  }
}
