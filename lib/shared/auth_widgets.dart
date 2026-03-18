import 'package:flutter/material.dart';

class AuthLabeledField extends StatelessWidget {
  const AuthLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.labelStyle,
    this.spacing = 8,
  });

  final String label;
  final Widget child;
  final TextStyle? labelStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: labelStyle),
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fillColor,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.hintColor,
    this.borderRadius = 12,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String hintText;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final Color? hintColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      style: textStyle,
      decoration: InputDecoration(
        prefixIcon:
            prefixIcon == null
                ? null
                : Icon(prefixIcon, color: prefixIconColor),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: contentPadding,
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.isLoading = false,
    this.borderRadius = 12,
    this.verticalPadding = 16,
    this.height,
    this.textStyle,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final bool isLoading;
  final double borderRadius;
  final double verticalPadding;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(text, style: textStyle),
      ),
    );
  }
}
