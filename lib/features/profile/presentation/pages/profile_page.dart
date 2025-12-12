import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/features/onboarding/presentation/pages/onboarding_page.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
           state.maybeWhen(
             error: (msg) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
             },
             cacheCleared: () {
               Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (context) => const OnboardingPage()),
                 (route) => false,
               );
             },
             orElse: () {},
           );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (user) => _ProfileView(user: user),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final UserEntity user;
  const _ProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 160),
      children: [
        // Avatar & Info
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white10,
                backgroundImage: user.avatarUrl.isNotEmpty 
                    ? NetworkImage(user.avatarUrl) 
                    : null,
                child: user.avatarUrl.isEmpty 
                    ? const Icon(Icons.person, size: 60, color: Colors.white54)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.username,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _showEditDialog(context, user),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text("EDIT PROFILE"),
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),

        // Section: Customization
        const _SectionHeader(title: "INTERFACE MODULES"),
        const SizedBox(height: 16),
        _NavBarSelector(selectedStyle: user.preferredNavBar),

        const SizedBox(height: 32),

        // Section: System
        const _SectionHeader(title: "SYSTEM"),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
          title: const Text("Clear Cache", style: TextStyle(color: Colors.white)),
          subtitle: const Text("Purge local temporal data", style: TextStyle(color: Colors.white38, fontSize: 12)),
          onTap: () => _showClearCacheConfirmation(context),
        ),
      ],
    );
  }

  void _showClearCacheConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CONFIRM PURGE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "This will delete all user data, analytics, and reset the application to its factory state. This action cannot be undone.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("CANCEL"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<ProfileBloc>().add(const ProfileEvent.clearCache());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("PURGE DATA"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserEntity user) {
    final nameCtrl = TextEditingController(text: user.username);
    final emailCtrl = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Update Identity", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(
                ProfileEvent.updateProfile(user.copyWith(
                  username: nameCtrl.text,
                  email: emailCtrl.text,
                )),
              );
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontFamily: 'monospace',
        letterSpacing: 2.0,
      ),
    );
  }
}

class _NavBarSelector extends StatelessWidget {
  final NavBarStyle selectedStyle;
  const _NavBarSelector({required this.selectedStyle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: NavBarStyle.values.map((style) {
          final isSelected = style == selectedStyle;
          return GestureDetector(
            onTap: () {
              context.read<ProfileBloc>().add(ProfileEvent.changeNavBarStyle(style));
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2) : Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                     _getIconForStyle(style), 
                     color: isSelected ? Colors.white : Colors.white54,
                     size: 32,
                   ),
                   const SizedBox(height: 12),
                   Text(
                     style.name.toUpperCase(),
                     style: TextStyle(
                       color: isSelected ? Colors.white : Colors.white54,
                       fontSize: 10,
                       fontWeight: FontWeight.bold,
                     ),
                   )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForStyle(NavBarStyle style) {
    switch (style) {
      case NavBarStyle.simple: return Icons.crop_square;
      case NavBarStyle.prism: return Icons.radio_button_checked;
      case NavBarStyle.neural: return Icons.gesture;
      case NavBarStyle.gravity: return Icons.anchor;
    }
  }
}
