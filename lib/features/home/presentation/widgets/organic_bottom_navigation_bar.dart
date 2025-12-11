import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/home_state.dart';

class OrganicBottomNavigationBar extends StatelessWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  const OrganicBottomNavigationBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Soft, deep organic palette
    final barColor = const Color(0xFF181818).withValues(alpha: 0.6);
    
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40), // Softer, more organic radius
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Dreamy blur
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Fluid Active Indicator (The "Orb")
                  AnimatedAlign(
                    alignment: _getAlignment(selectedTab),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.fastLinearToSlowEaseIn, // Fluid, not springy
                    child: FractionallySizedBox(
                      widthFactor: 0.33,
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF98FF98).withValues(alpha: 0.1), // Mint glow
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ).animate(
                          onPlay: (controller) => controller.repeat(reverse: true),
                        ).scaleXY(
                          begin: 1.0,
                          end: 1.15,
                          duration: 2000.ms,
                          curve: Curves.easeInOutSine,
                        ),
                      ),
                    ),
                  ),

                  // Tab Items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _OrganicTabItem(
                        title: 'Muse',
                        isActive: selectedTab == HomeTab.songs,
                        onTap: () => _handleTap(HomeTab.songs),
                      ),
                      _OrganicTabItem(
                        title: 'Insight',
                        isActive: selectedTab == HomeTab.analytics,
                        onTap: () => _handleTap(HomeTab.analytics),
                      ),
                      _OrganicTabItem(
                        title: 'Aura',
                        isActive: selectedTab == HomeTab.profile,
                        onTap: () => _handleTap(HomeTab.profile),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(HomeTab tab) {
    switch (tab) {
      case HomeTab.songs:
        return const Alignment(-1.0, 0);
      case HomeTab.analytics:
        return const Alignment(0, 0);
      case HomeTab.profile:
        return const Alignment(1.0, 0);
    }
  }

  void _handleTap(HomeTab tab) {
    if (selectedTab != tab) {
      HapticFeedback.selectionClick(); // Subtler click
      onTabSelected(tab);
    }
  }
}

class _OrganicTabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _OrganicTabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          color: Colors.transparent, // Hit target
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              fontFamily: 'Roboto', // Default, but styled elegantly
              fontSize: isActive ? 16 : 14,
              fontWeight: isActive ? FontWeight.w300 : FontWeight.w200, // Light/Thin weights
              letterSpacing: isActive ? 1.5 : 0.5,
              color: isActive 
                  ? const Color(0xFFF0F0F0) 
                  : const Color(0xFFAAAAAA).withValues(alpha: 0.6),
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
