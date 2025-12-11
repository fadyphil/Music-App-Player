import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/home_state.dart';

class SacredBottomNavigationBar extends StatelessWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  const SacredBottomNavigationBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Dark tech palette
    final surfaceColor = const Color(0xFF1E1E1E).withValues(alpha: 0.85);
    final accentColor = theme.colorScheme.primary; // Or a custom electric color

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated Selection Indicator (The "Soul" of the bar)
                  AnimatedAlign(
                    alignment: _getAlignment(selectedTab),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut, // Physics-based spring
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 80,
                        height: 56,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.2),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                      )
                          .animate(
                            target: selectedTab == HomeTab.songs ? 1 : 0,
                          ) // Re-trigger on change? No, explicit state.
                          .shimmer(
                            duration: 1500.ms,
                            color: Colors.white24,
                          ),
                    ),
                  ),

                  // Tab Items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SacredTabItem(
                        icon: Icons.music_note_rounded,
                        label: 'LIBRARY',
                        isSelected: selectedTab == HomeTab.songs,
                        onTap: () => _handleTap(HomeTab.songs),
                      ),
                      _SacredTabItem(
                        icon: Icons.graphic_eq_rounded,
                        label: 'ANALYTICS',
                        isSelected: selectedTab == HomeTab.analytics,
                        onTap: () => _handleTap(HomeTab.analytics),
                      ),
                      _SacredTabItem(
                        icon: Icons.fingerprint_rounded,
                        label: 'IDENTITY', // "Profile" is too boring
                        isSelected: selectedTab == HomeTab.profile,
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
        return const Alignment(-0.85, 0); // Approximate centered position for left
      case HomeTab.analytics:
        return const Alignment(0, 0); // Center
      case HomeTab.profile:
        return const Alignment(0.85, 0); // Right
    }
  }

  void _handleTap(HomeTab tab) {
    if (selectedTab != tab) {
      HapticFeedback.lightImpact(); // Platform-adaptive haptic
      onTabSelected(tab);
    }
  }
}

class _SacredTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SacredTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = Colors.white38;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        height: 72, // Full height of container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            )
                .animate(target: isSelected ? 1 : 0)
                .scaleXY(
                  end: 1.1,
                  duration: 300.ms,
                  curve: Curves.easeOutBack,
                )
                .tint(color: activeColor),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.0,
              child: Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  fontFamily: 'monospace', // Techy vibe
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}