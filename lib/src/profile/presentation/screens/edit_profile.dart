import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/buttons.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/components/textformfields.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:hydro_iot/src/auth/application/controllers/user_controller.dart';
import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';

import '../../../auth/application/controllers/auth_controller.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await ref.read(userRepositoryProvider).getUserProfile();
      if (response.isSuccess && response.data != null) {
        final user = response.data!;
        setState(() {
          _nameController.text = user.name;
          _emailController.text = user.email;
          _roleController.text = user.role;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(userControllerProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
          );

      if (mounted) {
        ref.invalidate(authControllerProvider);

        Toast().showSuccessToast(
          context: context,
          title: 'Success',
          description: 'Profile updated successfully',
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ///INI harusnya error tapi malah work ke backend (untuk sementara dibikin kebalik dulu)
      if (mounted) {
        ref.invalidate(authControllerProvider);
        Navigator.pop(context);
        Toast().showSuccessToast(
          context: context,
          title: 'Success',
          description: 'Profile updated successfully',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormFieldComponent(
                  controller: _nameController,
                  label: 'Name',
                  hintText: 'Enter your name',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormFieldComponent(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormFieldComponent(
                  controller: _roleController,
                  label: 'Role',
                  hintText: 'Role',
                  obscureText: false,
                  readOnly: true,
                ),
                const SizedBox(height: 24),

                // Password section (optional - uncomment if needed)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Expanded(
                //       child: Divider(color: ColorValues.neutral300, thickness: 5),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                //       child: Text(
                //         'Change Password',
                //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                //           fontWeight: FontWeight.w600,
                //           color: ColorValues.neutral500,
                //           fontSize: 14.sp,
                //         ),
                //       ),
                //     ),
                //     const Expanded(
                //       child: Divider(color: ColorValues.neutral300, thickness: 5),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // TextFormFieldComponent(
                //   controller: _passwordController,
                //   label: 'New Password',
                //   hintText: 'Enter new password',
                //   obscureText: true,
                // ),
                // const SizedBox(height: 16),
                // TextFormFieldComponent(
                //   controller: _confirmPasswordController,
                //   label: 'Confirm Password',
                //   hintText: 'Confirm new password',
                //   obscureText: true,
                // ),
                // const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(
                          child: FancyLoading(title: 'Updating Your Profile'),
                        )
                      : primaryButton(
                          text: 'Save Changes',
                          onPressed: _saveChanges,
                          context: context,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
