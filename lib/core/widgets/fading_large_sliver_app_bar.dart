import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FadingLargeSliverAppBar extends StatefulWidget {
  const FadingLargeSliverAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.background,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.forceElevated = false,
    this.foregroundColor,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.pinned = true,
    this.titleTextStyle,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.snap = false,
    this.stretch = true,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
    this.customSystemUiOverlayStyle = SystemUiOverlayStyle.light,
    required this.fadeAt,
  })  : assert(floating || !snap,
            'The "snap" argument only makes sense for floating app bars.'),
        assert(stretchTriggerOffset > 0.0),
        assert(
          collapsedHeight == null || collapsedHeight > toolbarHeight,
          'The "collapsedHeight" argument has to be larger than [toolbarHeight].',
        );
  final double fadeAt;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? background;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final Color? foregroundColor;
  final bool forceElevated;
  final Color? backgroundColor;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextStyle? titleTextStyle;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double titleSpacing;
  final double? collapsedHeight;
  final double? expandedHeight;
  final bool floating;
  final ShapeBorder? shape;
  final bool snap;
  final bool stretch;
  final double stretchTriggerOffset;
  final AsyncCallback? onStretchTrigger;
  final double toolbarHeight;
  final double? leadingWidth;
  final bool pinned;
  final List<StretchMode> stretchModes;
  final SystemUiOverlayStyle customSystemUiOverlayStyle;

  static const _whiteIconTheme = IconThemeData(
    color: Colors.white,
  );

  @override
  State<FadingLargeSliverAppBar> createState() =>
      _FadingLargeSliverAppBarState();
}

class _FadingLargeSliverAppBarState extends State<FadingLargeSliverAppBar> {
  final ValueNotifier<bool> _isCollapsedValueNotifier =
      ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isCollapsedValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isCollapsedValueNotifier,
      builder: (context, isCollapsed, child) {
        return SliverAppBar.large(
          pinned: widget.pinned,
          leading: widget.leading,
          actions: widget.actions,
          actionsIconTheme: isCollapsed
              ? widget.actionsIconTheme
              : FadingLargeSliverAppBar._whiteIconTheme,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          backgroundColor: widget.backgroundColor,
          bottom: widget.bottom,
          centerTitle: widget.centerTitle,
          collapsedHeight: widget.collapsedHeight,
          elevation: widget.elevation,
          excludeHeaderSemantics: widget.excludeHeaderSemantics,
          floating: widget.floating,
          forceElevated: widget.forceElevated,
          iconTheme: isCollapsed
              ? widget.iconTheme
              : FadingLargeSliverAppBar._whiteIconTheme,
          key: widget.key,
          leadingWidth: widget.leadingWidth,
          onStretchTrigger: widget.onStretchTrigger,
          primary: widget.primary,
          shadowColor: widget.shadowColor,
          shape: widget.shape,
          snap: widget.snap,
          stretch: widget.stretch,
          stretchTriggerOffset: widget.stretchTriggerOffset,
          titleTextStyle: widget.titleTextStyle,
          titleSpacing: widget.titleSpacing,
          toolbarHeight: widget.toolbarHeight,
          foregroundColor: widget.foregroundColor,
          expandedHeight: widget.expandedHeight,
          flexibleSpace: child,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final top = constraints.biggest.height;
          final isCollapsed = widget.fadeAt >= top;

          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _updatedIsCollapsed(
              isCollapsed: isCollapsed,
              notifier: _isCollapsedValueNotifier,
            ),
          );

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: isCollapsed
                ? widget.customSystemUiOverlayStyle
                : SystemUiOverlayStyle.light,
            child: FlexibleSpaceBar(
              centerTitle: widget.centerTitle,
              stretchModes: widget.stretchModes,
              background: AnimatedOpacity(
                opacity: widget.fadeAt >= top ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: widget.background,
              ),
              title: AnimatedOpacity(
                opacity: widget.fadeAt >= top ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: widget.title,
              ),
            ),
          );
        },
      ),
    );
  }

  void _updatedIsCollapsed({
    required bool isCollapsed,
    required ValueNotifier<bool> notifier,
  }) {
    if (notifier.value == isCollapsed) return;

    setState(() => _isCollapsedValueNotifier.value = isCollapsed);
  }
}
