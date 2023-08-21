import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ExtendedHomeSliverAppBar extends StatelessWidget {
  const ExtendedHomeSliverAppBar({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final theme = Theme.of(context);
    final fadeEnlargedAppBarAt = screenHeight * 0.25;
    return FadingLargeSliverAppBar(
      fadeAt: fadeEnlargedAppBarAt,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: const DrawerButton(),
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle,
      ),
      brightness: Brightness.dark,
      actionsIconTheme: theme.appBarTheme.actionsIconTheme,
      iconTheme: theme.appBarTheme.iconTheme,
      customSystemUiOverlayStyle:
          theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light,
      expandedHeight: screenHeight * 0.45,
      stretchModes: const [
        StretchMode.fadeTitle,
        StretchMode.zoomBackground,
        StretchMode.blurBackground
      ],
      background: Stack(
        children: [
          const ExtendedAppBarBackground(),
          ExtendedAppBarTitle(title: title),
        ],
      ),
    );
  }
}
