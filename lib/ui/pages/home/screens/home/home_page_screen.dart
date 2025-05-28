import 'package:flutter/material.dart';
import 'package:spotify_castor/ui/pages/home/components/home_page_drawer.dart';
import 'package:spotify_castor/ui/pages/home/screens/home/body/home_page_screen_body.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomePageDrawer(),
      drawerScrimColor: Theme.of(
        context,
      ).scaffoldBackgroundColor.withValues(alpha: 0.8),
      body: const HomePageHomeScreenBody(),
    );
  }
}
