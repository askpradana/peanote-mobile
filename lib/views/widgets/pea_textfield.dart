import 'package:flutter/material.dart';

class PeaTextfield extends StatelessWidget {
  final String hintText;
  final String? helperText;
  final TextEditingController controller;
  final bool? isPassword;
  final VoidCallback? onPressedSuffix;
  final bool? obsecureText;
  final void Function(String)? onChanged;

  const PeaTextfield({
    super.key,
    required this.hintText,
    this.helperText,
    required this.controller,
    this.isPassword = false,
    this.onPressedSuffix,
    this.obsecureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          helperText: helperText,
          suffixIcon: isPassword == true
              ? IconButton(
                  onPressed: onPressedSuffix,
                  icon: Icon(
                    obsecureText == true
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                )
              : null,
        ),
        obscureText: obsecureText ?? false,
        onChanged: onChanged,
      ),
    );
  }
}
