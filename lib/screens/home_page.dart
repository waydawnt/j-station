import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:j_station/screens/radio_tab.dart';
import 'package:j_station/screens/podcasts_tab.dart';
import 'package:j_station/widgets/mini_player.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  final List _tabs = const [RadioTab(), PodcastsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('J-Station'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 188, 0, 45),
      ),
      body: Column(
        children: [
          Expanded(child: _tabs[_selectedIndex]),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.radio), label: 'Live Radio'),
          NavigationDestination(icon: Icon(Icons.podcasts), label: 'Podcasts'),
        ],
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
