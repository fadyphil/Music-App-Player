import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../cubit/home_state.dart';

class PrismKnobNavigation extends StatefulWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  const PrismKnobNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  State<PrismKnobNavigation> createState() => _PrismKnobNavigationState();
}

class _PrismKnobNavigationState extends State<PrismKnobNavigation>
    with SingleTickerProviderStateMixin {
  // Logic Constants
  static const double _maxAngle = 45 * (math.pi / 180); // 45 degrees in radians
  static const double _snapThreshold = 20 * (math.pi / 180);

  // Animation
  late AnimationController _snapController;
  late Animation<double> _angleAnimation;

  // State
  double _currentAngle = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Heavy, damped feel
    );
    _angleAnimation = AlwaysStoppedAnimation(_getAngleForTab(widget.selectedTab));
    _currentAngle = _getAngleForTab(widget.selectedTab);
  }

  @override
  void didUpdateWidget(PrismKnobNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != oldWidget.selectedTab && !_isDragging) {
      _animateToTab(widget.selectedTab);
    }
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  double _getAngleForTab(HomeTab tab) {
    switch (tab) {
      case HomeTab.songs:
        return -_maxAngle;
      case HomeTab.analytics:
        return 0.0;
      case HomeTab.profile:
        return _maxAngle;
    }
  }

  HomeTab _getTabForAngle(double angle) {
    if (angle < -_snapThreshold) return HomeTab.songs;
    if (angle > _snapThreshold) return HomeTab.profile;
    return HomeTab.analytics;
  }

  void _animateToTab(HomeTab tab) {
    final targetAngle = _getAngleForTab(tab);
    _angleAnimation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _snapController,
      curve: Curves.easeOutBack, // Slight overshoot for realism
    ));
    
    _snapController.forward(from: 0).then((_) {
      setState(() {
        _currentAngle = targetAngle;
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _snapController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    // Just use dx sensitivity for a "virtual" knob feel
    // rather than absolute touch tracking which can be jumpy.
    
    double delta = details.delta.dx * 0.015; // Sensitivity
    
    setState(() {
      _currentAngle = (_currentAngle + delta).clamp(-_maxAngle * 1.5, _maxAngle * 1.5);
    });

    // Haptic feedback on passing thresholds (simulating detents)
    _checkHapticDetents();
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    final targetTab = _getTabForAngle(_currentAngle);
    
    // Haptic confirmation
    if (targetTab != widget.selectedTab) {
      HapticFeedback.mediumImpact();
      widget.onTabSelected(targetTab);
    } else {
      // If we snap back to same tab, just animate visual
      _animateToTab(targetTab);
    }
  }

  HomeTab? _lastDetentTab;
  void _checkHapticDetents() {
    final currentTab = _getTabForAngle(_currentAngle);
    if (currentTab != _lastDetentTab) {
      HapticFeedback.selectionClick();
      _lastDetentTab = currentTab;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Height of the control area
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Labels (Static background)
          Positioned(
            bottom: 60,
            child: SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KnobLabel(
                    label: "MUSE", 
                    isActive: widget.selectedTab == HomeTab.songs,
                    alignment: Alignment.centerLeft,
                  ),
                   _KnobLabel(
                    label: "INSIGHT", 
                    isActive: widget.selectedTab == HomeTab.analytics,
                    alignment: Alignment.center,
                  ),
                   _KnobLabel(
                    label: "AURA", 
                    isActive: widget.selectedTab == HomeTab.profile,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ),

          // The Knob itself
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: (d) => _onPanUpdate(d, const Size(200, 200)),
            onPanEnd: _onPanEnd,
            child: AnimatedBuilder(
              animation: _snapController,
              builder: (context, child) {
                final displayAngle = _isDragging ? _currentAngle : _angleAnimation.value;
                return Transform.rotate(
                  angle: displayAngle,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                     BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, -1),
                      spreadRadius: 1
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A2A2A),
                      const Color(0xFF111111),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: _KnobPainter(),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KnobLabel extends StatelessWidget {
  final String label;
  final bool isActive;
  final Alignment alignment;

  const _KnobLabel({
    required this.label, 
    required this.isActive,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.3,
      child: Container(
        width: 80,
        alignment: alignment,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 2.0,
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w400,
            color: isActive ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}

class _KnobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw Ticks
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final outerR = radius - 8;
      final innerR = radius - 16;
      
      final p1 = Offset(
        center.dx + math.cos(angle) * outerR,
        center.dy + math.sin(angle) * outerR,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * innerR,
        center.dy + math.sin(angle) * innerR,
      );

      paint.color = Colors.white.withValues(alpha: 0.1);
      paint.strokeWidth = 2;
      canvas.drawLine(p1, p2, paint);
    }

    // Draw Indicator Line (The "Pointer")
    // Points upwards (negative Y)
    final pointerP1 = Offset(center.dx, center.dy - 10);
    final pointerP2 = Offset(center.dx, center.dy - 35);
    
    paint.color = const Color(0xFFE0E0E0); // Almost white
    paint.strokeWidth = 3;
    paint.shader = const LinearGradient(
      colors: [Colors.white, Colors.grey],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromPoints(pointerP2, pointerP1));

    canvas.drawLine(pointerP1, pointerP2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}