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
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool? readOnly;

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  @override
  Widget build(BuildContext context) {
    bool isObscured = widget.obscureText;
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.neutral600),
        filled: true,
        fillColor: ColorValues.neutral200,
        border: InputBorder.none,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.danger600, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorValues.neutral300, width: 0.0, style: BorderStyle.none),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.neutral500),
        errorText: widget.validator != null ? widget.validator!(widget.controller.text) : null,
        suffixIcon: !widget.obscureText
            ? null
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
    );
  }
}
