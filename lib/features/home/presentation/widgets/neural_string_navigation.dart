import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../cubit/home_state.dart';

class NeuralStringNavigation extends StatefulWidget {
  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  const NeuralStringNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  State<NeuralStringNavigation> createState() => _NeuralStringNavigationState();
}

class _NeuralStringNavigationState extends State<NeuralStringNavigation>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  
  // Physics State
  double _pluckAmplitude = 0.0;
  double _pluckTargetX = 0.5; // Normalized 0..1
  
  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Long tail resonance
    )..addListener(() {
        setState(() {
          // Dampen the amplitude over time
          _pluckAmplitude *= 0.92;
        });
      });
  }

  @override
  void didUpdateWidget(NeuralStringNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != oldWidget.selectedTab) {
      _triggerPluck(widget.selectedTab);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _triggerPluck(HomeTab tab) {
    _pluckTargetX = _getTabPosition(tab);
    _pluckAmplitude = 25.0; // Max height of wave
    _waveController.forward(from: 0);
  }

  double _getTabPosition(HomeTab tab) {
    switch (tab) {
      case HomeTab.songs:
        return 0.16; // 1/6
      case HomeTab.analytics:
        return 0.5; // Center
      case HomeTab.profile:
        return 0.83; // 5/6
    }
  }

  void _handleTap(HomeTab tab) {
    if (widget.selectedTab != tab) {
      HapticFeedback.lightImpact();
      widget.onTabSelected(tab);
      // Animation triggered in didUpdateWidget
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cyberpunk / Synthwave Palette
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. The Neural String (Custom Painter)
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _StringPainter(
                  amplitude: _pluckAmplitude,
                  targetX: _pluckTargetX,
                  time: _waveController.value * 20, // Speed of oscillation
                  color: primaryColor,
                ),
              );
            },
          ),

          // 2. Touch Targets & Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HoloIcon(
                icon: Icons.music_note_rounded,
                label: "FLUX",
                isSelected: widget.selectedTab == HomeTab.songs,
                onTap: () => _handleTap(HomeTab.songs),
              ),
              _HoloIcon(
                icon: Icons.graphic_eq,
                label: "PULSE",
                isSelected: widget.selectedTab == HomeTab.analytics,
                onTap: () => _handleTap(HomeTab.analytics),
              ),
              _HoloIcon(
                icon: Icons.qr_code_2, // Abstract identity
                label: "NODE",
                isSelected: widget.selectedTab == HomeTab.profile,
                onTap: () => _handleTap(HomeTab.profile),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoloIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoloIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected 
        ? Theme.of(context).colorScheme.primary 
        : Colors.white.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Holographic Glow Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: -5,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            // Glitch Text Effect
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                letterSpacing: isSelected ? 3.0 : 1.0,
                color: color,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w300,
                shadows: isSelected
                    ? [
                        Shadow(
                          color: color,
                          blurRadius: 8,
                        )
                      ]
                    : [],
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _StringPainter extends CustomPainter {
  final double amplitude;
  final double targetX; // 0.0 to 1.0
  final double time;
  final Color color;

  _StringPainter({
    required this.amplitude,
    required this.targetX,
    required this.time,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2); // Neon glow

    final path = Path();
    final width = size.width;
    final centerY = 15.0; // Moved to the top of the 100px height for the nav bar

    path.moveTo(0, centerY);

    // Resolution of simulation
    const int segments = 100;
    
    for (int i = 0; i <= segments; i++) {
      final xRatio = i / segments;
      final x = width * xRatio;
      
      // Physics: Gaussian function centered at targetX multiplied by Sine wave
      // creating a localized standing wave pulse
      final dist = (xRatio - targetX).abs();
      
      // Bell curve width (how wide the wave spreads)
      final spread = 0.15; 
      final gaussian = math.exp(-(dist * dist) / (2 * spread * spread));
      
      // Oscillation
      final wave = math.sin(time) * amplitude * gaussian;
      
      // Secondary harmonics for realism (string timbre)
      final harmonic = math.sin(time * 2.5 + xRatio * 10) * (amplitude * 0.2) * gaussian;

      path.lineTo(x, centerY - wave - harmonic);
    }

    // Draw Glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StringPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude || oldDelegate.time != time;
  }
}