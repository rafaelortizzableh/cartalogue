import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../features.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cartalogue'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.heart_circle),
            onPressed: () => context.push(LikedCarMakesScreen.routeName),
          ),
          const ThemeLinkIcon(),
        ],
      ),
      body: const CarManufacturersList(),
      floatingActionButton: const NetworkConnectivyFab(),
    );
  }
}
