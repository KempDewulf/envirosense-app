import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final Color? focusColor;
  final Color labelColor;
  final Color hintColor;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final int? maxLength;
  final VoidCallback? onTap;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final TextCapitalization textCapitalization;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled,
    this.contentPadding,
    this.borderColor,
    this.focusColor,
    this.labelColor = AppColors.secondaryColor,
    this.hintColor = AppColors.secondaryColor,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.expands,
    this.maxLength,
    this.onTap,
    this.autocorrect,
    this.enableSuggestions,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderClr = borderColor ?? Colors.grey;
    final Color focusClr = focusColor ?? Colors.blue;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      expands: expands ?? false,
      maxLength: maxLength,
      onTap: onTap,
      autocorrect: autocorrect ?? true,
      enableSuggestions: enableSuggestions ?? true,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: AppColors.whiteColor),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderClr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderClr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusClr, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: const TextStyle(color: AppColors.whiteColor),
      ),
    );
  }
}
