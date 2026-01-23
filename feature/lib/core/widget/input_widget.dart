import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWidget  extends StatelessWidget{

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const InputWidget({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
        ),
    );
  }

}