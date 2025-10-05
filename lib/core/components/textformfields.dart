import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

class TextFormFieldComponent extends StatefulWidget {
  const TextFormFieldComponent({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.readOnly,
    this.onChanged,
    this.validator,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool? readOnly;
  final Widget? suffixIcon;

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  late bool isObscured;

  @override
  void initState() {
    isObscured = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscured,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        border: InputBorder.none,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.danger600, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.danger600, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.neutral300, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.neutral500),
        suffixIcon: !widget.obscureText
            ? widget.suffixIcon
            : isObscured
            ? IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isObscured = false;
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  setState(() {
                    isObscured = true;
                  });
                },
              ),
      ),
      onChanged: widget.onChanged,
      readOnly: widget.readOnly ?? false,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: dmSansNormalText(
        color: Theme.brightnessOf(context) == Brightness.dark ? ColorValues.whiteColor : ColorValues.neutral700,
      ),
    );
  }
}
