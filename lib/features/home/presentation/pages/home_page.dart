import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../../local music/presentation/pages/song_list_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
// import '../widgets/prism_knob_navigation.dart'; // Option 1
// import '../widgets/neural_string_navigation.dart'; // Option 2
// import '../widgets/gravity_dock_navigation.dart'; // Option 3
import '../widgets/simple_animated_nav_bar.dart'; // Option 4: Simple Animated Nav Bar
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Content behind the nav
      body: Stack(
        children: [
          // Content Layer
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.selectedTab.index,
                children: const [
                  SongListPage(),
                  AnalyticsDashboardPage(),
                  ProfilePage(),
                ],
              );
            },
          ),

          // Gradient Fade at bottom to ensure nav visibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 160,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // NAVIGATION DECK
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                // CURRENT SELECTION: SIMPLE ANIMATED NAV BAR
                return SimpleAnimatedNavBar(
                  selectedTab: state.selectedTab,
                  onTabSelected: (tab) {
                    context.read<HomeCubit>().setTab(tab);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}