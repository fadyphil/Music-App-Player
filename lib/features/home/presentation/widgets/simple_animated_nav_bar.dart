import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../cubit/home_state.dart';

class SimpleAnimatedNavBar extends StatelessWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  const SimpleAnimatedNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  void _handleTap(HomeTab tab) {
    if (selectedTab != tab) {
      HapticFeedback.heavyImpact(); 
      onTabSelected(tab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SimpleTabItem(
            label: "LIBRARY",
            icon: Icons.library_music_outlined,
            isSelected: selectedTab == HomeTab.songs,
            onTap: () => _handleTap(HomeTab.songs),
          ),
          _SimpleTabItem(
            label: "ANALYTICS",
            icon: Icons.bar_chart_rounded,
            isSelected: selectedTab == HomeTab.analytics,
            onTap: () => _handleTap(HomeTab.analytics),
          ),
          _SimpleTabItem(
            label: "PROFILE",
            icon: Icons.person_outline_rounded,
            isSelected: selectedTab == HomeTab.profile,
            onTap: () => _handleTap(HomeTab.profile),
          ),
        ],
      ),
    );
  }
}

class _SimpleTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SimpleTabItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : Colors.white38;
    
    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.lightImpact(); // Subtle haptic on individual item tap
      },
      child: SizedBox(
        width: 72,
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: color,
                size: 28, 
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
