import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../features.dart';
import 'theme.dart';

class ThemeModeScreen extends ConsumerWidget {
  const ThemeModeScreen({super.key});

  static const routeName = '/theme-mode';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Mode'),
      ),
      body: Padding(
        padding: AppConstants.padding16,
        child: GridView.builder(
          gridDelegate: _themeSliverGridDelegate,
          itemCount: ThemeMode.values.length,
          itemBuilder: (coontext, index) {
            final themeMode = ThemeMode.values[index];

            return ThemeCard(
              themeMode: themeMode,
              isCurrentTheme: themeMode == currentThemeMode,
              onThemeModeSelected: (themeMode) async => await ref
                  .read(themeControllerProvider.notifier)
                  .updateThemeMode(themeMode),
            );
          },
        ),
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

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    super.key,
    required this.themeMode,
    required this.isCurrentTheme,
    required this.onThemeModeSelected,
  });
  final ThemeMode themeMode;
  final bool isCurrentTheme;
  final Function(ThemeMode) onThemeModeSelected;

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
      isCurrentTheme: isCurrentTheme,
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
                                decoration: const BoxDecoration(
                                  color: CustomTheme.primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.primaryColor.withOpacity(
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
                              color: CustomTheme.primaryColor.withOpacity(0.75),
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
