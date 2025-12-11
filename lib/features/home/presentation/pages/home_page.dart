import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../../local music/presentation/pages/song_list_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/prism_knob_navigation.dart';
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
      extendBody: true, // Content behind the knob
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

          // Gradient Fade at bottom to ensure knob visibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
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
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // The Prism Knob (Floating Control)
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return PrismKnobNavigation(
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
