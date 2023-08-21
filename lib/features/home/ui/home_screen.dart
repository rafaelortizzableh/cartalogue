import 'package:flutter/material.dart';

import '../../features.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  static const _title = 'Car Manufacturers';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: HomeDrawer(),
      body: CustomScrollView(
        slivers: [
          ExtendedHomeSliverAppBar(title: _title),
          CarManufacturersList(),
        ],
      ),
      floatingActionButton: NetworkConnectivyFab(),
    );
  }
}
