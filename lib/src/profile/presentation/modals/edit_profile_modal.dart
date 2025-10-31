import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/auth/application/controllers/user_controller.dart';
import 'package:hydro_iot/src/profile/presentation/widgets/edit_profile_content_widget.dart';

import '../../../../pkg.dart';

class EditProfileModal extends ConsumerStatefulWidget {
  const EditProfileModal({super.key, this.imgUrl, required this.name, required this.email});

  final String? imgUrl;
  final String name;
  final String email;

  @override
  ConsumerState<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends ConsumerState<EditProfileModal> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isEdited = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    nameController.addListener(onTextChanged);
    emailController.addListener(onTextChanged);
  }

  void onTextChanged() {
    if (!isEdited) {
      setState(() {
        isEdited = nameController.text != widget.name || emailController.text != widget.email;
      });
    }
  }

  @override
  void dispose() {
    nameController.removeListener(onTextChanged);
    emailController.removeListener(onTextChanged);
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen(userControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          Toast().showErrorToast(context: context, title: local.error, description: error.toString());
        },
        data: (message) {
          Toast().showSuccessToast(context: context, title: local.success, description: local.profileUpdatedSuccessfully);
          context.pop();
        },
        loading: () {
          FancyLoadingDialog(title: local.updatingProfile);
        },
      );
    });
    void saveProfile() {
      if (!formKey.currentState!.validate()) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }
      ref.read(userControllerProvider.notifier).updateProfile(name: nameController.text.trim());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            decoration: BoxDecoration(
              color: ColorValues.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: ColorValues.neutral200),
            ),
            margin: EdgeInsets.only(left: 16.w),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
              onPressed: () async {
                await showAdaptiveDialog(
                  context: context,
                  builder: (_) {
                    return alertDialog(
                      context: context,
                      title: local.discardYourChanges,
                      content: local.anyUnsavedChangesWillBeLost,
                      confirmText: local.discardChanges,
                      onConfirm: () async {
                        context.pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
          title: Text(
            local.editProfile,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: EditProfileContentWidget(
          imgUrl: widget.imgUrl,
          nameController: nameController,
          emailController: emailController,
          onPressed: saveProfile,
          isEdited: isEdited,
          formKey: formKey,
          onChangePicture: () {},
        ),
      ),
    );
  }
}
