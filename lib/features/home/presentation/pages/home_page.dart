import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../../local music/presentation/pages/song_list_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/sacred_bottom_navigation_bar.dart';
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
      extendBody: true, // Crucial for glassmorphism over body
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

          // Navigation Layer (Floating)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return SacredBottomNavigationBar(
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
