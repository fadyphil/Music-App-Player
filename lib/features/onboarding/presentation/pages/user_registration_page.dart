import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/core/theme/app_pallete.dart';
import '../cubit/user_registration_cubit.dart';
import '../cubit/user_registration_state.dart';

class UserRegistrationPage extends StatefulWidget {
  final VoidCallback onRegistrationComplete;

  const UserRegistrationPage({
    super.key,
    required this.onRegistrationComplete,
  });

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _avatarPath;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _avatarPath = image.path;
        });
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Handle permission errors silently or show snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserRegistrationCubit, UserRegistrationState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            HapticFeedback.mediumImpact();
            widget.onRegistrationComplete();
          },
          failure: (msg) {
            HapticFeedback.vibrate();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "IDENTITY",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Create your auditory profile",
                      style: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'monospace',
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Avatar Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                          image: _avatarPath != null
                              ? DecorationImage(
                                  image: FileImage(File(_avatarPath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          border: Border.all(
                            color: AppPallete.primaryGreen.withValues(alpha: 0.5),
                            width: 2,
                          ),
                          boxShadow: _avatarPath != null
                              ? [
                                  BoxShadow(
                                    color: AppPallete.primaryGreen.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ]
                              : [],
                        ),
                        child: _avatarPath == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white54,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Inputs
                    _AnimatedInput(
                      controller: _nameController,
                      label: "CODENAME",
                      hint: "Enter your username",
                      icon: Icons.person_outline,
                      validator: (val) =>
                          val!.isEmpty ? "Identity required" : null,
                    ),
                    const SizedBox(height: 24),
                    _AnimatedInput(
                      controller: _emailController,
                      label: "FREQUENCY",
                      hint: "Enter your email",
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty) return "Frequency required";
                        if (!val.contains('@')) return "Invalid frequency format";
                        return null;
                      },
                    ),

                    const SizedBox(height: 60),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<UserRegistrationCubit>().submitForm(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        avatarPath: _avatarPath,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primaryGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text(
                                "INITIALIZE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _AnimatedInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
  });

  @override
  State<_AnimatedInput> createState() => _AnimatedInputState();
}

class _AnimatedInputState extends State<_AnimatedInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? AppPallete.primaryGreen : Colors.white24,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused ? AppPallete.primaryGreen : Colors.white54,
              fontFamily: 'monospace',
              fontSize: 12,
            ),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.white24),
            suffixIcon: Icon(
              widget.icon,
              color: _isFocused ? AppPallete.primaryGreen : Colors.white24,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
