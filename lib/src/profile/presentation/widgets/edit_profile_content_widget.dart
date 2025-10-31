import 'package:vector_graphics/vector_graphics.dart';

import '../../../../pkg.dart';

class EditProfileContentWidget extends StatelessWidget {
  const EditProfileContentWidget({
    super.key,
    this.imgUrl,
    required this.nameController,
    required this.emailController,
    required this.onPressed,
    required this.isEdited,
    required this.formKey,
    required this.onChangePicture,
  });

  final String? imgUrl;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onPressed;
  final bool isEdited;
  final GlobalKey<FormState> formKey;
  final VoidCallback onChangePicture;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorValues.green50,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorValues.green600, width: 2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: imgUrl != null
                      ? ClipOval(child: Image.network(imgUrl!, fit: BoxFit.cover, cacheWidth: 100, cacheHeight: 100))
                      : const VectorGraphic(loader: AssetBytesLoader(IconAssets.grassAvatar)),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: TextButton(
                  onPressed: onChangePicture,
                  child: Text(
                    local.changePicture,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: ColorValues.blueLink, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(local.name, style: Theme.of(context).textTheme.labelLarge),
              ),
              SizedBox(height: 10.h),
              TextFormFieldComponent(
                label: '',
                controller: nameController,
                hintText: 'Name here',
                obscureText: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text('Email', style: Theme.of(context).textTheme.labelLarge),
              ),
              SizedBox(height: 10.h),
              TextFormFieldComponent(
                label: '',
                controller: emailController,
                hintText: '',
                obscureText: false,
                readOnly: true,
              ),
              SizedBox(height: 40.h),
              Center(
                child: SizedBox(
                  width: widthQuery(context) * 0.5,
                  child: primaryButton(
                    text: local.save,
                    onPressed: isEdited ? onPressed : () {},
                    context: context,
                    color: isEdited ? null : ColorValues.neutral400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
