import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final systemUiOverlayStyle = Theme.of(context).brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    final width = MediaQuery.sizeOf(context).width * 0.85;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Drawer(
        width: width,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                child: Row(
                  children: [Text('Options'), Spacer(), _CloseDrawerButton()],
                ),
              ),
              _LikedCarsListTile(),
              _ThemeListTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseDrawerButton extends StatelessWidget {
  const _CloseDrawerButton({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        right: AppConstants.spacing8,
        top: AppConstants.spacing8,
      ),
      child: CloseButton(),
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  const _ThemeListTile({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ThemeIcon(),
      title: const Text('Theme'),
      onTap: () => context.pushNamed(ThemeScreen.routeName),
    );
  }
}

class _LikedCarsListTile extends StatelessWidget {
  const _LikedCarsListTile({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(CupertinoIcons.heart_circle),
      title: const Text('Liked Car Makes'),
      onTap: () => context.pushNamed(LikedCarMakesScreen.routeName),
    );
  }
}
